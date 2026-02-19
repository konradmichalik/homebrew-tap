cask "roots" do
  version "0.1.0,v2026.02.19-1200"

  on_arm do
    url "https://github.com/konradmichalik/roots/releases/download/#{version.after_comma}/Roots_#{version.before_comma}_aarch64.dmg"
    sha256 "b4e8a9bb79cf226ae111e590b952d684f5e4054679962efbd35fd09d1f2418bd"
  end

  on_intel do
    url "https://github.com/konradmichalik/roots/releases/download/#{version.after_comma}/Roots_#{version.before_comma}_x64.dmg"
    sha256 "a8e5baef93ed44a799519accee097f30fad4a90419392f8ee1874ed35746a4ad"
  end

  name "Roots"
  desc "Work Time Overview & Management — aggregates Moco, Jira, Outlook, and Personio"
  homepage "https://github.com/konradmichalik/roots"

  app "Roots.app"

  zap trash: [
    "~/Library/Application Support/com.roots.time-overview",
    "~/Library/Caches/com.roots.time-overview",
  ]
end
