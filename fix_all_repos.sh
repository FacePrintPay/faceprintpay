#!/usr/bin/env bash
set -e

echo "=================================================="
echo "🔧 Standardizing & Syncing 'main' Branch Across All Repos"
echo "=================================================="

WORKSPACE_DIR="${HOME}/github-repos"

# Loop through all subdirectories containing a .git folder
find "$WORKSPACE_DIR" -type d -name ".git" | while read -r gitdir; do
    repo_path="$(dirname "$gitdir")"
    repo_name="$(basename "$repo_path")"
    
    echo "--------------------------------------------------"
    echo "📂 Processing repository: $repo_name"
    cd "$repo_path"
    
    # 1. Clean up any stuck rebase or merge locks
    rm -fr .git/rebase-merge .git/rebase-apply .git/MERGE_HEAD
    
    # 2. Switch to main branch (or create it if missing)
    if git show-ref --verify --quiet refs/heads/main; then
        git checkout main
    else
        git checkout -b main || git checkout -B main
    fi
    
    # 3. Pull latest changes with rebase and autostash
    git pull origin main --rebase --autostash || echo "⚠️ Warning: Pull/rebase skipped or requires manual check for $repo_name"
    
    # 4. Push updated state to remote main
    git push -u origin main || echo "⚠️ Warning: Push skipped for $repo_name"
done

echo "=================================================="
echo "✅ All repositories processed and synchronized to main!"
echo "=================================================="
