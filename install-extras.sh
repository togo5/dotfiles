#!/bin/bash
set -e

echo "=== Extra Tools Installation ==="

if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is required. Run install.sh first."
    exit 1
fi

brew install gh ollama skaffold hashicorp/tap/terraform tree yq glab dive dotenvx/brew/dotenvx

echo ""
echo "=== Done ==="
