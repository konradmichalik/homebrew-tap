cask "devcap-app" do
  version "0.5.0,v0.5.0"

  on_arm do
    url "https://github.com/konradmichalik/devcap-app/releases/download/#{version.after_comma}/devcap-arm64-apple-darwin.dmg"
    sha256 "c959052cc113b5cdaf430dc1318e650fd15d5429208e62e5756deaab8479f277"
  end

  on_intel do
    url "https://github.com/konradmichalik/devcap-app/releases/download/#{version.after_comma}/devcap-x86_64-apple-darwin.dmg"
    sha256 "8863d5d2298cd0a38363dfc4bfd672bc9885bff321772f0207d1f1271ec143cb"
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
