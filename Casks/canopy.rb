cask "canopy" do
  version "1.0.0,v2026.03.20-1302"

  on_arm do
    url "https://github.com/konradmichalik/canopy/releases/download/#{version.after_comma}/Canopy_#{version.before_comma}_aarch64.dmg"
    sha256 "2078dab13bb4130b6d83b3bedb584be47a3da40425ca1e8aca0f545e94cf0b47"
  end

  on_intel do
    url "https://github.com/konradmichalik/canopy/releases/download/#{version.after_comma}/Canopy_#{version.before_comma}_x64.dmg"
    sha256 "fa3ffb1e1f907d472bc3fa71506098592e1f8b15815da197f2c65adcfc5ea0b8"
  end

  name "Canopy"
  desc "Jira companion with tree visualization, powerful filters, grouping, and change tracking"
  homepage "https://github.com/konradmichalik/canopy"

  app "Canopy.app"

  zap trash: [
    "~/Library/Application Support/com.canopy.jira-viewer",
    "~/Library/Caches/com.canopy.jira-viewer",
  ]
end
