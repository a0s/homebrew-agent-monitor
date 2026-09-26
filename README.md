# homebrew-agent-monitor

Homebrew tap for [agent-monitor](https://github.com/a0s/agent-monitor) — a live
tree of the Codex and Claude Code sessions, subagents and teammates working in a
repository.

```sh
brew trust a0s/agent-monitor    # Homebrew 7 loads formulae only from trusted taps
brew install a0s/agent-monitor/agent-monitor
```

Then, from a project's root:

```sh
agent-monitor
```

Latest from `main` instead of the released tag:

```sh
brew install --HEAD a0s/agent-monitor/agent-monitor
```
