cask "prtgbar" do
  version "1.1.0,v1.1.0"

  on_arm do
    url "https://github.com/konradmichalik/prtgbar/releases/download/#{version.after_comma}/PRTGBar-aarch64-apple-darwin.dmg"
    sha256 "01084ab557181caa7f20de2b0a08d261b1f8b2841d05bb2932e17624f62560d8"
  end

  on_intel do
    url "https://github.com/konradmichalik/prtgbar/releases/download/#{version.after_comma}/PRTGBar-x86_64-apple-darwin.dmg"
    sha256 "aa7e314465945aae86920ee6427936be2f5f7d8140fba2e683977dd5441bf858"
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
