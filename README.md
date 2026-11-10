# BrianKeys — pipeline proof test

A deliberately tiny iPhone app with a basic keyboard extension.
Its only job: prove the no-Mac route works end to end.

**Route:** write code on Berenice (Windows) → push to GitHub → GitHub's Mac
runners compile it (free for public repos) → download the unsigned `.ipa` →
install on Brian's iPhone 17 with SideStore (signs with his free Apple ID,
auto-refreshes the 7-day signature).

## Files

- `project.yml` — the project blueprint (XcodeGen turns it into an Xcode project)
- `App/` — the container app (instructions + a test text field)
- `Keyboard/` — the keyboard extension (3 letter rows + globe / space / ⌫ / ⏎)
- `.github/workflows/build.yml` — the cloud build recipe

## Success test

1. App installs and opens.
2. Settings → General → Keyboard → Keyboards → Add New Keyboard shows BrianKeysTest.
3. Brian types a sentence with it in the app's test field.
