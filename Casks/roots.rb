cask "roots" do
  version "0.1.0,v2026.06.02-1037"

  on_arm do
    url "https://github.com/konradmichalik/roots/releases/download/#{version.after_comma}/Roots_#{version.before_comma}_aarch64.dmg"
    sha256 "2b5a56215e70831eff964661827fbec31e1e6a1bb6a0de5e11a725f0d6a71b3b"
  end

  on_intel do
    url "https://github.com/konradmichalik/roots/releases/download/#{version.after_comma}/Roots_#{version.before_comma}_x64.dmg"
    sha256 "150785a22614e390562bcbead40da7a50b1b0b1b78eaf5f6d608732290a22b15"
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
