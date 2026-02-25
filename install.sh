#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# ========== Usage ==========

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  --all       Homebrew + core + extras + link（全部入り）
  --core      Homebrew + core ツールのインストール
  --extras    Homebrew + extras ツールのインストール
  --link      設定ファイルのシンボリックリンク作成のみ
  --help      この使い方を表示

フラグなし: Homebrew + core + link（デフォルト）
フラグは組み合わせ可能: $(basename "$0") --core --link
EOF
}

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

# ========== Core ツールのインストール ==========

install_core() {
    echo ""
    echo "=== Installing Core Tools ==="

    brew install asdf neovim lazygit zellij tmux starship fzf ghq delta ripgrep fd

    # Claude Code (ネイティブインストール)
    if ! command -v claude &> /dev/null; then
        curl -fsSL https://claude.ai/install.sh | bash
    fi
}

# ========== Extras ツールのインストール ==========

install_extras() {
    echo ""
    echo "=== Installing Extra Tools ==="

    brew install gh ollama skaffold hashicorp/tap/terraform tree yq glab dive dotenvx/brew/dotenvx
}

# ========== 設定ファイルのリンク ==========

link_configs() {
    echo ""
    echo "=== Linking Configuration Files ==="

    mkdir -p ~/.config

    # Neovim (LazyVim)
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

    # tmux
    ln -sfn "$DOTFILES_DIR/.config/tmux" ~/.config/tmux
    echo "Linked: tmux"

    # markdownlint
    ln -sfn "$DOTFILES_DIR/.config/markdownlint" ~/.config/markdownlint
    echo "Linked: markdownlint"

    # Zsh
    ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
    echo "Linked: zshrc"

    # Bash (for Linux/devcontainer)
    if [[ "$OSTYPE" != "darwin"* ]]; then
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

echo "=== Dotfiles Installation ==="
echo "Dotfiles directory: $DOTFILES_DIR"

# フラグパース
FLAG_CORE=false
FLAG_EXTRAS=false
FLAG_LINK=false

if [ $# -eq 0 ]; then
    # デフォルト: core + link
    FLAG_CORE=true
    FLAG_LINK=true
fi

while [ $# -gt 0 ]; do
    case "$1" in
        --all)
            FLAG_CORE=true
            FLAG_EXTRAS=true
            FLAG_LINK=true
            ;;
        --core)
            FLAG_CORE=true
            ;;
        --extras)
            FLAG_EXTRAS=true
            ;;
        --link)
            FLAG_LINK=true
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
    shift
done

# Homebrew はツールインストール時に必要
if [ "$FLAG_CORE" = true ] || [ "$FLAG_EXTRAS" = true ]; then
    install_homebrew
fi

if [ "$FLAG_CORE" = true ]; then
    install_core
fi

if [ "$FLAG_EXTRAS" = true ]; then
    install_extras
fi

if [ "$FLAG_LINK" = true ]; then
    link_configs
fi

echo ""
echo "=== Done ==="
