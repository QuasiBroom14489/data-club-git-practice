#!/usr/bin/env bash
# Checks the member card added by a practice pull request.
#
# Usage: check_member_card.sh <pr-author-login> [base-ref]
#
# Every failure here is somebody's first red X on a pull request, so every message
# says what is wrong AND the exact command or edit that fixes it. Keep it that way.
#
# Written for bash 3.2 so it can be run and tested on a stock Mac, not just in CI.

set -uo pipefail

AUTHOR="${1:?usage: check_member_card.sh <pr-author-login> [base-ref]}"
BASE="${2:-main}"

D=()                                  # detail lines for the next message
d() { D+=("$@"); }
d_block() {                           # append a multi-line string, indented
  while IFS= read -r _l; do D+=("    $_l"); done <<< "$1"
}

print_details() {
  local i=0
  while [ $i -lt ${#D[@]} ]; do printf '  %s\n' "${D[$i]}"; i=$((i + 1)); done
}

fail() {
  printf '\n\033[31m[FAIL] %s\033[0m\n' "$1"
  [ ${#D[@]} -gt 0 ] && print_details
  printf '\n  Fix it on your branch, then commit and push again. The pull request\n'
  printf '  updates itself and this check re-runs. You do not need a new one.\n\n'
  exit 1
}

pass() { printf '\n\033[32m[OK] %s\033[0m\n\n' "$1"; exit 0; }

# --- what this branch changed ---------------------------------------------------
if ! git rev-parse --verify --quiet "origin/$BASE" >/dev/null 2>&1; then
  git fetch --no-tags --quiet origin "$BASE" >/dev/null 2>&1 || true
fi
BASE_REF="origin/$BASE"
git rev-parse --verify --quiet "$BASE_REF" >/dev/null 2>&1 || BASE_REF="$BASE"
BASE_SHA="$(git merge-base "$BASE_REF" HEAD 2>/dev/null || git rev-parse "$BASE_REF")"

CHANGED=()
while IFS= read -r line; do
  [ -n "$line" ] && CHANGED+=("$line")
done < <(git diff --name-only "$BASE_SHA" HEAD -- members/)

# 1. Nothing under members/ touched, so this is not a member-card pull request.
#    The repo's own README and workflow changes land here and must not be blocked.
if [ ${#CHANGED[@]} -eq 0 ]; then
  pass "No files under members/ changed, so there is no card to check."
fi

echo "Files changed under members/:"
printf '  %s\n' "${CHANGED[@]}"

# 2. The template is shared, so editing it changes it for everyone.
for f in "${CHANGED[@]}"; do
  if [ "$f" = "members/_TEMPLATE.md" ]; then
    d "That file is the blank template everyone copies, so it has to stay blank."
    d "You want a new file of your own instead:"
    d ""
    d "    git checkout $BASE_REF -- members/_TEMPLATE.md"
    d "    cp members/_TEMPLATE.md members/$AUTHOR.md"
    d ""
    d "Then edit members/$AUTHOR.md and leave the template alone."
    fail "You edited members/_TEMPLATE.md"
  fi
done

# 3. Exactly one card per pull request.
if [ ${#CHANGED[@]} -gt 1 ]; then
  d "Add only your own card. If you added a file by accident, remove it:"
  d ""
  d "    git rm <the-file-you-did-not-mean-to-add>"
  d "    git commit -m \"Remove file added by mistake\""
  d ""
  d "The real South Shore repo has the same rule for a different reason:"
  d "small pull requests get reviewed quickly, big ones sit for days."
  fail "This pull request changes ${#CHANGED[@]} files under members/, and it should change exactly 1"
fi

CARD="${CHANGED[0]}"
NAME="$(basename "$CARD")"
lower() { printf '%s' "$1" | tr '[:upper:]' '[:lower:]'; }

# 4. Filename must match the pull request author, compared case-insensitively.
#    Case matters here only because usernames like "Xhershey90" are mixed case and
#    nobody should fail their first pull request over a capital letter.
if [ "$(lower "$NAME")" != "$(lower "$AUTHOR.md")" ]; then
  d "The file has to match the GitHub username that opened this pull request"
  d "($AUTHOR), so it is obvious whose card is whose. Rename it:"
  d ""
  d "    git mv $CARD members/$AUTHOR.md"
  d "    git commit -m \"Rename card to match my GitHub username\""
  d ""
  d "Capital letters are fine. Any casing of $AUTHOR.md passes."
  fail "Your card is named $NAME, but it needs to be named $AUTHOR.md"
fi

if [ ! -f "$CARD" ]; then
  d "This check expects your pull request to add a new card. If you meant to"
  d "delete something, leave a comment on the pull request and a lead will help."
  fail "members/$NAME was deleted rather than added"
fi

# 5. Placeholders left in. This is the most common failure by a wide margin.
if grep -qE '<[^>]+>' "$CARD" 2>/dev/null; then
  d "These lines still have the angle brackets from the template:"
  d ""
  d_block "$(grep -nE '<[^>]+>' "$CARD")"
  d ""
  d "Replace each <...> with your own text, brackets and all, so that"
  d "\"- **GitHub username:** <your-username>\" becomes"
  d "\"- **GitHub username:** $AUTHOR\"."
  fail "Your card still has template placeholders in it"
fi

# 6. The three required fields, plus a real title.
missing=()
grep -qE '^# .+'                                                   "$CARD" || missing+=("a title line starting with '# ' and your name")
grep -qE '^- \*\*GitHub username:\*\* *\S'                         "$CARD" || missing+=("- **GitHub username:** ...")
grep -qE "^- \*\*Role I'm most interested in:\*\* *\S"             "$CARD" || missing+=("- **Role I'm most interested in:** ...")
grep -qE '^- \*\*Something I want to learn this semester:\*\* *\S' "$CARD" || missing+=("- **Something I want to learn this semester:** ...")

if [ ${#missing[@]} -gt 0 ]; then
  d "Missing:"
  d ""
  i=0; while [ $i -lt ${#missing[@]} ]; do d "    ${missing[$i]}"; i=$((i + 1)); done
  d ""
  d "Compare your file against members/_TEMPLATE.md. The labels have to match it"
  d "exactly, including the ** bold markers and the colon."
  fail "Your card is missing ${#missing[@]} required line(s)"
fi

# 7. One role, not all three.
ROLE_LINE="$(grep -E "^- \*\*Role I'm most interested in:\*\*" "$CARD" | head -1)"
ROLE="$(printf '%s' "${ROLE_LINE#*:\*\* }" | sed 's/[[:space:]]*$//')"

if printf '%s' "$ROLE" | grep -q '|'; then
  d "Your card says: $ROLE"
  d ""
  d "The template lists all three separated by | so you can see the options."
  d "Delete the two that are not you, leaving one of:"
  d ""
  d "    dbt Engineer"
  d "    BI Engineer"
  d "    Marketing Analyst"
  d ""
  d "Not sure yet? Put the one you lean toward. Roles are not locked in."
  fail "Pick one role instead of listing all three"
fi

if ! printf '%s' "$ROLE" | grep -qiE '^(dbt Engineer|BI Engineer|Marketing Analyst)$'; then
  d "Use one of these, spelled this way:"
  d ""
  d "    dbt Engineer"
  d "    BI Engineer"
  d "    Marketing Analyst"
  fail "\"$ROLE\" is not one of the three project roles"
fi

pass "members/$NAME looks good. One card, named after you, all fields filled in."
