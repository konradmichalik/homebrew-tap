cask "roots" do
  version "0.1.0,v2026.04.07-1107"

  on_arm do
    url "https://github.com/konradmichalik/roots/releases/download/#{version.after_comma}/Roots_#{version.before_comma}_aarch64.dmg"
    sha256 "73d41b9a447988bcd1b9586f3b394221611ebceed8d69e03959cc97678b8c60d"
  end

  on_intel do
    url "https://github.com/konradmichalik/roots/releases/download/#{version.after_comma}/Roots_#{version.before_comma}_x64.dmg"
    sha256 "89d7fe0883ad96fb303d858297e1190ee763ae38b3a434b2fed43fb343d383ff"
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
