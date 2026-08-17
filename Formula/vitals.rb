class Vitals < Formula
  desc "Vital signs of your local dev stack"
  homepage "https://github.com/konradmichalik/vitals"
  version "0.1.0"
  license "MIT"

  on_arm do
    url "https://github.com/konradmichalik/vitals/releases/download/v#{version}/vitals-arm64-apple-darwin.tar.gz"
    sha256 "a0d8ea3f85d687c8bb637c4e53bcd83b0b821e6ae6dc73ae47b2a04e7acf5f16"
  end

  on_intel do
    url "https://github.com/konradmichalik/vitals/releases/download/v#{version}/vitals-x86_64-apple-darwin.tar.gz"
    sha256 "c23c1580b184b83802576d8aaec25a7862e01bad8e88c4defee9031a0d663239"
  end

  def install
    bin.install "vitals"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vitals --version")
  end
end
