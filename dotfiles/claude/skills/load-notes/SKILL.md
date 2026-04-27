---
name: load-notes
description: Load the current project's notes file ($NOTES_DIR/<project>/<project>.md) into the conversation. The notes act as a project-scoped CLAUDE.md, capturing architecture, conventions, dependencies, and gotchas.
user-invocable: true
disable-model-invocation: true
allowed-tools: Read, Bash(jj root), Bash(git rev-parse *), Bash(pwd), Bash(basename *)
---

## Process

### 1. Determine the project

Resolve `$PROJECT` as the basename of the project root:

- Try `jj root 2>/dev/null` first.
- Fall back to `git rev-parse --show-toplevel 2>/dev/null`.
- Fall back to `pwd`.
- Take `basename` of the result.

### 2. Read the notes file

If `$NOTES_DIR` is not set, stop and tell the user to export it in their environment.

`$FILE = $NOTES_DIR/$PROJECT/$PROJECT.md`

Read `$FILE`.

- **If it exists**: confirm load with one line citing the path. The contents will be in the conversation context.
- **If it does not exist**: tell the user no notes exist for this project yet, and suggest running `/update-notes` to create one.

### 3. Respond

- Path loaded.
- A one-sentence summary of what's in the file (architecture areas covered, key conventions, etc.). The full contents are now in context.

Do not paste the full notes back to the user.
