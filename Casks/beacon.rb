cask "beacon" do
  version "0.11.0,v0.11.0"

  on_arm do
    url "https://github.com/konradmichalik/beacon/releases/download/#{version.after_comma}/Beacon_#{version.before_comma}_aarch64.dmg"
    sha256 "a6bc1c2a9acbe8ce426650893eb4d71faf1cec94327d995523ab083714ba324b"
  end

  on_intel do
    url "https://github.com/konradmichalik/beacon/releases/download/#{version.after_comma}/Beacon_#{version.before_comma}_x64.dmg"
    sha256 "2078ffcc972767c5b244276c1140a738f799f2c5690b82840ad91ad6598ec5bd"
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
