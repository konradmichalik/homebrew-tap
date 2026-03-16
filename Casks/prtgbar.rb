cask "prtgbar" do
  version "1.2.0,v1.2.0"

  on_arm do
    url "https://github.com/konradmichalik/prtgbar/releases/download/#{version.after_comma}/PRTGBar-aarch64-apple-darwin.dmg"
    sha256 "f8ff87d268d9fc35e607549aa0c9efafc88454076a4751785c47a1a9e28d3ade"
  end

  on_intel do
    url "https://github.com/konradmichalik/prtgbar/releases/download/#{version.after_comma}/PRTGBar-x86_64-apple-darwin.dmg"
    sha256 "b2230794bad55fec36566faff35128b213084b2d10cd271ceb7070541e003506"
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
