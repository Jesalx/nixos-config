---
name: update-notes
description: Update the current project's notes file ($NOTES_DIR/<project>/<project>.md) to reflect new architecture, conventions, dependencies, or gotchas. On first run (no existing file), bootstraps notes from a codebase scan. Otherwise reviews recent session edits and uncommitted changes and merges new findings.
user-invocable: true
disable-model-invocation: true
argument-hint: [optional topic or area to focus on]
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(jj root), Bash(jj diff *), Bash(jj log *), Bash(git rev-parse *), Bash(git diff *), Bash(git log *), Bash(pwd), Bash(basename *), Bash(mkdir *), Bash(date *), Bash(ls *)
---

## Focus

$ARGUMENTS

- **If an argument is provided**: focus the update on that topic or area.
- **If no argument is provided**: review recent edits and uncommitted changes broadly (or, on first run, scan the codebase).

## Process

### 1. Determine the project and notes path

Resolve `$PROJECT` as the basename of the project root:

- Try `jj root 2>/dev/null` first.
- Fall back to `git rev-parse --show-toplevel 2>/dev/null`.
- Fall back to `pwd`.
- Take `basename` of the result.

If `$NOTES_DIR` is not set, stop and tell the user to export it in their environment.

`$DIR = $NOTES_DIR/$PROJECT`
`$FILE = $DIR/$PROJECT.md`

`mkdir -p "$DIR"` so the directory exists before writing.

### 2. Pick the mode

- **Bootstrap mode**: `$FILE` does not exist. Skip to step 3a.
- **Merge mode**: `$FILE` exists. Skip to step 3b.

### 3a. Bootstrap: scan the codebase

When no notes exist yet, build the initial file from a codebase scan, not from session diffs.

Look at:

1. **Project root**: `ls` the root and read manifests (`go.mod`, `package.json`, `Cargo.toml`, `pyproject.toml`, `flake.nix`, etc.) to identify language, dependencies, and tooling.
2. **Top-level layout**: directory structure to understand subsystems and entry points.
3. **Existing docs**: any `README.md`, `CLAUDE.md`, `AGENTS.md`, or `docs/` content. Notes should complement, not duplicate, what's already there.
4. **Build/test/lint commands**: from manifests, scripts, Makefile, justfile, Taskfile, or `.github/workflows/` if present.
5. **Conventions**: skim a representative sample of source files to spot patterns (error handling style, testing style, naming).

Then jump to step 4.

### 3b. Merge: gather what changed

Look at:

1. **Uncommitted changes**: `jj diff` (preferred per global CLAUDE.md) or `git diff HEAD`.
2. **Recent session edits**: changes you made in this conversation (already in context).
3. **Existing notes**: read `$FILE`. The update is a merge, not a rewrite.

### 4. Decide what is worth recording

The notes file mirrors a project CLAUDE.md. Record only things a future session would benefit from knowing without re-discovering:

- **Architecture**: layout, key entry points, main types and their relationships.
- **Conventions**: project-specific patterns (naming, error handling, testing, commit style) that differ from language defaults or are non-obvious.
- **Dependencies and tooling**: notable libraries, build commands, test commands, lint commands.
- **Gotchas**: non-obvious behavior, hidden constraints, things that surprised you, workarounds and the bugs they exist for.
- **Open work**: known issues, deferred decisions, in-progress directions.

Do **not** record:

- Bug fixes that don't change architecture or conventions.
- One-off facts that won't recur.
- Anything already obvious from skimming the codebase or already covered in `README.md` / `CLAUDE.md`.
- Personal commentary or session narrative ("I fixed X today").

### 5. Write the file

- **Bootstrap mode**: create `$FILE`. Free-form markdown. Suggested top-level headings: `## Architecture`, `## Conventions`, `## Tooling`, `## Gotchas`, `## Open work`. Skip headings with no content. Keep it tight: a future reader should be able to skim it in under a minute.
- **Merge mode**: prefer `Edit` over `Write` to preserve the existing structure and prose. Add to existing sections where they fit; create new sections only when nothing fits. Match the writing style of the existing file (terse stays terse, bullets stay bullets). Do not duplicate facts already in the file. If something has changed (a convention shifted, a dependency was replaced), update the existing entry rather than appending a new one.

### 6. Respond to the user

- Path written.
- Mode used (bootstrap or merge).
- A short bullet list of what was added, changed, or removed. Be specific (section name + one-line summary), not generic ("updated architecture section").

Do not paste the full notes back to the user.

## Rules

- The notes file is the artifact. Write it before answering.
- In merge mode, if there is nothing worth recording, say so and do not modify the file.
- Never weaken or remove existing notes to make new ones fit. If something genuinely became obsolete, remove it; otherwise leave it.
