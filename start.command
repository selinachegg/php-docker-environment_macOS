#!/bin/bash
# ============================================================
#  start.command — Start the PHP environment (macOS)
#  Double-click this file to start all services
#  Self-healing: auto-fixes permissions and auto-starts Docker
# ============================================================

cd "$(dirname "$0")"

# ── Self-heal ──
chmod +x *.command 2>/dev/null
xattr -d com.apple.quarantine *.command 2>/dev/null

echo ""
echo "=========================================="
echo "   PHP Docker Environment — Starting"
echo "=========================================="
echo ""

# ── Check Docker ──
if ! command -v docker &> /dev/null; then
    echo "  Docker is not installed!"
    echo "  Install it from: https://www.docker.com/products/docker-desktop/"
    echo ""
    read -p "Press Enter to close..."
    exit 1
fi

if ! docker info > /dev/null 2>&1; then
    echo "  Docker Desktop is not running. Launching it..."
    open -a "Docker"
    echo "  Waiting for Docker to start..."
    echo ""

    elapsed=0
    timeout=120
    while ! docker info > /dev/null 2>&1; do
        sleep 3
        elapsed=$((elapsed + 3))
        if [ $elapsed -ge $timeout ]; then
            echo ""
            echo "  Docker Desktop did not start within 2 minutes."
            echo "  Please start it manually and try again."
            echo ""
            read -p "Press Enter to close..."
            exit 1
        fi
        printf "\r  Waiting... %ds" $elapsed
    done
    echo ""
    echo "  Docker Desktop is ready!"
    echo ""
fi

echo "  Docker Desktop is running"
echo ""
echo "  Starting services..."
echo ""

docker compose up -d

echo ""
echo "=========================================="
echo "           Services available"
echo "=========================================="
echo ""
echo "  PHP Site:        localhost:8080"
echo "  phpMyAdmin:      localhost:8081"
echo "  Portainer:       localhost:9000"
echo "  Dashboard:       localhost:8082"
echo ""

sleep 3
echo "  Opening dashboard..."
open "http://localhost:8082"

echo ""
echo "  Environment started successfully!"
echo ""
read -p "Press Enter to close..."
