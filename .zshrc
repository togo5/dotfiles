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

    # Linuxbrew
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
    fi

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

# ghq + fzf integration
function cdp() {
  local selected_dir=$(ghq list -p | fzf --reverse)
  if [[ -n "$selected_dir" ]]; then
    cd "$selected_dir"
  fi
}

# worktree + fzf integration
function cdw() {
  local wt_root="${WT_ROOT:-$HOME/git/wt}"
  if [[ ! -d "$wt_root" ]]; then
    echo "WT_ROOT not found: $wt_root" >&2
    return 1
  fi
  local selected_dir=$(find "$wt_root" -name ".git" -type f -exec dirname {} \; 2>/dev/null | sed "s|^${wt_root}/||" | fzf --reverse)
  if [[ -n "$selected_dir" ]]; then
    cd "$wt_root/$selected_dir"
  fi
}

# asdf
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# Claude Code
export PATH="$HOME/.local/bin:$PATH"

# メモ関数
m(){
  local ts
  ts="$(date '+%F %H:%M')"
  __MEMO_MD+="## ${ts}"$'\n'
  __MEMO_MD+="$(cat)"$'\n\n'
}
m1(){
  local ts
  ts="$(date '+%F %H:%M')"
  __MEMO_MD+="## ${ts}"$'\n'
  __MEMO_MD+="$*"$'\n\n'
}
ml(){ printf "%s" "$__MEMO_MD"; }
mc(){ __MEMO_MD=""; }
ms(){ printf "%s" "$__MEMO_MD" >> "${1:-$HOME/memo.md}"; }
msc(){ ms "$1"; mc; }
