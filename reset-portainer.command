#!/bin/bash
# ============================================================
#  reset-portainer.command — Reset Portainer (macOS)
#  Double-click this file to reset the Portainer interface
# ============================================================

cd "$(dirname "$0")"

echo ""
echo "=========================================="
echo "   PHP Docker Environment — Reset"
echo "           Portainer"
echo "=========================================="
echo ""
echo "  This script deletes the Portainer account and"
echo "  resets the interface."
echo "  (PHP files and database are NOT deleted)"
echo ""
read -p "Confirm reset? (y/N) : " confirm

if [[ ! "$confirm" =~ ^[yY]$ ]]; then
    echo ""
    echo "  Cancelled."
    echo ""
    read -p "Press Enter to close..."
    exit 0
fi

echo ""
echo "  Stopping Portainer..."
docker compose stop portainer

echo "  Removing Portainer volume..."
docker volume rm cours_portainer_data 2>/dev/null

echo "  Restarting Portainer..."
docker compose up -d portainer

echo ""
echo "  Portainer has been reset!"
echo ""
echo "  Go NOW to http://localhost:9000"
echo "  to create your new account (5 minutes max)."
echo ""
open http://localhost:9000
read -p "Press Enter to close..."
