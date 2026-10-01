#!/usr/bin/env bash
# Who has finished the practice walkthrough, and who is stuck where.
#
#   ./scripts/progress.sh
#
# Needs the GitHub CLI, signed in as a repo admin:  gh auth login
#
# Deliberately reads everything from the GitHub API instead of carrying a list of
# names, so no team roster ends up committed to a public repo.

set -uo pipefail

REPO="${REPO:-QuasiBroom14489/data-club-git-practice}"

command -v gh >/dev/null 2>&1 || { echo "Needs the GitHub CLI: brew install gh"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "Run: gh auth login"; exit 1; }

echo "Practice repo progress — $REPO"
echo "$(date '+%Y-%m-%d %H:%M')"
echo

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# --- gather ---------------------------------------------------------------------
gh api "repos/$REPO/collaborators" --paginate --jq '.[].login' 2>/dev/null \
  | tr '[:upper:]' '[:lower:]' | sort -u > "$tmp/accepted"

gh api "repos/$REPO/invitations" --paginate --jq '.[].invitee.login' 2>/dev/null \
  | tr '[:upper:]' '[:lower:]' | sort -u > "$tmp/pending"

gh api "repos/$REPO/contents/members?ref=main" --jq '.[].name' 2>/dev/null \
  | grep -v '^_TEMPLATE.md$' | sed 's/\.md$//' \
  | tr '[:upper:]' '[:lower:]' | sort -u > "$tmp/cards"

gh pr list --repo "$REPO" --state all --limit 200 \
  --json number,author,state,mergedAt,isDraft 2>/dev/null > "$tmp/prs.json"

# --- per-person table -----------------------------------------------------------
printf '%-22s %-10s %-26s %s\n' "GITHUB USER" "INVITE" "PULL REQUEST" "CARD ON MAIN"
printf '%-22s %-10s %-26s %s\n' "----------------------" "----------" "--------------------------" "------------"

cat "$tmp/accepted" "$tmp/pending" | sort -u > "$tmp/everyone"

done_count=0; total=0
while IFS= read -r user; do
  [ -n "$user" ] || continue
  total=$((total + 1))

  if grep -qx "$user" "$tmp/accepted"; then invite="accepted"; else invite="PENDING"; fi

  pr="$(jq -r --arg u "$user" '
    [ .[] | select((.author.login // "" | ascii_downcase) == $u) ]
    | if length == 0 then "none opened"
      else ( sort_by(.number) | last
             | if .mergedAt != null then "MERGED (#\(.number))"
               elif .state == "CLOSED" then "closed, not merged (#\(.number))"
               elif .isDraft then "draft, open (#\(.number))"
               else "open, awaiting review (#\(.number))" end )
      end' "$tmp/prs.json" 2>/dev/null)"
  [ -n "$pr" ] || pr="none opened"

  if grep -qx "$user" "$tmp/cards"; then card="yes"; done_count=$((done_count + 1)); else card="-"; fi

  printf '%-22s %-10s %-26s %s\n' "$user" "$invite" "$pr" "$card"
done < "$tmp/everyone"

echo
echo "Finished (card merged to main): $done_count of $total invited"

# --- cards on main with no matching collaborator ---------------------------------
if [ -s "$tmp/cards" ]; then
  orphans="$(comm -23 "$tmp/cards" "$tmp/everyone" | tr '\n' ' ')"
  [ -n "${orphans// /}" ] && echo "Cards with no current collaborator (removed, or renamed): $orphans"
fi

# --- what needs Zane ------------------------------------------------------------
echo
waiting="$(jq -r '[ .[] | select(.mergedAt == null and .state == "OPEN" and .isDraft == false) ] | length' "$tmp/prs.json" 2>/dev/null)"
if [ "${waiting:-0}" -gt 0 ]; then
  echo "$waiting pull request(s) open and waiting on a review:"
  jq -r '.[] | select(.mergedAt == null and .state == "OPEN" and .isDraft == false)
         | "  #\(.number)  \(.author.login)"' "$tmp/prs.json"
  echo
  echo "  Review them:  gh pr view <number> --repo $REPO --web"
fi

if [ -s "$tmp/pending" ]; then
  echo "Invites not yet accepted: $(tr '\n' ' ' < "$tmp/pending")"
  echo "  They need to click the link in their email, or the banner on the repo page."
fi
