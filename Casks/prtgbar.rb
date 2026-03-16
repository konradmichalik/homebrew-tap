cask "prtgbar" do
  version "1.2.1,v1.2.1"

  on_arm do
    url "https://github.com/konradmichalik/prtgbar/releases/download/#{version.after_comma}/PRTGBar-aarch64-apple-darwin.dmg"
    sha256 "a5a33e1633d85c9f26379cc200d51a2692ad3a3db8ab9c2a97948e82d1b288ac"
  end

  on_intel do
    url "https://github.com/konradmichalik/prtgbar/releases/download/#{version.after_comma}/PRTGBar-x86_64-apple-darwin.dmg"
    sha256 "6250dccb789af018231f108be4e3ed132465a5a968f8218898a061cac9d84278"
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
