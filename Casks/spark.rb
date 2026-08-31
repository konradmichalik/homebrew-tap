cask "spark" do
  version "0.11.1,v0.11.1"

  on_arm do
    url "https://github.com/konradmichalik/spark/releases/download/#{version.after_comma}/Spark-aarch64-apple-darwin.dmg"
    sha256 "1690104a4342baeee863635df656286d6dd7b5077e5a52c2f28d97b9c9efd3de"
  end

  on_intel do
    url "https://github.com/konradmichalik/spark/releases/download/#{version.after_comma}/Spark-x86_64-apple-darwin.dmg"
    sha256 "97aa452e269925b07edf2c061afaf60faf283a368b85610a3fe6cb1548520c8e"
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
