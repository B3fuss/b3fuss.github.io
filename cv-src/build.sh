#!/usr/bin/env bash
# Build the CV from LaTeX source and publish it to the site as ../cv.pdf
#
# The source in this directory is kept byte-identical to the Overleaf export, so
# you can drop a fresh export in here without merging anything. The one fix the
# local build needs (see PATCH below) is applied to a throwaway copy, never to
# the source you edit.
#
# Usage:  ./cv-src/build.sh          # build and publish to ../cv.pdf
#         ./cv-src/build.sh --check  # build only, don't touch the published PDF

set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$SRC/../cv.pdf"
BUILD="$(mktemp -d)"
trap 'rm -rf "$BUILD"' EXIT

command -v tectonic >/dev/null || {
  echo "error: tectonic not found. Install it with:  brew install tectonic" >&2
  exit 1
}

cp -R "$SRC"/. "$BUILD"/
rm -f "$BUILD/build.sh"

# PATCH: current fontawesome.sty defines \FA, which collides with the class's own
# \newfontfamily\FA for the bundled (newer) FontAwesome.ttf. Clearing \FA first
# lets the bundled font win, which is what the class comment says it intends.
# Idempotent, so a re-exported .cls is fixed automatically.
if ! grep -q '\\let\\FA\\undefined' "$BUILD/academic-cv.cls"; then
  perl -0pi -e 's/(\\newfontfamily\\FA\[Path=\\\@fontdir\]\{FontAwesome\})/\\let\\FA\\undefined\n$1/' \
    "$BUILD/academic-cv.cls"
  grep -q '\\let\\FA\\undefined' "$BUILD/academic-cv.cls" \
    || { echo "error: could not apply the \\FA patch; the class file changed shape" >&2; exit 1; }
fi

echo "Building CV with tectonic..."
tectonic -X compile --keep-logs "$BUILD/cv.tex" >/dev/null

[ -f "$BUILD/cv.pdf" ] || { echo "error: no PDF produced" >&2; exit 1; }

# Surface layout problems worth looking at; don't fail the build over them.
if grep -hE '^(Overfull|Underfull) \\hbox' "$BUILD/cv.log" 2>/dev/null | grep -q .; then
  echo "note: TeX reported box warnings:"
  grep -hE '^(Overfull|Underfull) \\hbox' "$BUILD/cv.log" | sed 's/^/  /' | head -10
fi

if [ "${1:-}" = "--check" ]; then
  echo "OK: built, $(pdfinfo "$BUILD/cv.pdf" 2>/dev/null | awk '/^Pages/{print $2}') pages. Not published (--check)."
  exit 0
fi

cp "$BUILD/cv.pdf" "$OUT"
echo "Published -> cv.pdf ($(pdfinfo "$OUT" 2>/dev/null | awk '/^Pages/{print $2}') pages)"
echo "Commit and push to deploy."
