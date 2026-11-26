# Usta — instructions for coding agents

The app is a Flutter project in `Usta/`. Read `Usta/CLAUDE.md` for what the
project is and what is already decided, and the docs it points to
(`Usta/docs/PRODUCT.md`, `DESIGN.md`, `AI_RULES.md`, `MVP.md`) for the area you
touch. `AI_RULES.md` is mandatory.

`Usta/CLAUDE.md` also says how the owner wants to be talked to: plain Russian,
work in stages, wait for "ок". That applies to conversations with the owner.
Factory agents work on one job autonomously and follow their own agent
instructions; write anything meant for the owner (issue and PR comments,
summaries) in plain Russian.

## Setup

Flutter is at `$HOME/development/flutter/bin/flutter` if `flutter` is not on
`PATH`. In a fresh checkout:

```bash
cd Usta && flutter pub get
```

`android/` and `web/` are not in the repo: CI creates them with
`flutter create`. Don't commit them.

## Run it (preview on a port)

The web build is the way to look at the app. Run it from a throwaway copy so
the checkout stays clean, on your given port:

```bash
tmp=$(mktemp -d) && rsync -a --exclude .dart_tool --exclude build Usta/ "$tmp/app/" \
  && cd "$tmp/app" && flutter create --platforms=web --org kg.usta --project-name usta . \
  && flutter run -d web-server --web-port <port> --release
```

Then open `http://localhost:<port>`. Re-copy after changing code.

## Validation

Same as `factory/checks.sh`, from `Usta/`:

```bash
flutter pub get --enforce-lockfile
flutter analyze --no-fatal-infos
flutter test            # only when Usta/test/ exists
flutter build web --release   # in a copy with web/ created, as above
```

Pure logic (calculations, formatting, validation) gets tests in `Usta/test/`.
`AI_RULES.md` requires automated tests for every quantity calculation.

## Software factory

`/factory run` builds every open GitHub issue labeled `factory` through
intake → spec → build → gate → review → approve, one PR per issue. State is in
`factory/jobs/` (gitignored); `factory/bin/job` is its only writer. Checks:
`factory/checks.sh`. Dashboard: `cd factory && python3 -m http.server`, then
open http://localhost:8000/dashboard.html.

Each job works in its own git worktree, a full checkout of the repo at
`.worktrees/<job-id>` (gitignored). A tool run from the repo root that doesn't
read `.gitignore` sees those copies too; exclude `.worktrees/` in its config.
