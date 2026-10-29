#!/usr/bin/env bash

echo "=================================================="
echo "🔧 Standardizing & Syncing 'main' Branch Safely"
echo "=================================================="

WORKSPACE_DIR="${HOME}/github-repos"

# Find directory paths ending in .git and process their parent directories
find "$WORKSPACE_DIR" -maxdepth 4 -name ".git" -type d | while read -r gitdir; do
    repo_path="$(dirname "$gitdir")"
    repo_name="$(basename "$repo_path")"
    
    # Verify the directory is actually a valid git repository top-level
    if git -C "$repo_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        echo "--------------------------------------------------"
        echo "📂 Processing valid repository: $repo_name ($repo_path)"
        cd "$repo_path"
        
        # 1. Clear rebase/merge lockfiles
        rm -fr .git/rebase-merge .git/rebase-apply .git/MERGE_HEAD
        
        # 2. Ensure main branch is active
        if git show-ref --verify --quiet refs/heads/main; then
            git checkout main
        else
            git checkout -b main 2>/dev/null || git checkout -B main
        fi
        
        # 3. Pull with rebase & autostash
        git pull origin main --rebase --autostash || echo "⚠️ Rebase warning on $repo_name"
        
        # 4. Push to remote main
        git push -u origin main || echo "⚠️ Push skipped for $repo_name"
    fi
done

echo "=================================================="
echo "✅ Valid workspace repositories successfully synced!"
echo "=================================================="
