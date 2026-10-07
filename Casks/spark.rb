cask "spark" do
  version "0.13.0,v0.13.0"

  on_arm do
    url "https://github.com/konradmichalik/spark/releases/download/#{version.after_comma}/Spark-aarch64-apple-darwin.dmg"
    sha256 "6d7fab75ae5b2869319a7eae7df6011b6d5aa478f37f34a618389d7c225c8abd"
  end

  on_intel do
    url "https://github.com/konradmichalik/spark/releases/download/#{version.after_comma}/Spark-x86_64-apple-darwin.dmg"
    sha256 "31d294b0d5004358e64dcf6b96be67e2b4e23551c4a1597cb63678839bc40f39"
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
