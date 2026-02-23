class WorklogGit < Formula
  desc "Aggregate git commits across repos for standups and time tracking"
  homepage "https://github.com/konradmichalik/worklog-git"
  version "0.1.0"
  license "MIT"

  on_arm do
    url "https://github.com/konradmichalik/worklog-git/releases/download/v#{version}/worklog-git-arm64-apple-darwin.tar.gz"
    sha256 "PLACEHOLDER"
  end

  on_intel do
    url "https://github.com/konradmichalik/worklog-git/releases/download/v#{version}/worklog-git-x86_64-apple-darwin.tar.gz"
    sha256 "PLACEHOLDER"
  end

  def install
    bin.install "worklog-git"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/worklog-git --version")
  end
end
