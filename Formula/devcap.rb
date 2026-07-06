class Devcap < Formula
  desc "Aggregate git commits across repos for standups and time tracking"
  homepage "https://github.com/konradmichalik/devcap"
  version "0.6.1"
  license "MIT"

  on_arm do
    url "https://github.com/konradmichalik/devcap/releases/download/v#{version}/devcap-arm64-apple-darwin.tar.gz"
    sha256 "b8ac6a3bb92be395d9df04372c682518b9117d24fbecb0e1780eb8430a3b3fba"
  end

  on_intel do
    url "https://github.com/konradmichalik/devcap/releases/download/v#{version}/devcap-x86_64-apple-darwin.tar.gz"
    sha256 "dbe860ff02ad2eadebba1ddd07c3a145adfbaefcf8e03526faf9acf7d441eef2"
  end

  def install
    bin.install "devcap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/devcap --version")
  end
end
