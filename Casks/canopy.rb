cask "canopy" do
  version "1.0.0,v2026.04.01-1736"

  on_arm do
    url "https://github.com/konradmichalik/canopy/releases/download/#{version.after_comma}/Canopy_#{version.before_comma}_aarch64.dmg"
    sha256 "26e11581688481120963d343dc21969efd9c7ae7ad82f55d9f0aa0c8e64ba5b9"
  end

  on_intel do
    url "https://github.com/konradmichalik/canopy/releases/download/#{version.after_comma}/Canopy_#{version.before_comma}_x64.dmg"
    sha256 "a03f64acc6db5927799a0b2bad1bb2731d3a21c3b6ae31426b5744f27b7ba69c"
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
