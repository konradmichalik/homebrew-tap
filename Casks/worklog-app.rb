cask "worklog-app" do
  version "0.1.0"

  on_arm do
    url "https://github.com/konradmichalik/worklog-menubar/releases/download/v#{version}/worklog-app-arm64-apple-darwin.dmg"
    sha256 "2522166e515960681a9e9bf441ebcc4d5b663be2e14a35805d056f44bc3b9147"
  end

  on_intel do
    url "https://github.com/konradmichalik/worklog-menubar/releases/download/v#{version}/worklog-app-x86_64-apple-darwin.dmg"
    sha256 "fe5ec5c35f81b1a59d83e6d244b321f7208c87258645386567b79b84c2e0211e"
  end

  name "worklog.app"
  desc "Native macOS menubar app for daily git commit aggregation"
  homepage "https://github.com/konradmichalik/worklog-menubar"

  app "WorklogApp.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/WorklogApp.app"]
  end

  zap trash: [
    "~/Library/Preferences/com.konradmichalik.worklog-app.plist",
  ]
end
