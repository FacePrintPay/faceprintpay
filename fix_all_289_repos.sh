#!/usr/bin/env bash

echo "=================================================="
echo "🔧 Full Workspace Scan & Sync Across All Repositories"
echo "=================================================="

WORKSPACE_DIR="${HOME}/github-repos"
count=0
success_count=0

# Recursively search every directory for .git folders without depth restrictions
while IFS= read -r gitdir; do
    repo_path="$(dirname "$gitdir")"
    repo_name="$(basename "$repo_path")"
    
    # Verify it is a valid git working tree root
    if git -C "$repo_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        count=$((count + 1))
        echo "--------------------------------------------------"
        echo "[$count] 📂 Syncing repository: $repo_name ($repo_path)"
        cd "$repo_path"
        
        # 1. Clean up locks
        rm -fr .git/rebase-merge .git/rebase-apply .git/MERGE_HEAD
        
        # 2. Switch to main branch
        if git show-ref --verify --quiet refs/heads/main; then
            git checkout main >/dev/null 2>&1
        else
            git checkout -b main >/dev/null 2>&1 || git checkout -B main >/dev/null 2>&1
        fi
        
        # 3. Pull & rebase
        if git pull origin main --rebase --autostash >/dev/null 2>&1; then
            # 4. Push to remote main
            if git push -u origin main >/dev/null 2>&1; then
                echo "✅ Successfully synced $repo_name"
                success_count=$((success_count + 1))
            else
                echo "⚠️ Push skipped/failed for $repo_name"
            fi
        else
            echo "⚠️ Rebase/Pull skipped for $repo_name (manual check required)"
        fi
    fi
done < <(find "$WORKSPACE_DIR" -name ".git" -type d)

echo "=================================================="
echo "🎯 Completed! Successfully processed $success_count out of $count discovered repositories."
echo "=================================================="
