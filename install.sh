#!/bin/bash
# ============================================================
#  install.sh — One-time macOS setup
#
#  Students run this ONCE by pasting into Terminal:
#    cd ~/Desktop/PHPenv && bash install.sh
#
#  What it does:
#    1. Removes macOS quarantine flags (Gatekeeper)
#    2. Sets executable permissions on all .command files
#    3. Launches Docker Desktop if not running
#    4. Verifies everything works
# ============================================================

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

cd "$(dirname "$0")"

echo ""
echo "=========================================="
echo "   PHP Docker Environment — macOS Setup"
echo "=========================================="
echo ""

# ── Step 1: Remove quarantine flags ──
echo "${BOLD}Step 1/4:${NC} Removing macOS quarantine flags..."
xattr -cr . 2>/dev/null
echo -e "  ${GREEN}✓${NC} Quarantine flags removed"
echo ""

# ── Step 2: Set executable permissions ──
echo "${BOLD}Step 2/4:${NC} Setting executable permissions..."
chmod +x *.command 2>/dev/null
chmod +x install.sh 2>/dev/null
echo -e "  ${GREEN}✓${NC} All .command files are now executable"
echo ""

# ── Step 3: Check Docker Desktop ──
echo "${BOLD}Step 3/4:${NC} Checking Docker Desktop..."

if ! command -v docker &> /dev/null; then
    echo -e "  ${RED}✗${NC} Docker is not installed!"
    echo ""
    echo "  Please install Docker Desktop from:"
    echo "  https://www.docker.com/products/docker-desktop/"
    echo ""
    echo "  After installing, run this script again."
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi

if ! docker info > /dev/null 2>&1; then
    echo -e "  ${YELLOW}!${NC} Docker Desktop is not running. Launching it..."
    open -a "Docker"
    echo "  Waiting for Docker Desktop to start (this may take up to 2 minutes)..."
    echo ""

    elapsed=0
    timeout=120
    while ! docker info > /dev/null 2>&1; do
        sleep 3
        elapsed=$((elapsed + 3))
        if [ $elapsed -ge $timeout ]; then
            echo ""
            echo -e "  ${RED}✗${NC} Docker Desktop did not start within 2 minutes."
            echo "  Please start Docker Desktop manually, then run this script again."
            echo ""
            read -p "Press Enter to close..."
            exit 1
        fi
        printf "\r  Waiting... %ds / %ds" $elapsed $timeout
    done
    echo ""
fi
echo -e "  ${GREEN}✓${NC} Docker Desktop is running"
echo ""

# ── Step 4: Verify docker compose ──
echo "${BOLD}Step 4/4:${NC} Verifying Docker Compose..."
if docker compose version > /dev/null 2>&1; then
    echo -e "  ${GREEN}✓${NC} Docker Compose is available"
else
    echo -e "  ${RED}✗${NC} Docker Compose is not available."
    echo "  Please update Docker Desktop to the latest version."
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi

echo ""
echo "=========================================="
echo -e "  ${GREEN}${BOLD}Setup complete!${NC}"
echo "=========================================="
echo ""
echo "  You can now double-click any .command file:"
echo ""
echo "    launcher.command        → Main menu (Start/Stop/Restart)"
echo "    start.command           → Quick start"
echo "    stop.command            → Quick stop"
echo "    reset-portainer.command → Reset Portainer"
echo ""
echo "  Tip: Use launcher.command — it handles everything!"
echo ""
read -p "Press Enter to close..."
