cask "devcap-app" do
  version "0.2.0,v0.2.0"

  on_arm do
    url "https://github.com/konradmichalik/devcap-app/releases/download/#{version.after_comma}/devcap-arm64-apple-darwin.dmg"
    sha256 "a512e926015aa517c2ae0c853889a736d77a064c0861f787db0f136c85e46f9d"
  end

  on_intel do
    url "https://github.com/konradmichalik/devcap-app/releases/download/#{version.after_comma}/devcap-x86_64-apple-darwin.dmg"
    sha256 "8d37a994802605f7357b0b3d7f2883124fc3db42578f0ca3248a0e26a9dcf224"
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
