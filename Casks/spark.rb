cask "spark" do
  version "0.5.0,v0.5.0"

  on_arm do
    url "https://github.com/konradmichalik/spark/releases/download/#{version.after_comma}/Spark-aarch64-apple-darwin.dmg"
    sha256 "55d53309e10b04ce52858dbafe575c237bc77a5274ac2437579e618839f89d20"
  end

  on_intel do
    url "https://github.com/konradmichalik/spark/releases/download/#{version.after_comma}/Spark-x86_64-apple-darwin.dmg"
    sha256 "1f5653d8ff68ed699b6d1f9cc888e5c7b4236b8774b4aa4f879373da43dd09a9"
  end

  name "Spark"
  desc "Native macOS menu bar app that shows your Claude Code usage at a glance"
  homepage "https://github.com/konradmichalik/spark"

  app "Spark.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Spark.app"]
  end

  zap trash: [
    "~/Library/Preferences/com.konradmichalik.spark.plist",
  ]
end
