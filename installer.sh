#!/usr/bin/env bash
# One-click Node.js installer

set -e

echo "🚀 Starting Node.js installation..."

# Detect OS package manager
if [[ "$(uname -s)" == "Darwin" ]]; then
    echo "🍏 macOS detected"
    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install node
elif command -v apt-get >/dev/null 2>&1; then
    echo "🐧 Debian/Ubuntu detected"
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
elif command -v dnf >/dev/null 2>&1; then
    echo "🐧 Fedora/RHEL detected"
    curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
    sudo dnf install -y nodejs
elif command -v yum >/dev/null 2>&1; then
    echo "🐧 CentOS detected"
    curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
    sudo yum install -y nodejs
elif command -v pacman >/dev/null 2>&1; then
    echo "🐧 Arch Linux detected"
    sudo pacman -Sy --noconfirm nodejs npm
else
    echo "❌ Unsupported OS. Install Node.js manually from https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js installation complete!"
echo "📦 Versions:"
node -v
npm -v
