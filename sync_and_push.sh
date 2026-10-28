#!/usr/bin/env bash

echo "=================================================="
echo "🔄 Smart Git Sync & Push: Rebase & Push to Main"
echo "=================================================="

# Ensure we are in the root of the git repository
cd "$(git rev-parse --show-toplevel 2>/dev/null || echo ".")"

# Ensure we are on the main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "🌿 Switching to main branch..."
    git checkout main || git checkout -b main
fi

echo "📥 Pulling latest changes from origin main with rebase & autostash..."
if ! git pull origin main --rebase --autostash; then
    echo "❌ Rebase conflict detected!"
    echo "Please resolve the conflict in your files, then run:"
    echo "  git add ."
    echo "  git rebase --continue"
    echo "  ./sync_and_push.sh"
    exit 1
fi

echo "🚀 Pushing local commits to origin main..."
if git push origin main; then
    echo "=================================================="
    echo "✅ Successfully synced and pushed to origin main!"
    echo "=================================================="
else
    echo "❌ Push failed. Please check remote status or permissions."
    exit 1
fi
