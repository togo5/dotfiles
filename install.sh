#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Dotfiles Installation ==="
echo "Dotfiles directory: $DOTFILES_DIR"

# ========== Homebrewのインストール ==========

install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Linux用のPATH設定
        if [[ "$OSTYPE" != "darwin"* ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    fi
    echo "Homebrew: OK"
}

# ========== ツールのインストール ==========

install_tools() {
    echo ""
    echo "=== Installing Tools ==="

    brew install neovim lazygit zellij starship fzf ghq claude-code
}

# ========== 設定ファイルのリンク ==========

link_configs() {
    echo ""
    echo "=== Linking Configuration Files ==="

    mkdir -p ~/.config

    # Neovim (LazyVim)
    if [ -d ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
        echo "Backing up existing nvim config..."
        mv ~/.config/nvim ~/.config/nvim.backup.$(date +%Y%m%d%H%M%S)
    fi
    ln -sfn "$DOTFILES_DIR/.config/nvim" ~/.config/nvim
    echo "Linked: nvim"

    # Zellij
    ln -sfn "$DOTFILES_DIR/.config/zellij" ~/.config/zellij
    echo "Linked: zellij"

    # Lazygit
    if [[ "$OSTYPE" == "darwin"* ]]; then
        LAZYGIT_DIR="$HOME/Library/Application Support/lazygit"
    else
        LAZYGIT_DIR="$HOME/.config/lazygit"
    fi
    mkdir -p "$LAZYGIT_DIR"
    ln -sf "$DOTFILES_DIR/.config/lazygit/config.yml" "$LAZYGIT_DIR/config.yml"
    echo "Linked: lazygit"

    # Starship
    ln -sf "$DOTFILES_DIR/.config/starship.toml" ~/.config/starship.toml
    echo "Linked: starship"

    # Ghostty
    if [[ "$OSTYPE" == "darwin"* ]]; then
        GHOSTTY_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
        mkdir -p "$GHOSTTY_DIR"
        ln -sf "$DOTFILES_DIR/.config/ghostty/config" "$GHOSTTY_DIR/config"
        echo "Linked: ghostty"
    fi

    # Zsh
    if [ -f ~/.zshrc ] && [ ! -L ~/.zshrc ]; then
        mv ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d%H%M%S)
    fi
    ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
    echo "Linked: zshrc"

    # Bash (for Linux/devcontainer)
    if [[ "$OSTYPE" != "darwin"* ]]; then
        if [ -f ~/.bashrc ] && [ ! -L ~/.bashrc ]; then
            mv ~/.bashrc ~/.bashrc.backup.$(date +%Y%m%d%H%M%S)
        fi
        ln -sf "$DOTFILES_DIR/.bashrc" ~/.bashrc
        echo "Linked: bashrc"
    fi

    # Claude Code
    mkdir -p ~/.claude
    ln -sf "$DOTFILES_DIR/.claude/statusline-command.sh" ~/.claude/statusline-command.sh
    chmod +x ~/.claude/statusline-command.sh
    echo "Linked: claude statusline"
    echo "  Note: Copy settings.example.json to ~/.claude/settings.json manually"
}

# ========== メイン ==========

install_homebrew
install_tools
link_configs

echo ""
echo "=== Done ==="
echo "Run: source ~/.zshrc"
