cask "vitals-app" do
  version "0.1.0,v0.1.0"

  on_arm do
    url "https://github.com/konradmichalik/vitals/releases/download/#{version.after_comma}/VitalsApp-aarch64-apple-darwin.dmg"
    sha256 "141b9e805c7f545d50cff6ec5b2c643e44788c95c4b74501697d2f19958191e0"
  end

  on_intel do
    url "https://github.com/konradmichalik/vitals/releases/download/#{version.after_comma}/VitalsApp-x86_64-apple-darwin.dmg"
    sha256 "008e89083463791391dd1865f00693f879511f41af80c405ece197e8e47a1703"
  end

  name "vitals-app"
  desc "Menubar app that correlates system metrics with your dev toolchain and surfaces named diagnoses"
  homepage "https://github.com/konradmichalik/vitals"

  app "VitalsApp.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/VitalsApp.app"]
  end

  zap trash: [
    "~/Library/Preferences/com.konradmichalik.vitals.plist",
  ]
end
