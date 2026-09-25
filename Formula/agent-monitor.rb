class AgentMonitor < Formula
  desc "Live tree of the Codex and Claude Code agents working in a repository"
  homepage "https://github.com/a0s/agent-monitor"
  url "https://github.com/a0s/agent-monitor/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "a44ca418f51bbc38a7162d9ec478d3962245a204dcc104f1db84dedf0d70d84a"
  license "MIT"
  head "https://github.com/a0s/agent-monitor.git", branch: "main"

  depends_on "node"

  def install
    # Hooks run with whatever PATH the agent has, which need not include Homebrew's
    # bin; the opt path of node survives node upgrades where a Cellar path would not.
    inreplace "bin/agent-monitor", "#!/usr/bin/env node", "#!#{Formula["node"].opt_bin}/node"
    libexec.install "bin", "lib", "package.json"
    bin.install_symlink libexec/"bin/agent-monitor"
  end

  def caveats
    <<~EOS
      Run it from a project's root, in a spare terminal:

        agent-monitor

      It needs nothing installed into the project. Hooks are optional and make
      started and stopped states exact:

        agent-monitor --install-hooks                  # ~/.claude and ~/.codex
        agent-monitor --install-hooks ~/.claude-work   # any other config folder
        agent-monitor --remove-hooks                   # take them all off again

      Remove the hooks before `brew uninstall agent-monitor`.
    EOS
  end

  test do
    assert_match "agent-monitor #{version}", shell_output("#{bin}/agent-monitor --version")

    ENV["HOME"] = testpath
    system "git", "init", "-q", testpath/"repo"
    project = testpath/".claude/projects/p"
    project.mkpath
    (project/"s1.jsonl").write <<~JSON
      {"type":"assistant","sessionId":"s1","cwd":"#{(testpath/"repo").realpath}","message":{"model":"claude-sonnet-5"}}
    JSON
    cd testpath/"repo" do
      assert_match '"model": "sonnet-5"', shell_output("#{bin}/agent-monitor --json")
    end

    (testpath/".claude-work/projects").mkpath
    shell_output("#{bin}/agent-monitor --install-hooks #{testpath}/.claude-work")
    assert_match "_event SessionStart claude-code", (testpath/".claude-work/settings.json").read
    shell_output("#{bin}/agent-monitor --remove-hooks")
    refute_path_exists testpath/".claude-work/settings.json"
  end
end
