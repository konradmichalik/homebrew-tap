cask "prtgbar" do
  version "1.2.0,v1.2.0"

  on_arm do
    url "https://github.com/konradmichalik/prtgbar/releases/download/#{version.after_comma}/PRTGBar-aarch64-apple-darwin.dmg"
    sha256 "7a3356d81e9d383ef1b23951b780882a2d9f422342e04019e096042f02a07eb4"
  end

  on_intel do
    url "https://github.com/konradmichalik/prtgbar/releases/download/#{version.after_comma}/PRTGBar-x86_64-apple-darwin.dmg"
    sha256 "527e9a784c4f525c4162dd8b9901f0293c9847f29635709204a6b0a5ab613a69"
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
