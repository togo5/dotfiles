if [[ "$OSTYPE" == "darwin"* ]]; then
    # ========== macOS設定 ==========
    
    # Docker Desktop初期化
    if [ -f "/Users/$USER/.docker/init-zsh.sh" ]; then
        source "/Users/$USER/.docker/init-zsh.sh" || true
    fi

    # Google Cloud SDK
    if [ -f "/Users/$USER/google-cloud-sdk/path.zsh.inc" ]; then 
        . "/Users/$USER/google-cloud-sdk/path.zsh.inc"
    fi
    if [ -f "/Users/$USER/google-cloud-sdk/completion.zsh.inc" ]; then 
        . "/Users/$USER/google-cloud-sdk/completion.zsh.inc"
    fi
    
    # UUIDv4 自動生成（クリップボードコピー付き）
    alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n" | tee >(pbcopy)'    
else
    # ========== Linux（Docker Container）設定 ==========
    
    # UUIDv4 自動生成（表示のみ）
    alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n"'    
fi

# ========== 共通設定 ==========

# Starship prompt
eval "$(starship init zsh)"

# エイリアス
alias lg="lazygit"
alias vi="nvim"
alias vim="nvim"

# PATH設定
export PATH="$HOME/.local/bin:$PATH"
