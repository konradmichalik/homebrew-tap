class Devcap < Formula
  desc "Aggregate git commits across repos for standups and time tracking"
  homepage "https://github.com/konradmichalik/devcap"
  version "0.4.0"
  license "MIT"

  on_arm do
    url "https://github.com/konradmichalik/devcap/releases/download/v#{version}/devcap-arm64-apple-darwin.tar.gz"
    sha256 "1e64f85f9222d90b4f84b519ea87e8bea1ca3b2b36b802c2fad6665f3f6ab879"
  end

  on_intel do
    url "https://github.com/konradmichalik/devcap/releases/download/v#{version}/devcap-x86_64-apple-darwin.tar.gz"
    sha256 "7adc4f5c7bafa89f30bef51f4cc5e5d88ac851f1203456c5e8891e65f3db53be"
  end

  def install
    bin.install "devcap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/devcap --version")
  end
end
