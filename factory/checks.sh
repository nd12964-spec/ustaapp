#!/usr/bin/env bash
# The repo's checks. Exit 0 only when the branch is fit to review.
#
# The gate runs this script from the main checkout with the job's worktree as
# the working directory. Keep it fast, deterministic and non-interactive: no
# watch modes, no prompts, nothing that rewrites tracked files.
#
# The app is a Flutter project in Usta/. Its android/ and web/ folders are not
# in the repo (CI creates them with `flutter create`), so the web build runs in
# a throwaway copy and never touches the worktree.
set -euo pipefail

FLUTTER="${FLUTTER:-$(command -v flutter || echo "$HOME/development/flutter/bin/flutter")}"
cd Usta

"$FLUTTER" pub get --enforce-lockfile
"$FLUTTER" analyze --no-fatal-infos
if [ -d test ]; then
  "$FLUTTER" test
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
rsync -a --exclude .dart_tool --exclude build ./ "$tmp/app/"
(
  cd "$tmp/app"
  "$FLUTTER" create --platforms=web --org kg.usta --project-name usta . >/dev/null
  "$FLUTTER" build web --release
)
