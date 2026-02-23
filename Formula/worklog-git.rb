class WorklogGit < Formula
  desc "Aggregate git commits across repos for standups and time tracking"
  homepage "https://github.com/konradmichalik/worklog-git"
  version "0.2.0"
  license "MIT"

  on_arm do
    url "https://github.com/konradmichalik/worklog-git/releases/download/v#{version}/worklog-git-arm64-apple-darwin.tar.gz"
    sha256 "44a4beeb3adb5bfa1bf2d09dcc3c4e2fc141b571a49831dc184432c8251f2ad6"
  end

  on_intel do
    url "https://github.com/konradmichalik/worklog-git/releases/download/v#{version}/worklog-git-x86_64-apple-darwin.tar.gz"
    sha256 "98ad2096e3573430e24dc33ba362352935383b90d9718404744a63c82dbbf201"
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
