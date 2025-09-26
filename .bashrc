if [[ "$OSTYPE" == "darwin"* ]]; then
    # ========== macOS設定 ==========
    
    # Docker Desktop初期化
    if [ -f "/Users/$USER/.docker/init-bash.sh" ]; then
        source "/Users/$USER/.docker/init-bash.sh" || true
    fi

    # Google Cloud SDK
    if [ -f "/Users/$USER/google-cloud-sdk/path.bash.inc" ]; then 
        . "/Users/$USER/google-cloud-sdk/path.bash.inc"
    fi
    if [ -f "/Users/$USER/google-cloud-sdk/completion.bash.inc" ]; then 
        . "/Users/$USER/google-cloud-sdk/completion.bash.inc"
    fi
    
    # UUIDv4 自動生成（クリップボードコピー付き）
    alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n" | tee >(pbcopy)'
else
    # ========== Linux（Docker Container）設定 ==========
    
    # UUIDv4 自動生成（表示のみ）
    alias uuidgen='uuidgen | tr "[:upper:]" "[:lower:]" | tr -d "\n"'
fi

# ========== 共通設定 ==========
eval "$(starship init bash)"
