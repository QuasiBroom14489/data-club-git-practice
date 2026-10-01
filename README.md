# Git practice — ND Data Club × South Shore Analytics

![Practice](https://img.shields.io/badge/Repo-Practice%20only-6f42c1)
![Workflow](https://img.shields.io/badge/Workflow-Pull%20Requests-181717?logo=github&logoColor=white)
![Safe](https://img.shields.io/badge/Breaking%20things-Encouraged-2da44e)

This is a **practice repository**. Nothing in it is real, nothing in it matters, and you
cannot break anything that anyone will miss. Its only job is to get the whole GitHub
workflow working on your laptop *before* we get access to South Shore's actual repo, so
that day one on the real project is spent writing SQL instead of debugging installs.

You are going to do one small task: **add a file with your name on it, and get it merged
through a pull request.** That is the same loop you will repeat every time you touch the
real project all semester.

> [!IMPORTANT]
> There is no South Shore data, code, or anything confidential in this repo, and none
> should ever be added to it. This is invented practice content on purpose. When the real
> repo opens, the rules in the project NDA apply there — not here.

**Time:** about 30 minutes the first time, most of it installing things. The actual git
part is about 5 minutes once you are set up.

---

## Contents

- [Two ways to do this](#two-ways-to-do-this)
- [Step 0 — GitHub account and invite](#step-0--github-account-and-invite)
- [Step 1 — Install git](#step-1--install-git)
- [Step 2 — Tell git who you are](#step-2--tell-git-who-you-are)
- [Step 3 — Sign in so that pushing works](#step-3--sign-in-so-that-pushing-works)
- [Step 4 — Clone this repo](#step-4--clone-this-repo)
- [Step 5 — Make your own branch](#step-5--make-your-own-branch)
- [Step 6 — Add your card](#step-6--add-your-card)
- [Step 7 — Commit](#step-7--commit)
- [Step 8 — Push](#step-8--push)
- [Step 9 — Open the pull request](#step-9--open-the-pull-request)
- [Step 10 — Check, approval, merge](#step-10--check-approval-merge)
- [Step 11 — Come back to main](#step-11--come-back-to-main)
- [When it goes wrong](#when-it-goes-wrong)
- [The seven commands, for later](#the-seven-commands-for-later)

---

## Two ways to do this

Pick one. Both are completely legitimate and both end in the same place.

| | **Terminal** | **GitHub Desktop** |
| --- | --- | --- |
| What it is | Typing commands | Clicking buttons in an app |
| Good if | You are comfortable in a terminal, or want to be | You have never used a terminal and would rather not start today |
| Downside | Unfamiliar at first | Hides what is actually happening |

> [!NOTE]
> If you are a Marketing Analyst or you are not a CS major, **GitHub Desktop is the right
> choice** and nobody will think less of you for it. South Shore's rules are about AI
> tools, not about terminals. Every step below has both versions.

If you go the Desktop route, install it once from **[desktop.github.com](https://desktop.github.com)**
— it includes git and handles signing in for you, which means you can skip Steps 1, 2 and 3
almost entirely. Jump to [Step 0](#step-0--github-account-and-invite), then follow the
*GitHub Desktop* half of each step.

---

## Step 0 — GitHub account and invite

**0a.** If you do not have a GitHub account, make one at
**[github.com/signup](https://github.com/signup)**. It is free. Use whatever email you like,
but remember which one — Step 2 needs it.

**0b.** **Send Zane your GitHub username.** Not your email, your username — the thing that
shows up in `github.com/<this-part>`. This is the one piece Zane cannot do for you, and
until he has it he cannot give you access to this repo or to South Shore's.

**0c.** You will get an email invitation, or a banner at the top of this page. **Accept it.**
Until you do, you can read this repo but not push to it.

> [!TIP]
> Invites expire after 7 days. If yours did, message Zane and he will resend it.

---

## Step 1 — Install git

*GitHub Desktop users: skip this, you already have git. Go to [Step 2](#step-2--tell-git-who-you-are).*

### macOS

Open **Terminal** (Cmd+Space, type "terminal", Enter) and run:

```bash
git --version
```

If you see a version number like `git version 2.50.1`, you already have git — move on.

If a dialog pops up offering to install the **Command Line Developer Tools**, click
**Install** and wait. It is a few minutes and a couple of GB. When it finishes, run
`git --version` again.

<details>
<summary>If you have Homebrew and would rather use it</summary>

```bash
brew install git
```

Either way is fine. The Apple one is less hassle if you do not already have Homebrew.
</details>

### Windows

Download the installer from **[git-scm.com/download/win](https://git-scm.com/download/win)**
and run it. **Accept every default** — the defaults are correct and the options are
jargon-heavy. This also installs:

- **Git Bash**, a terminal that behaves like the Mac one, so every command in this guide
  works as written. Use Git Bash, not PowerShell or Command Prompt.
- **Git Credential Manager**, which handles signing in. That saves you Step 3.

Then open **Git Bash** from the Start menu and run:

```bash
git --version
```

---

## Step 2 — Tell git who you are

Git stamps your name and email on every snapshot you save. It does not know them yet.

### Terminal

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Check it took:

```bash
git config --global --list
```

> [!IMPORTANT]
> Use an email that is **on your GitHub account**. If you use some other address, your
> commits still work but GitHub will not connect them to your profile — they show up as
> a stranger with no avatar, and on the real project that makes reviewing harder than it
> needs to be.
>
> Not sure which emails are on your account? They are at
> [github.com/settings/emails](https://github.com/settings/emails). If you would rather not
> have your address in public commit history, that page also gives you a
> `...@users.noreply.github.com` address you can use instead.

### GitHub Desktop

It fills this in from your account when you sign in, so there is nothing to do. You can
see it under **Settings → Git** if you want to check.

---

## Step 3 — Sign in so that pushing works

This is the step that trips people up, so it gets its own section.

**GitHub removed password authentication in 2021.** So if you just start pushing, git asks
for a password, you type your GitHub password, and it fails — with an error that does not
mention any of this. Setting up sign-in *first* avoids the whole thing.

### Terminal

Install the GitHub CLI, then log in with it. It is the shortest path by a wide margin.

```bash
# macOS
brew install gh

# Windows (in Git Bash or PowerShell)
winget install --id GitHub.cli
```

<details>
<summary>No Homebrew or winget?</summary>

Grab the installer from [cli.github.com](https://cli.github.com). Or skip `gh` entirely and
use GitHub Desktop instead — it solves the same problem.
</details>

Then:

```bash
gh auth login
```

Answer the prompts: **GitHub.com** → **HTTPS** → **Yes** (authenticate Git with your
GitHub credentials) → **Login with a web browser**. Copy the one-time code it shows you,
press Enter, paste the code in the browser window that opens, and approve.

Confirm it worked:

```bash
gh auth status
```

That is sign-in done, permanently, for every repo. You will not have to think about it again.

> [!NOTE]
> **Windows users**, Git Credential Manager came with your git install and will pop open a
> browser window the first time you push. That works too — if you would rather not install
> `gh`, you can skip this step and just handle that popup when it appears at Step 8.

### GitHub Desktop

**File → Options → Accounts → Sign in**, and follow the browser prompt. Done.

---

## Step 4 — Clone this repo

"Clone" means download a copy that stays connected to GitHub.

### Terminal

```bash
cd ~/Desktop
git clone https://github.com/QuasiBroom14489/data-club-git-practice.git
cd data-club-git-practice
```

You now have a folder on your Desktop. Confirm git sees it:

```bash
git status
```

You want `On branch main` and `nothing to commit, working tree clean`. If you instead get
`fatal: not a git repository`, you are in the wrong folder — run the `cd` line again.

### GitHub Desktop

**File → Clone repository → URL**, paste
`https://github.com/QuasiBroom14489/data-club-git-practice`, pick where to put it, and click
**Clone**.

---

## Step 5 — Make your own branch

A branch is your own copy of the project to work in, so half-finished work never breaks
anyone else's. Everyone gets their own; they do not interfere.

### Terminal

Replace `<your-username>` with your actual GitHub username, no angle brackets:

```bash
git checkout -b onboarding/<your-username>
```

So for a user named `madisonreitmayer` that is exactly:

```bash
git checkout -b onboarding/madisonreitmayer
```

### GitHub Desktop

**Current Branch** at the top → **New Branch** → name it `onboarding/your-username` →
**Create Branch**.

> [!NOTE]
> On the real South Shore repo, branches get named after the work instead of after you —
> `feature/stg-linkedin-posts`, for a model called `stg_linkedin__posts`. Same idea, same
> commands. Here we use your username because it is shorter and guaranteed not to collide
> with anyone.

---

## Step 6 — Add your card

Copy the template to a file named after you, then fill it in.

### Terminal

```bash
cp members/_TEMPLATE.md members/<your-username>.md
```

Then open that new file in any editor — VS Code, TextEdit, Notepad, whatever — and replace
the placeholders. It starts like this:

```markdown
# <Your name>

- **GitHub username:** <your-username>
- **Role I'm most interested in:** dbt Engineer | BI Engineer | Marketing Analyst
- **Something I want to learn this semester:** <one line>
```

and should end up like this:

```markdown
# Madison Reitmayer

- **GitHub username:** madisonreitmayer
- **Role I'm most interested in:** dbt Engineer
- **Something I want to learn this semester:** How a dashboard actually gets built, start to finish.
```

Three rules, all of which the automated check will tell you about if you miss them:

1. The filename matches your GitHub username.
2. No `<angle brackets>` left anywhere — replace the brackets along with the text.
3. **Pick one role.** The template lists all three so you can see the options; delete the
   two that are not you. Leaning toward one is fine, nothing is locked in.

### GitHub Desktop

Same thing — duplicate `members/_TEMPLATE.md` in Finder or File Explorer, rename the copy
to `your-username.md`, and edit it. Desktop will notice the new file on its own.

---

## Step 7 — Commit

A commit is one saved snapshot with a note about what changed.

### Terminal

```bash
git add members/<your-username>.md
git commit -m "Add member card for Your Name"
```

<details>
<summary>What is <code>git add</code> actually for?</summary>

Git does not save everything you changed — it saves what you *selected*. `git add` is the
selecting. You will also see `git add .` which means "everything I changed," and that is
what South Shore's README uses. Naming the one file is a safer habit: it makes it much
harder to commit something by accident, which on the real project could mean credentials
or a data export.
</details>

> [!TIP]
> Write what changed and why — "Add staging model for LinkedIn posts", not "update". You
> will be reading your own messages in three months.

### GitHub Desktop

Your change is in the left-hand panel with a checkbox. Type a summary in the **Summary**
box at the bottom left, then click **Commit to onboarding/your-username**.

---

## Step 8 — Push

Push sends your branch up to GitHub, where other people can see it.

### Terminal

```bash
git push -u origin onboarding/<your-username>
```

The `-u` part only matters the first time on a branch; after that `git push` alone is enough.

If a browser window opens asking you to sign in, that is Git Credential Manager doing its
job — approve it and the push continues.

### GitHub Desktop

Click **Publish branch** (it becomes **Push origin** afterward).

---

## Step 9 — Open the pull request

A pull request is you saying "here is my change, please look at it before it goes into the
shared copy."

1. Go to the **[repo on github.com](https://github.com/QuasiBroom14489/data-club-git-practice)**.
   There is a yellow banner near the top about your branch, with a green **Compare & pull
   request** button. Click it.
   *(Desktop also offers a **Create Pull Request** button, which opens the same page.)*
2. The description is pre-filled with a short checklist. Read it, tick the boxes.
3. On the right, under **Reviewers**, request **Zane** or **Brigid**.
4. Click **Create pull request**.

> [!NOTE]
> You cannot approve your own pull request — GitHub does not allow it, on purpose. That is
> the entire point of review: somebody other than you looks at it. On the real project,
> this is how bad SQL gets caught before it runs against South Shore's data.

---

## Step 10 — Check, approval, merge

Three things happen on your pull request page, in this order.

**1. The automated check runs.** You will see `check-member-card` with a spinner, then
either a green tick or a red X. It takes under a minute.

If it is **red**, that is fine and expected sometimes — click **Details** to see why. The
message tells you exactly what to change. Fix it on your branch, commit, push, and the same
pull request re-runs the check by itself. **Do not open a new pull request.**

On the real repo this step is `dbt build` instead, and it does the same job: catch the
mechanical problems before a human spends time on it.

**2. A lead approves it.** You will get an email. If it has been a day, nudge Zane — the
review is on him, not on you.

**3. You click Merge.** Once the check is green and the approval is in, the **Merge pull
request** button goes green. *You* press it — you do not hand off to anybody. Then
**Confirm merge**, and optionally **Delete branch** when it offers, which is just
tidying up.

> [!TIP]
> Merge button greyed out? Hover it and GitHub says what is missing — usually "Review
> required" (waiting on a lead) or a red check (go back to 1).

---

## Step 11 — Come back to main

One step left, and it is the one people skip. Your change is in the shared copy now, but
your laptop does not know that yet.

### Terminal

```bash
git checkout main
git pull
ls members/
```

You should see your own card, plus everyone else's who has finished. That is the proof the
loop closed: your work went out, and everyone else's came back in.

### GitHub Desktop

**Current Branch → main**, then **Fetch origin** / **Pull origin**.

**That's it. You're done.** You just did the entire workflow you will use all semester.

> [!IMPORTANT]
> Those two commands are also the *first* thing you do next time you sit down to work, every
> time, before making a new branch. Starting from a stale copy of `main` is what causes
> merge conflicts, which is the one genuinely annoying thing in git. Pull first and you
> mostly avoid them.

---

## When it goes wrong

Everything here has happened to all of us. None of it means you broke anything.

<details>
<summary><b>It asked for my password and then said authentication failed</b></summary>

GitHub turned off password sign-in in 2021, so your real password cannot work here. Do
[Step 3](#step-3--sign-in-so-that-pushing-works) — `gh auth login` — and push again.
</details>

<details>
<summary><b><code>fatal: not a git repository</code></b></summary>

You are running git in a folder that is not the project. Change into it:

```bash
cd ~/Desktop/data-club-git-practice
git status
```

`pwd` prints where you currently are, if you are unsure.
</details>

<details>
<summary><b>I forgot to branch and committed on <code>main</code></b></summary>

Common, and harmless. Your commit is sitting on local `main`; move it onto a branch:

```bash
git checkout -b onboarding/<your-username>
```

The commit comes with you. Then reset your local `main` back to match GitHub:

```bash
git branch -f main origin/main
```

Then carry on at [Step 8](#step-8--push). You will not have pushed anything bad — `main` on
GitHub refuses direct pushes, which is exactly why that protection is turned on.
</details>

<details>
<summary><b>I pushed and GitHub rejected it: "protected branch"</b></summary>

You pushed to `main` instead of your branch. Nothing is damaged — the rule caught it, which
is the rule working. Check where you are with `git status`, then follow the entry above.
</details>

<details>
<summary><b>The check is red</b></summary>

Click **Details** next to `check-member-card`. The failure message names the problem and
the fix. The usual causes, in order of how often they happen:

1. `<angle brackets>` still in the file
2. Filename does not match your GitHub username
3. All three roles still listed instead of one

Fix, commit, push. Same pull request, no new one needed.
</details>

<details>
<summary><b>I named my branch or my file wrong</b></summary>

Rename the file:

```bash
git mv members/wrong-name.md members/<your-username>.md
git commit -m "Rename card to match my GitHub username"
git push
```

A wrong *branch* name does not matter at all — the check does not look at it. Leave it.
</details>

<details>
<summary><b>My commit shows up as someone else, or with no avatar</b></summary>

The email in [Step 2](#step-2--tell-git-who-you-are) is not on your GitHub account. Fix it:

```bash
git config --global user.email "the-email-on-your-github@example.com"
```

That applies to future commits. For this one, ask Zane — or leave it, since this is practice.
</details>

<details>
<summary><b>Something else, or I am stuck</b></summary>

Message Zane with what you ran and what it said — a screenshot of the terminal is perfect.
Being stuck here is useful information: it means we fix it now instead of during the real
kickoff. That is literally what this repo is for.
</details>

---

## The seven commands, for later

Once you have done this once, it is the same handful of commands in nearly the same order,
every time, forever.

| Command | What it does | When |
| --- | --- | --- |
| `git pull` | Get everyone else's latest work | Every time you sit down |
| `git checkout -b my-branch` | Make your own branch | Start of each new piece of work |
| `git status` | Show what you have changed | Any time you are unsure where you are |
| `git add <file>` | Select changes for the next snapshot | Before committing |
| `git commit -m "message"` | Save the snapshot | After each meaningful chunk |
| `git push` | Send your branch to GitHub | When it is ready for review |
| *(open a pull request)* | Ask for review and merge | Once per piece of work |

People assume git has hundreds of commands and that the hard part is knowing which to use.
It is these seven, in this order.

---

## What's in this repo

| Path | What it is |
| --- | --- |
| `README.md` | This walkthrough |
| `members/_TEMPLATE.md` | The blank card you copy. Leave it blank |
| `members/*.md` | One card per person, added by that person |
| `.github/workflows/` | The automated check that runs on each pull request |
| `.github/scripts/` | What that check actually does, if you are curious |
| `scripts/progress.sh` | For leads — who has finished, who is stuck |

---

<sub>Practice repo for the South Shore Analytics × ND Data Club project · Fall 2026 · no real data lives here</sub>

<!-- infra PR path test -->
