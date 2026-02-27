class Devcap < Formula
  desc "Aggregate git commits across repos for standups and time tracking"
  homepage "https://github.com/konradmichalik/devcap"
  version "0.3.1"
  license "MIT"

  on_arm do
    url "https://github.com/konradmichalik/devcap/releases/download/v#{version}/devcap-arm64-apple-darwin.tar.gz"
    sha256 "d77a0b927e3612fc257c99e57d1cee0d174e2d657ff6fea617c8e3cf40ce6f06"
  end

  on_intel do
    url "https://github.com/konradmichalik/devcap/releases/download/v#{version}/devcap-x86_64-apple-darwin.tar.gz"
    sha256 "dccc5d056d180bfdddb1fd4ea15914d84eedabda26eae31482592f6023233bb1"
  end

  def install
    bin.install "devcap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/devcap --version")
  end
end
