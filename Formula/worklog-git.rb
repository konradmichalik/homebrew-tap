class WorklogGit < Formula
  desc "Aggregate git commits across repos for standups and time tracking"
  homepage "https://github.com/konradmichalik/worklog-git"
  version "0.1.0"
  license "MIT"

  on_arm do
    url "https://github.com/konradmichalik/worklog-git/releases/download/v#{version}/worklog-git-arm64-apple-darwin.tar.gz"
    sha256 "c7262ea01200ac78940df194b1c21c9dda313d2947b82b9fc7bb30c1fdb87ca4"
  end

  on_intel do
    url "https://github.com/konradmichalik/worklog-git/releases/download/v#{version}/worklog-git-x86_64-apple-darwin.tar.gz"
    sha256 "d93085b13edbfd1285319cf651b0f897aa0356666d89f6b18cc73df82ded999b"
  end

  def install
    bin.install "worklog-git"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/worklog-git --version")
  end
end
