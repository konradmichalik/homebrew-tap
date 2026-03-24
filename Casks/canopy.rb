cask "canopy" do
  version "1.0.0,v2026.03.24-1028"

  on_arm do
    url "https://github.com/konradmichalik/canopy/releases/download/#{version.after_comma}/Canopy_#{version.before_comma}_aarch64.dmg"
    sha256 "8d4ad4128aa5038ed2598a65b9a2b65182f0ff6789bdd5bb8f79c96325707909"
  end

  on_intel do
    url "https://github.com/konradmichalik/canopy/releases/download/#{version.after_comma}/Canopy_#{version.before_comma}_x64.dmg"
    sha256 "4b2da248d031d17f04c9c9508a36f83cdf515936652c744daa60a0c100c23957"
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
