cask "beacon" do
  version "0.7.3,v0.7.3"

  on_arm do
    url "https://github.com/konradmichalik/beacon/releases/download/#{version.after_comma}/Beacon_#{version.before_comma}_aarch64.dmg"
    sha256 "858807d5ab54d2e2743d5a97bbf967c42c1bc7f3b9bf92edc0c4a3bbc05ca3e4"
  end

  on_intel do
    url "https://github.com/konradmichalik/beacon/releases/download/#{version.after_comma}/Beacon_#{version.before_comma}_x64.dmg"
    sha256 "5ddaa2f0059088e68a12e888f756bb7b116efb28626ea6477e6b65d9ce80f5b4"
  end

  name "Beacon"
  desc "GitHub & GitLab notification hub for your macOS menu bar"
  homepage "https://github.com/konradmichalik/beacon"

  app "Beacon.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Beacon.app"]
  end

  zap trash: [
    "~/Library/Application Support/com.beacon.notifications",
    "~/Library/Caches/com.beacon.notifications",
  ]
end
