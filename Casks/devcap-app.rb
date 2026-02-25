cask "devcap-app" do
  version "0.3.0,v0.3.0"

  on_arm do
    url "https://github.com/konradmichalik/devcap-app/releases/download/#{version.after_comma}/devcap-arm64-apple-darwin.dmg"
    sha256 "05abb4351c7285ee0f75d37a960fd6d8447455749a6064d8d62789aafd778e8b"
  end

  on_intel do
    url "https://github.com/konradmichalik/devcap-app/releases/download/#{version.after_comma}/devcap-x86_64-apple-darwin.dmg"
    sha256 "099a0f6f097bf6ffd54534886640e32b0dfadbe5660a5d8ca402dac8c7d6838b"
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
