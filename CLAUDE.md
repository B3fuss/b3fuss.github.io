# CLAUDE.md

Personal academic website for Bnaya Dreyfuss, served by GitHub Pages at
<https://b3fuss.github.io> from the `main` branch of `B3fuss/b3fuss.github.io`.

## Layout

```
index.html                      the entire site (HTML + CSS + JS in one file)
cv.pdf                          published CV — stable URL, built from cv-src/
CV_Dreyfuss (oct-18-2025).pdf   superseded CV, kept only so old links resolve
assets/headshot.jpg             About-section photo
cv-src/                         LaTeX source for the CV (see below)
design-demo.html                unrelated design sandbox, untracked — leave alone
```

`index.html` and `cv.pdf` must stay at the repo root: Pages serves the root as the
site, and `cv.pdf` is the stable public URL. There is no build step for the site
itself — no framework, no dependencies.

## How the page works

Three sections (`#about`, `#research`, `#cv`) live in the DOM at once. `showSection()`
toggles the `.active` class to swap between them, and `toggleAbstract()` expands each
paper's abstract. Navigation is client-side only — there are no other routes and no
other HTML pages.

## The CV

**All CV changes are made in the LaTeX source, never by editing a PDF.** Edit the
files in `cv-src/`, then:

```bash
./cv-src/build.sh
```

That writes `cv.pdf` at the repo root; commit and push to publish. `--check` builds
without publishing.

- **The source mirrors Overleaf exactly.** `cv-src/` is a verbatim Overleaf export.
  To sync a new export, unzip it over `cv-src/` — there is nothing local to merge.
- **Do not patch `academic-cv.cls` in the repo.** Current `fontawesome.sty` defines
  `\FA`, which collides with the class's own `\newfontfamily\FA` for its bundled
  FontAwesome.ttf. `build.sh` applies that fix to a throwaway copy on every build,
  idempotently, so a fresh export keeps working. Patching the source in place would
  be silently undone by the next export.
- **Engine:** XeLaTeX via `tectonic` (`brew install tectonic`). It must be XeLaTeX —
  the class uses `fontspec` with `Path=` to load bundled TTFs. `pdflatex` will not work.
- `cv.tex` uses the `draft` class option, which only sets `\overfullrule` and
  currently changes nothing in the output. Box warnings from the build are advisory.
- **`cv.pdf` is a stable URL.** Don't rename it per-revision; anything already linking
  to it should keep working. The dated Oct 2025 PDF stays at the root for the same
  reason — it is not the current CV, just a preserved link target.

## Conventions

- **Pitt brand colors.** `--accent: #003594` (Royal Blue) and `--gold: #FFB81C`.
  Don't introduce other accent colors.
- **Serif body type** (Georgia) with a sans-serif nav. Layout is capped at
  `--max-width: 800px`.
- Papers are grouped under "Working Papers" then "Published Papers", each newest /
  most prominent first. A paper block is: title link, `.coauthors`, `.status`,
  abstract toggle, `.abstract`.
- Use HTML entities for typography: `&mdash;`, `&ndash;`, `&amp;`, `&euml;`.
- Google Analytics (`G-9ZXWB2YHGK`) is in `<head>`. Keep it when editing the head.

## Keeping the site and the CV in sync

`index.html` and `cv-src/` restate the same facts, so **every change to either one
ends with a cross-check of the other** — not only when the overlap is obvious.
Report any mismatch found, even one unrelated to the change at hand; don't silently
fix biographical or authorship details.

Compare, in both directions:

- **Position, affiliation, email, dates.** The site's About paragraph and footer
  against `cv.tex`'s `\position`/`\email` and `cv/professional.tex`.
- **Paper list and grouping.** Every paper on one should appear on the other, in a
  matching group (JMP / working / published).
- **Titles, coauthor names, and coauthor order.** Order follows the actual byline,
  never alphabetical, and diacritics match on both (e.g. Rapha&euml;l Raux).
- **Publication status.** Journal, volume, issue, pages, year, and R&R status.
- **Abstracts.** The CV carries only the JMP abstract; when it is reworded, the
  site's copy needs the same rewording.

```bash
pdftotext -layout cv.pdf -   # the CV as text, for diffing against index.html
```

## Line endings

This repo has been edited from both Windows and macOS. `.gitattributes` forces LF
(`* text=auto eol=lf`). If a diff ever shows every line of a file changed, it is a
line-ending artifact, not real content — check with `git diff --ignore-cr-at-eol`
before committing.

## Deploying

Pushing to `main` publishes; GitHub Pages takes a minute or two.

```bash
git add -A && git commit -m "..." && git push
```

## Working copy location

The repo lives at `~/code/b3fuss.github.io`, deliberately outside OneDrive, iCloud,
and Dropbox. It used to sit in OneDrive, which synced `.git/` itself and risked
corrupting the object store. Do not move it back under a sync root — use GitHub as
the sync mechanism between machines.
