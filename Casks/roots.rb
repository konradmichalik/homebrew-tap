cask "roots" do
  version "0.1.0,v2026.03.20-1454"

  on_arm do
    url "https://github.com/konradmichalik/roots/releases/download/#{version.after_comma}/Roots_#{version.before_comma}_aarch64.dmg"
    sha256 "f4e2dd22949a8021fa84f36137e839a9264e802ead727be804fae1c40b165e41"
  end

  on_intel do
    url "https://github.com/konradmichalik/roots/releases/download/#{version.after_comma}/Roots_#{version.before_comma}_x64.dmg"
    sha256 "d52e41b6cf4fc511edff22dea54c9975f44f8c0a2ef489e018d6c95708df6384"
  end

  name "Roots"
  desc "Work Time Overview & Management — aggregates Moco, Jira, Outlook, and Personio"
  homepage "https://github.com/konradmichalik/roots"

  app "Roots.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Roots.app"]
  end

  zap trash: [
    "~/Library/Application Support/com.roots.time-overview",
    "~/Library/Caches/com.roots.time-overview",
  ]
end
