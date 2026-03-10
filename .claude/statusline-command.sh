#!/bin/bash

# 入力を標準入力から取得
input=$(cat)

# jqを使用して必要な値を抽出
model_name=$(echo "$input" | jq -r '.model.display_name')
used_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')
project_dir=$(echo "$input" | jq -r '.workspace.project_dir // empty')
project_name=$(basename "$project_dir" 2>/dev/null)
lines_added=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
lines_removed=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# ANSI カラーコード
reset="\033[0m"
green="\033[32m"
yellow="\033[33m"
red="\033[31m"

# キャッシュ設定
CACHE_FILE="/tmp/statusline-git-cache-$(echo "$cwd" | md5 -q 2>/dev/null || echo "$cwd" | md5sum 2>/dev/null | cut -d' ' -f1)"
CACHE_MAX_AGE=5  # 秒

cache_is_stale() {
    if [ ! -f "$CACHE_FILE" ]; then
        return 0
    fi
    local now file_age age
    now=$(date +%s)
    file_age=$(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null)
    age=$(( now - file_age ))
    [ "$age" -ge "$CACHE_MAX_AGE" ]
}

# git情報を取得（gitリポジトリの場合のみ）
git_branch=""
git_remote_url=""
git_staged=""
git_modified=""

if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    # リモートURLを取得（クリッカブルリンク用 — 変更頻度が低いのでキャッシュ外）
    remote_url=$(git -C "$cwd" --no-optional-locks remote get-url origin 2>/dev/null)
    if [ -n "$remote_url" ]; then
        if echo "$remote_url" | grep -q "^git@"; then
            git_remote_url=$(echo "$remote_url" | sed 's|git@\([^:]*\):\(.*\)\.git|https://\1/\2|' | sed 's|git@\([^:]*\):\(.*\)|https://\1/\2|')
        else
            git_remote_url=$(echo "$remote_url" | sed 's|\.git$||')
        fi
    fi

    # キャッシュが古い場合のみ git status / branch を実行
    if cache_is_stale; then
        git_branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
        cached_staged=$(git -C "$cwd" --no-optional-locks diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
        cached_modified=$(git -C "$cwd" --no-optional-locks diff --numstat 2>/dev/null | wc -l | tr -d ' ')
        echo "${git_branch}|${cached_staged}|${cached_modified}" > "$CACHE_FILE"
    fi

    # キャッシュから読み込み
    if [ -f "$CACHE_FILE" ]; then
        IFS='|' read -r git_branch git_staged git_modified < "$CACHE_FILE"
    fi
fi

# プログレスバーを構築（printf+tr方式、10文字、▓=使用済み、░=残り）
build_progress_bar() {
    local pct=${1:-0}
    local filled=$(( pct * BAR_WIDTH / 100 ))
    [ "$filled" -gt "$BAR_WIDTH" ] && filled=$BAR_WIDTH
    local empty=$(( BAR_WIDTH - filled ))

    # 使用率に応じてバーの色を決定
    local bar_color
    if [ "$filled" -le 2 ]; then
        bar_color="\033[38;5;28m"      # 深緑
    elif [ "$filled" -le 4 ]; then
        bar_color="\033[38;5;106m"     # 黄緑
    elif [ "$filled" -le 6 ]; then
        bar_color="\033[38;5;220m"     # 黄色
    elif [ "$filled" -le 8 ]; then
        bar_color="\033[38;5;208m"     # オレンジ
    else
        bar_color="\033[38;5;196m"     # 赤
    fi

    local bar="${bar_color}"
    [ "$filled" -gt 0 ] && bar="${bar}$(printf "%${filled}s" | tr ' ' '▓')"
    [ "$empty" -gt 0 ] && bar="${bar}$(printf "%${empty}s" | tr ' ' '░')"
    bar="${bar}${reset}"
    printf "%b" "$bar"
}
BAR_WIDTH=10

# OSC 8 クリッカブルリンクを構築
make_link() {
    local url=$1
    local text=$2
    # OSC 8 ;;URL ST text OSC 8 ;; ST
    printf "\033]8;;%s\033\\%s\033]8;;\033\\" "$url" "$text"
}

# ---- 1行目: [model] 📁 {project} | 🌿 {branch}{git-status} ----
line1=""
line1="${line1}[${model_name}]"

if [ -n "$project_name" ]; then
    if [ -n "$git_remote_url" ]; then
        project_display=$(make_link "$git_remote_url" "$project_name")
    else
        project_display="$project_name"
    fi
    line1="${line1} 📁 ${project_display}"
fi

if [ -n "$git_branch" ]; then
    # ブランチ名の後にgitステータスインジケーター（ファイル数付き）を付与
    status_indicators=""
    [ "$git_staged" -gt 0 ] 2>/dev/null && status_indicators="${status_indicators}${green}+${git_staged}${reset}"
    [ "$git_modified" -gt 0 ] 2>/dev/null && status_indicators="${status_indicators}${yellow}~${git_modified}${reset}"

    line1="${line1} | 🌿 ${git_branch}"
    if [ -n "$status_indicators" ]; then
        line1="${line1} ${status_indicators}"
    fi
fi

# セッション変更行数
lines_display=""
if [ "$lines_added" -gt 0 ] 2>/dev/null || [ "$lines_removed" -gt 0 ] 2>/dev/null; then
    lines_display=" | ${green}+${lines_added}${reset} ${red}-${lines_removed}${reset}"
fi
line1="${line1}${lines_display}"

# ---- 2行目: Context window usage プログレスバー ----
pct=$(echo "$used_percentage" | cut -d. -f1)
if [ -n "$pct" ] && [ "$pct" -ge 0 ] 2>/dev/null; then
    bar=$(build_progress_bar "$pct")
    line2="Context: ${bar} ${pct}%"
else
    line2="Context: --"
fi

printf "%b\n%b\n" "$line1" "$line2"
