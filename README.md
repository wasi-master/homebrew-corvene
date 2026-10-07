# homebrew-corvene

[Homebrew](https://brew.sh/) tap for [Corvene](https://github.com/wasi-master/corvene), a native
[GitHub Desktop](https://github.com/apps/desktop) clone for macOS and Linux.

## Install

```bash
brew install --cask wasi-master/corvene/corvene
```

This also puts a `corvene` command on your PATH. `corvene <path>` opens a
repository and `corvene clone <url>` clones one.

## Upgrade

The cask was called `corvane` before the rename. Homebrew moves an existing
install over to `corvene`, but 0.1.0 was re-released under the same version,
so replace the old `Corvane.app` once with `brew reinstall --cask corvene`.

```bash
brew upgrade corvene
```

The app's own updater knows when it was installed with Homebrew and points you
here instead of updating itself.

## About the quarantine step

Corvene is signed with a self-signed certificate, not an Apple Developer ID,
so macOS would block the first launch. Homebrew no longer supports
`--no-quarantine`, so the cask removes the quarantine attribute from
`Corvene.app` after installing it.

## Uninstall

```bash
brew uninstall --cask corvene
brew uninstall --cask --zap corvene   # also removes settings and caches
```

On Linux a plain uninstall leaves the menu entry's files behind (the entry
hides itself once the AppImage is gone). `--zap` removes them too.
