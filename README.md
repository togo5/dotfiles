# dotfiles

## ツール（必須: `install.sh`）

| ツール | 説明 |
|--------|------|
| [Neovim](https://neovim.io/) | テキストエディタ (LazyVim) |
| [Lazygit](https://github.com/jesseduffield/lazygit) | Git TUI |
| [tmux](https://github.com/tmux/tmux) | ターミナルマルチプレクサ |
| [Zellij](https://zellij.dev/) | ターミナルマルチプレクサ |
| [Starship](https://starship.rs/) | シェルプロンプト |
| [fzf](https://github.com/junegunn/fzf) | ファジーファインダー |
| [ghq](https://github.com/x-motemen/ghq) | リポジトリ管理 |
| [asdf](https://asdf-vm.com/) | ランタイムバージョン管理 |
| [delta](https://github.com/dandavid/delta) | diff ビューア |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | 高速 grep |
| [fd](https://github.com/sharkdp/fd) | 高速 find |
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | AI コーディングアシスタント |
| [Ghostty](https://ghostty.org/) | ターミナルエミュレータ (macOS) |

## ツール（拡張: `install.sh --extras`）

| ツール | 説明 |
|--------|------|
| [gh](https://cli.github.com/) | GitHub CLI |
| [glab](https://gitlab.com/gitlab-org/cli) | GitLab CLI |
| [ollama](https://ollama.com/) | ローカル LLM |
| [Terraform](https://www.terraform.io/) | IaC |
| [Skaffold](https://skaffold.dev/) | Kubernetes 開発 |
| [dive](https://github.com/wagoodman/dive) | Docker イメージ解析 |
| [dotenvx](https://dotenvx.com/) | .env 管理 |
| [tree](https://oldmanprogrammer.net/source.php?dir=projects/tree) | ディレクトリツリー表示 |
| [yq](https://github.com/mikefarah/yq) | YAML/JSON パーサー |

## 設定ファイル

```
.config/
├── nvim/           # Neovim (LazyVim)
├── lazygit/        # Lazygit
├── tmux/           # tmux
├── zellij/         # Zellij
├── ghostty/        # Ghostty (macOS)
└── starship.toml   # Starship
.claude/            # Claude Code
.zshrc              # Zsh
```

## 前提条件

- macOS: Xcode Command Line Tools (`xcode-select --install`) で git をインストール

## 注意事項

- `install.sh` は既存の設定ファイルをバックアップせずシンボリックリンクで上書きする。変更はgitで管理されているため、必要に応じて `git restore` で復元可能
- シンボリックリンク適用後、ツールが自動生成するファイル（`lazy-lock.json` 等）はdotfilesリポジトリ内に作られるが、gitの管理対象外

## インストール

```bash
git clone https://github.com/togo5/dotfiles.git
cd dotfiles
./install.sh            # Homebrew + core + link（デフォルト）
./install.sh --all      # 全部入り（core + extras + link）
./install.sh --extras   # 追加ツールのみ (gh, ollama, terraform等)
./install.sh --link     # 設定ファイルのリンクのみ
./install.sh --help     # 使い方表示
```

## devcontainer CLI

```bash
devcontainer up --workspace-folder . \
  --dotfiles-repository https://github.com/togo5/dotfiles.git \
  --dotfiles-install-command install.sh
```
