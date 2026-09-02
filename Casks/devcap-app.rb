cask "devcap-app" do
  version "0.7.1,v0.7.1"

  on_arm do
    url "https://github.com/konradmichalik/devcap-app/releases/download/#{version.after_comma}/devcap-arm64-apple-darwin.dmg"
    sha256 "1cffb7011381b7a5b0609d27f62338a3035a487c92cb23238bda70dec68848af"
  end

  on_intel do
    url "https://github.com/konradmichalik/devcap-app/releases/download/#{version.after_comma}/devcap-x86_64-apple-darwin.dmg"
    sha256 "61986a0be6b718e40f520a6390bb926fada6074c127f19ff80d8517629aba50c"
  end

  name "devcap.app"
  desc "macOS menubar app that scans local git repos and displays your daily commit recap"
  homepage "https://github.com/konradmichalik/devcap-app"

  app "DevcapApp.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/DevcapApp.app"]
  end

  zap trash: [
    "~/Library/Preferences/com.konradmichalik.devcap.plist",
  ]
end
