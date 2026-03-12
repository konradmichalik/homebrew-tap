class Devcap < Formula
  desc "Aggregate git commits across repos for standups and time tracking"
  homepage "https://github.com/konradmichalik/devcap"
  version "0.6.0"
  license "MIT"

  on_arm do
    url "https://github.com/konradmichalik/devcap/releases/download/v#{version}/devcap-arm64-apple-darwin.tar.gz"
    sha256 "b0cc9dc2455d7560262532656413a561a92e026967afc0720641706c395267d8"
  end

  on_intel do
    url "https://github.com/konradmichalik/devcap/releases/download/v#{version}/devcap-x86_64-apple-darwin.tar.gz"
    sha256 "a8c4abeed586a9f1c8a015064480547c91011168e127d088e00ef2d0f4ebb62d"
  end

  def install
    bin.install "devcap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/devcap --version")
  end
end
