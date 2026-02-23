class WorklogGit < Formula
  desc "Aggregate git commits across repos for standups and time tracking"
  homepage "https://github.com/konradmichalik/worklog-git"
  version "0.1.1"
  license "MIT"

  on_arm do
    url "https://github.com/konradmichalik/worklog-git/releases/download/v#{version}/worklog-git-arm64-apple-darwin.tar.gz"
    sha256 "1d6767bf5e6f6401a42328e19cd2d2f81aee43766f6e87644346220dd559178a"
  end

  on_intel do
    url "https://github.com/konradmichalik/worklog-git/releases/download/v#{version}/worklog-git-x86_64-apple-darwin.tar.gz"
    sha256 "877c892d5a09ac742aebd4985226240b85d45f4e5992499472e3aed394c24bae"
  end

  def install
    bin.install "worklog-git"
    bin.install "wl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/worklog-git --version")
    assert_match version.to_s, shell_output("#{bin}/wl --version")
  end
end
