cask "spark" do
  version "0.1.1,v0.1.1"

  on_arm do
    url "https://github.com/konradmichalik/spark/releases/download/#{version.after_comma}/Spark-aarch64-apple-darwin.dmg"
    sha256 "30e0d825c250448e3478f53c42f5b52e217be6481a71b42b191ae7904bebeb2e"
  end

  on_intel do
    url "https://github.com/konradmichalik/spark/releases/download/#{version.after_comma}/Spark-x86_64-apple-darwin.dmg"
    sha256 "6092d467b6c096ef3eb7488ff916231d93f34dfbe32cc10d0e32d8e585cc554e"
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
