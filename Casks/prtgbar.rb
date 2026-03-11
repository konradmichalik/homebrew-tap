cask "prtgbar" do
  version "1.0.0,v1.0.0"

  on_arm do
    url "https://github.com/konradmichalik/prtgbar/releases/download/#{version.after_comma}/PRTGBar-aarch64-apple-darwin.dmg"
    sha256 "865eed53ec1b66c94027daa260e2e00d24bdbe993db42f405c528e11d5b7bfc5"
  end

  on_intel do
    url "https://github.com/konradmichalik/prtgbar/releases/download/#{version.after_comma}/PRTGBar-x86_64-apple-darwin.dmg"
    sha256 "37f62cf7aeb213546255fc883b3bb18bd24c37f7e2e07d7b8357834041ab6137"
  end

  name "PRTGBar"
  desc "PRTG Network Monitor in your macOS menu bar"
  homepage "https://github.com/konradmichalik/prtgbar"

  app "PRTGBar.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/PRTGBar.app"]
  end

  zap trash: [
    "~/Library/Preferences/com.konradmichalik.prtgbar.plist",
  ]
end
