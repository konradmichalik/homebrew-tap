cask "devcap-app" do
  version "0.7.0,v0.7.0"

  on_arm do
    url "https://github.com/konradmichalik/devcap-app/releases/download/#{version.after_comma}/devcap-arm64-apple-darwin.dmg"
    sha256 "a247f939596e692e15f5869597e27d8dea62b8318065824cad163876f506b5d6"
  end

  on_intel do
    url "https://github.com/konradmichalik/devcap-app/releases/download/#{version.after_comma}/devcap-x86_64-apple-darwin.dmg"
    sha256 "24985ddbd000f4dc5895dc7526e885cbf489d89719a55b7747b0904299b972c9"
  end

  name "devcap.app"
  desc "macOS menubar app that scans local git repos and displays your daily commit recap"
  homepage "https://github.com/konradmichalik/devcap-app"

  app "DevcapApp.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/DevcapApp.app"]
  end

  zap trash: [
    "~/Library/Preferences/com.konradmichalik.devcap.plist",
  ]
end
