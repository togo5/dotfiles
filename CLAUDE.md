# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリ概要

macOS / Linux (devcontainer) 両対応の個人dotfilesリポジトリ。`install.sh` でツールのインストールとシンボリックリンクの作成を一括で行う。

## ルール

- ツール追加時は基本的に `brew install` を優先する。brewで提供されていない場合のみ別のインストール方法を使う
- `.zshrc` と `.bashrc` は構造が同一。変更時は両方を同期すること
- ホームディレクトリ直下のdotfile (`.zshrc`, `.bashrc`) → repoルートに配置
- XDG準拠の設定 (nvim, zellij, tmux等) → `.config/` 以下に配置
- OS分岐は `$OSTYPE` で判定する
- `install.sh` のシンボリックリンクはバックアップなしで上書きする（gitで復元可能なため）
- 自動生成ファイルやロックファイルはdotfilesの管理対象外とする
  - 例: `lazy-lock.json`, `lazyvim.json`, `.neoconf.json`, `stylua.toml`, `LICENSE`, `README.md`（nvim starter由来）
  - 環境差分レポートでこれらが検出されても同期不要

## devcontainer CLIでdotfilesを使う

`devcontainer.json`の`dotfilesRepository`設定は**VS Code専用**であり、devcontainer CLIでは無視される。
コマンドラインオプションで明示的に指定する必要がある：

```bash
devcontainer up --workspace-folder . \
  --dotfiles-repository https://github.com/togo5/dotfiles.git \
  --dotfiles-install-command install.sh
```

### 利用可能なオプション

| オプション | 説明 | デフォルト |
|-----------|------|-----------|
| `--dotfiles-repository` | dotfilesリポジトリのURL | - |
| `--dotfiles-install-command` | クローン後に実行するコマンド | `install.sh`, `install`, `bootstrap.sh`等を自動検出 |
| `--dotfiles-target-path` | クローン先パス | `~/dotfiles` |

### 参考

- dotfilesの`install.sh`がHomebrewを使う場合、Linux環境でもLinuxbrewとして動作する
- インストール後、PATHを通すには `eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"` が必要
