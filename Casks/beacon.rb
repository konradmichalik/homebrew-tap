cask "beacon" do
  version "0.18.1,v0.18.1"

  on_arm do
    url "https://github.com/konradmichalik/beacon/releases/download/#{version.after_comma}/Beacon_#{version.before_comma}_aarch64.dmg"
    sha256 "02ab8d11efb2cfc934c9fcfb4b260eeeb5420dde7915fc2ea9475a6fa5f95ba4"
  end

  on_intel do
    url "https://github.com/konradmichalik/beacon/releases/download/#{version.after_comma}/Beacon_#{version.before_comma}_x64.dmg"
    sha256 "7865ea9b18103900dd2b42ceb600fd572be7af9ee50383c267c0adc8ae344908"
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
