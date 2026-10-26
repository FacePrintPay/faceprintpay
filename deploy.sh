#!/usr/bin/env bash
set -euo pipefail

echo "[*] Deploying to Vercel..."

# Check if vercel is installed
if ! command -v vercel &> /dev/null; then
    echo "[!] Installing Vercel CLI..."
    npm i -g vercel
fi

# Deploy
if [ "${1:-}" = "--prod" ]; then
    vercel --prod
else
    vercel
fi

echo "[✓] Deployment complete!"
