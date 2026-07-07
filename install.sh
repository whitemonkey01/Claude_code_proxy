#!/usr/bin/env bash
set -e

# claude-provider-manager — one-command installer
REPO_BASE="https://raw.githubusercontent.com/whitemonkey01/Claude_code_proxy/main"
INSTALL_DIR="${HOME}/.local/bin"
RED='\033[0;31m'; GREEN='\033[0;32m'; NC='\033[0m'
info() { echo -e "${GREEN}[INFO]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo "╔══════════════════════════════════════╗"
echo "║   Claude Code Provider Manager       ║"
echo "║   One-Click Install                  ║"
echo "╚══════════════════════════════════════╝"

# Check prerequisites
command -v python3 >/dev/null 2>&1 || { error "python3 required"; exit 1; }
command -v node    >/dev/null 2>&1 || { error "nodejs required";  exit 1; }
command -v npm     >/dev/null 2>&1 || { error "npm required";     exit 1; }
command -v pip3    >/dev/null 2>&1 && PIP=pip3 || PIP=pip

# Download scripts
mkdir -p "$INSTALL_DIR"
info "Downloading scripts..."
for f in provider provider-gui key-failover-proxy; do
    url="$REPO_BASE/bin/$f"
    out="$INSTALL_DIR/$f"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$url" -o "$out"
    elif command -v wget >/dev/null 2>&1; then
        wget -q "$url" -O "$out"
    else
        error "Need curl or wget"
        exit 1
    fi
    chmod +x "$out"
    info "  $f"
done

# Install Python deps
info "Installing Python dependencies..."
$PIP install flask requests --user 2>/dev/null || \
    $PIP install flask requests 2>/dev/null || \
    error "Could not install Python deps. Run: $PIP install flask requests"

# Install claude-code-proxy (optional)
if command -v npm >/dev/null 2>&1; then
    info "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code 2>/dev/null && info "  claude installed" || \
        info "  Skipped (run: npm install -g @anthropic-ai/claude-code)"
fi

# Setup PATH in ~/.bashrc
if ! grep -q '\.local/bin' ~/.bashrc 2>/dev/null; then
    echo "" >> ~/.bashrc
    echo '# Added by claude-provider-manager' >> ~/.bashrc
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    info "Added ~/.local/bin to PATH in ~/.bashrc"
fi
if ! grep -q 'alias claude' ~/.bashrc 2>/dev/null; then
    echo 'alias claude="claude --bare"' >> ~/.bashrc
    info "Added claude alias to ~/.bashrc"
fi

echo ""
info "Install complete!"
echo ""
echo "  Restart your shell or run:  source ~/.bashrc"
echo ""
echo "  Then:"
echo "    provider add <name>     Add a provider"
echo "    provider switch <name>  Switch to it"
echo "    provider gui            Launch GUI"
echo "    provider --help         All commands"
echo ""
echo "  Or use npm:  npx claude-provider-manager"
