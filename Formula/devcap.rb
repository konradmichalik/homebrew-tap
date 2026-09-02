class Devcap < Formula
  desc "Aggregate git commits across repos for standups and time tracking"
  homepage "https://github.com/konradmichalik/devcap"
  version "0.7.0"
  license "MIT"

  on_arm do
    url "https://github.com/konradmichalik/devcap/releases/download/v#{version}/devcap-arm64-apple-darwin.tar.gz"
    sha256 "2263d6aebc1f3542d19a7458bfe8792ca6fb4034fce2e44642af478a3e9d0f1e"
  end

  on_intel do
    url "https://github.com/konradmichalik/devcap/releases/download/v#{version}/devcap-x86_64-apple-darwin.tar.gz"
    sha256 "8ec04554f063451edc697d687eeb2c838dd0df784d096ec30e6dd6fb9043fc30"
  end

  def install
    bin.install "devcap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/devcap --version")
  end
end
