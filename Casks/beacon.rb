cask "beacon" do
  version "0.18.0,v0.18.0"

  on_arm do
    url "https://github.com/konradmichalik/beacon/releases/download/#{version.after_comma}/Beacon_#{version.before_comma}_aarch64.dmg"
    sha256 "6762467fd868a708ed15d334d624feabe4c5cd212cdc07c7dbc84c7bf93c55f9"
  end

  on_intel do
    url "https://github.com/konradmichalik/beacon/releases/download/#{version.after_comma}/Beacon_#{version.before_comma}_x64.dmg"
    sha256 "c6bc3e7f47cbf5057a45220e71e11452087f0abfce4ad6010942390030fe803b"
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
