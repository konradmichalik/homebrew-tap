cask "spark" do
  version "0.17.0,v0.17.0"

  on_arm do
    url "https://github.com/konradmichalik/spark/releases/download/#{version.after_comma}/Spark-aarch64-apple-darwin.dmg"
    sha256 "bf8961804c3c484a8bbbe5e70b168634402c814c204b3b3a1bd91d617e2c9a10"
  end

  on_intel do
    url "https://github.com/konradmichalik/spark/releases/download/#{version.after_comma}/Spark-x86_64-apple-darwin.dmg"
    sha256 "9d3ba8a947f724ababc0d28ce05004a693dcb1ca360c01cbbe47118697d8f000"
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
