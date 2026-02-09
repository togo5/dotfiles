#!/bin/bash

# 入力を標準入力から取得
input=$(cat)

# jqを使用して必要な値を抽出
model_name=$(echo "$input" | jq -r '.model.display_name')
used_percentage=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining_percentage=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# 使用率に応じて色を決定する関数
get_color() {
    local percentage=$1

    # 割合が空の場合は白を返す
    if [ -z "$percentage" ]; then
        echo "\033[37m"
        return
    fi

    # 浮動小数点の比較のために bc を使用
    if (( $(echo "$percentage <= 20" | bc -l) )); then
        echo "\033[38;5;28m"      # 深緑
    elif (( $(echo "$percentage <= 40" | bc -l) )); then
        echo "\033[38;5;106m"      # 黄緑
    elif (( $(echo "$percentage <= 60" | bc -l) )); then
        echo "\033[38;5;220m"      # 黄色
    elif (( $(echo "$percentage <= 80" | bc -l) )); then
        echo "\033[38;5;208m" # オレンジ
    else
        echo "\033[38;5;196m"      # 赤
    fi
}

# カラー設定
color=$(get_color "$used_percentage")
reset="\033[0m"

# 出力処理
if [ -n "$used_percentage" ] && [ -n "$remaining_percentage" ]; then
    printf "%s | ${color}使用率: %.1f%%${reset} | ${color}残り: %.1f%%${reset}\n" \
        "$model_name" "$used_percentage" "$remaining_percentage"
else
    printf "%s | コンテキスト: データなし\n" "$model_name"
fi
