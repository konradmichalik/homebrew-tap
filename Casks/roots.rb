cask "roots" do
  version "0.1.0,v2026.03.18-0842"

  on_arm do
    url "https://github.com/konradmichalik/roots/releases/download/#{version.after_comma}/Roots_#{version.before_comma}_aarch64.dmg"
    sha256 "39019cf611b4e08a65eeece325c60ac46a256b5be6105508588fbc7f83298713"
  end

  on_intel do
    url "https://github.com/konradmichalik/roots/releases/download/#{version.after_comma}/Roots_#{version.before_comma}_x64.dmg"
    sha256 "d17764707ed102c4572091f176cfaebe61aa9b506a15c99ef237f45f02cfd169"
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
