cask "beacon" do
  version "0.10.0,v0.10.0"

  on_arm do
    url "https://github.com/konradmichalik/beacon/releases/download/#{version.after_comma}/Beacon_#{version.before_comma}_aarch64.dmg"
    sha256 "1b60203beee097b421fb364825176341c38cb9e039c550a46ed544f925b0ec41"
  end

  on_intel do
    url "https://github.com/konradmichalik/beacon/releases/download/#{version.after_comma}/Beacon_#{version.before_comma}_x64.dmg"
    sha256 "036ca4d9e32272d0232b80b1fa6977b6ee7bd3f70de87d745ddbe3a2540bf21f"
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
