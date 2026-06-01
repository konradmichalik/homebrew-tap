cask "canopy" do
  version "1.0.0,v2026.06.01-1051"

  on_arm do
    url "https://github.com/konradmichalik/canopy/releases/download/#{version.after_comma}/Canopy_#{version.before_comma}_aarch64.dmg"
    sha256 "070563e3f0bb7ca3cab183e293e35889064c07cc3f50c2f4253c6d4e8e749315"
  end

  on_intel do
    url "https://github.com/konradmichalik/canopy/releases/download/#{version.after_comma}/Canopy_#{version.before_comma}_x64.dmg"
    sha256 "8cb4626d0de8f0bb4cd15dc941841c9e4336944d6acdd53f05ade25efefd4534"
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
