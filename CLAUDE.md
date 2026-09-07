# CLAUDE.md

Personal academic website for Bnaya Dreyfuss, served by GitHub Pages at
<https://b3fuss.github.io> from the `main` branch of `B3fuss/b3fuss.github.io`.

## Structure

There is no build step, no framework, and no dependencies. The site is a single
hand-written page.

- `index.html` — the entire site. HTML, CSS (in a `<style>` block) and JS (in a
  `<script>` block) all live in this one file.
- `headshot.jpg` — the About-section photo.
- `CV_Dreyfuss (oct-18-2025).pdf` — the CV linked from the CV tab. The filename
  carries its date; when a new CV is added, add the new dated file and update the
  link in `index.html` rather than overwriting.
- `design-demo.html` — an unrelated design sandbox ("Atlas"), untracked and not
  part of the site. Leave it alone unless asked.

## How the page works

Three sections (`#about`, `#research`, `#cv`) live in the DOM at once. `showSection()`
toggles the `.active` class to swap between them, and `toggleAbstract()` expands each
paper's abstract. Navigation is client-side only — there are no other routes and no
other HTML pages.

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
