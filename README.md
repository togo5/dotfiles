# dotfiles

## ツール

| ツール | 説明 |
|--------|------|
| [Neovim](https://neovim.io/) | テキストエディタ (LazyVim) |
| [Lazygit](https://github.com/jesseduffield/lazygit) | Git TUI |
| [Zellij](https://zellij.dev/) | ターミナルマルチプレクサ |
| [Starship](https://starship.rs/) | シェルプロンプト |
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | AI コーディングアシスタント |
| [Ghostty](https://ghostty.org/) | ターミナルエミュレータ (macOS) |

## 設定ファイル

```
.config/
├── nvim/           # Neovim (LazyVim)
├── lazygit/        # Lazygit
├── zellij/         # Zellij
├── ghostty/        # Ghostty (macOS)
└── starship.toml   # Starship
.claude/            # Claude Code
.zshrc              # Zsh
```

## インストール

```bash
git clone https://github.com/togo5/dotfiles.git
cd dotfiles
./install.sh
```

## devcontainer CLI

```bash
devcontainer up --workspace-folder . \
  --dotfiles-repository https://github.com/togo5/dotfiles.git \
  --dotfiles-install-command install.sh
```
