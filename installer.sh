#!/usr/bin/env bash
# Prime Installer - Multi Tool Menu
# Author: Prime

set -e

echo "=================================="
echo "        🚀 Prime Installer"
echo "=================================="
echo ""

# Detect package manager
detect_pm() {
    if [[ "$(uname -s)" == "Darwin" ]]; then
        echo "brew"
    elif command -v apt-get >/dev/null 2>&1; then
        echo "apt"
    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v yum >/dev/null 2>&1; then
        echo "yum"
    elif command -v pacman >/dev/null 2>&1; then
        echo "pacman"
    else
        echo "unknown"
    fi
}
PM=$(detect_pm)

# -------------------------------
# Node.js Installer
# -------------------------------
install_node() {
    echo "➡️ Installing Node.js..."
    if [[ "$PM" == "apt" ]]; then
        curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
        sudo apt-get install -y nodejs
    elif [[ "$PM" == "dnf" ]] || [[ "$PM" == "yum" ]]; then
        curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -
        sudo $PM install -y nodejs
    elif [[ "$PM" == "pacman" ]]; then
        sudo pacman -Sy --noconfirm nodejs npm
    elif [[ "$PM" == "brew" ]]; then
        brew install node
    else
        echo "❌ Unsupported system. Please install Node.js manually."
        return
    fi
    echo "✅ Node.js installed!"
    node -v
    npm -v
}

# -------------------------------
# ipv4 (web) Installer / Start
# -------------------------------
ipv4_web() {
    echo ""
    echo "=================================="
    echo "       🌐 ipv4 (web) Module"
    echo "=================================="
    echo ""
    echo "Choose Type:"
    echo "1) Installer"
    echo "2) Start"
    echo ""
    read -rp "Enter choice [1-2]: " TYPE

    if [[ "$TYPE" == "2" ]] || [[ "$TYPE" =~ [Ss]tart ]]; then
        echo "➡️ Starting Playit agent..."
        echo "⚠️ Press Ctrl + C after ~10s to use your VPS"
        sleep 2
        ./playit-linux-amd64
        return
    fi

    if [[ "$TYPE" == "1" ]] || [[ "$TYPE" =~ [Ii]nstaller ]]; then
        echo ""
        read -rp "Enter port you want to forward (default: 22): " PORT
        PORT=${PORT:-22}

        echo ""
        echo "📢 You must have a Playit account and configure this tunnel as TCP/UDP port forwarding."
        echo "📺 To understand properly, watch my YouTube tutorial."
        echo "⚠️ If your VPS restarts, run this script again and choose 'Start'."
        sleep 5

        echo "➡️ Updating system..."
        sudo apt update -y

        echo "➡️ Installing wget..."
        sudo apt install wget -y

        echo "➡️ Downloading Playit agent..."
        wget -q https://github.com/playit-cloud/playit-agent/releases/download/v0.15.26/playit-linux-amd64

        echo "➡️ Making Playit agent executable..."
        chmod +x playit-linux-amd64

        echo "➡️ Installing Dropbear (SSH server)..."
        sudo apt install dropbear -y

        echo "➡️ Starting Dropbear on port $PORT"
        sudo dropbear -p "$PORT"

        echo ""
        echo "✅ ipv4 (web) installation complete!"
        echo "Run this script again and choose 'Start' to launch Playit."
        return
    fi

    echo "❌ Invalid choice."
}

# -------------------------------
# Main Menu
# -------------------------------
while true; do
    echo ""
    echo "📦 Select an option:"
    echo "1) Node.js Installer"
    echo "2) ipv4 (web)"
    echo "3) Exit"
    echo ""
    read -rp "Enter choice [1-3]: " choice

    case $choice in
        1) install_node ;;
        2) ipv4_web ;;
        3) echo "👋 Exiting Prime Installer. Bye!"; exit 0 ;;
        *) echo "❌ Invalid choice." ;;
    esac
done
