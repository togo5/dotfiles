#!/bin/bash

# 入力を標準入力から取得
input=$(cat)

# jqを使用して必要な値を抽出
model_name=$(echo "$input" | jq -r '.model.display_name')
used_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining_percentage=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# git branchを取得（gitリポジトリの場合のみ、ロックをスキップ）
git_branch=""
if [ -n "$cwd" ] && [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    git_branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null)
fi

# 使用率に応じて色を決定
get_color() {
    local percentage=$1
    if [ -z "$percentage" ]; then
        echo "\033[37m"
        return
    fi
    if (( $(echo "$percentage <= 20" | bc -l) )); then
        echo "\033[38;5;28m"      # 深緑
    elif (( $(echo "$percentage <= 40" | bc -l) )); then
        echo "\033[38;5;106m"     # 黄緑
    elif (( $(echo "$percentage <= 60" | bc -l) )); then
        echo "\033[38;5;220m"     # 黄色
    elif (( $(echo "$percentage <= 80" | bc -l) )); then
        echo "\033[38;5;208m"     # オレンジ
    else
        echo "\033[38;5;196m"     # 赤
    fi
}

color=$(get_color "$used_percentage")
reset="\033[0m"

# 出力を構築（モデル名 | ブランチ名 | 使用率 の順）
output="$model_name"

# ブランチ名を追加
if [ -n "$git_branch" ]; then
    output="$output | $git_branch"
fi

# 使用率を追加
if [ -n "$used_percentage" ] && [ -n "$remaining_percentage" ]; then
    output="$output | ${color}%.1f%% / %.1f%%${reset}"
    printf "$output\n" "$used_percentage" "$remaining_percentage"
else
    printf "$output\n"
fi
