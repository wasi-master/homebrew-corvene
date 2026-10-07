# Homebrew cask for Corvene (macOS and Linux). Lives in the
# `wasi-master/homebrew-corvene` tap as `Casks/corvene.rb`.
# `packaging/homebrew/stamp.py` rewrites `version` and the `sha256` values
# (`packaging/release.sh` for macOS, release.yml's `cask` job for Linux).
#
#   brew install --cask wasi-master/corvene/corvene
#
# macOS: the bundle is self-signed (no Apple Developer ID), so Gatekeeper
# blocks a quarantined copy on first launch. Homebrew 7 removed
# `--no-quarantine` and always quarantines cask downloads, so
# `postflight_steps` clears the attribute.
# Linux: the release's AppImage goes to `~/Applications/Corvene.AppImage`.
cask "corvene" do
  # only the Linux assets are per architecture (the macOS zip is universal)
  arch arm: "aarch64", intel: "x86_64"

  version "0.1.0"
  # the macOS zip is one universal build: `arm` and `intel` are the same file
  sha256 arm:          "88daa690061b517c565e5d82a50297aafb9dd98142ac7bd55bffe6ef57ec0720",
         intel:        "88daa690061b517c565e5d82a50297aafb9dd98142ac7bd55bffe6ef57ec0720",
         arm64_linux:  "6285329abea21bffeaa84c532d1a1eace366139d7c6c0a4a630ecc6476e24aa7",
         x86_64_linux: "24565b4d72ec606bed78047875accb3816cd223f17a3060f4032381e5e6bef22"

  on_macos do
    url "https://github.com/wasi-master/corvene/releases/download/v#{version}/Corvene-#{version}-macos-universal.zip"

    app "Corvene.app"
    # `corvene [open] [path]` / `corvene clone <url>` (Install Command Line Tool… does the same by hand)
    binary "#{appdir}/Corvene.app/Contents/Resources/corvene"

    postflight_steps do
      run "/usr/bin/xattr",
          args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Corvene.app"],
          writable_paths: ["Corvene.app"],
          writable_base:  :appdir
    end

    zap trash: [
      "~/Library/Application Support/Corvene",
      "~/Library/Caches/Corvene",
      "~/Library/Logs/Corvene",
      "~/Library/Preferences/com.wasimaster.corvene.plist",
      "~/Library/Saved Application State/com.wasimaster.corvene.savedState",
    ]
  end
  on_linux do
    url "https://github.com/wasi-master/corvene/releases/download/v#{version}/Corvene-#{version}-#{arch}.AppImage"

    # a fixed name: the updater knows the cask's image by its folder, and the
    # command line tool's link keeps pointing at it across upgrades
    app_image "Corvene-#{version}-#{arch}.AppImage", target: "Corvene.AppImage"

    # the launcher entry and icons Corvene writes for itself at first run
    # are left to `zap`: an `uninstall` would also remove them on every
    # upgrade, and the entry's `TryExec` hides it once the image is gone
    zap trash: [
      "~/.cache/corvene",
      "~/.local/share/applications/com.wasimaster.corvene.desktop",
      "~/.local/share/corvene",
      "~/.local/share/icons/hicolor/256x256/apps/com.wasimaster.corvene.png",
      "~/.local/share/icons/hicolor/scalable/apps/com.wasimaster.corvene.svg",
      "~/.local/state/corvene",
    ]
  end

  name "Corvene"
  desc "Native GitHub Desktop clone in Rust (GPUI + gitoxide)"
  homepage "https://github.com/wasi-master/corvene"

  livecheck do
    url :url
    strategy :github_latest
  end

  caveats <<~EOS
    Updates for this install come from `brew upgrade corvene`; the in-app
    updater only points there.

    macOS: Corvene is self-signed; this cask clears its quarantine attribute
    so Gatekeeper lets it launch.

    Linux: the app is ~/Applications/Corvene.AppImage. Run it once and it
    adds itself to the application menu (~/.local/share/applications). It
    needs a Vulkan driver, a Secret Service keyring and git 2.40 or newer.
    File > Install Command Line Tool links `corvene` into ~/.local/bin.
  EOS
end
