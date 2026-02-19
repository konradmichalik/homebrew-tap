cask "canopy" do
  version "1.0.0,v2026.02.06-1519"

  on_arm do
    url "https://github.com/konradmichalik/canopy/releases/download/#{version.after_comma}/Canopy_#{version.before_comma}_aarch64.dmg"
    sha256 "ec9e39a26e8a18062eaf15430b12e08aa75b3d4500b8682fdb29a586d69d2199"
  end

  on_intel do
    url "https://github.com/konradmichalik/canopy/releases/download/#{version.after_comma}/Canopy_#{version.before_comma}_x64.dmg"
    sha256 "aff635715d3d2142bf23acabd0cdd0b4788a482e21cfcbd15c21625447a75cd2"
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
