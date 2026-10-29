#!/usr/bin/env bash

echo "=================================================="
echo "🔍 Scanning Internal Storage for Existing Repositories..."
echo "=================================================="

count=0
success_count=0

# Recursively search home storage for all local .git directories
while IFS= read -r gitdir; do
    repo_path="$(dirname "$gitdir")"
    repo_name="$(basename "$repo_path")"
    
    # Verify it is a valid local git work tree
    if git -C "$repo_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        count=$((count + 1))
        echo "--------------------------------------------------"
        echo "[$count] 📂 Found local repo: $repo_name ($repo_path)"
        cd "$repo_path"
        
        # 1. Clear any stuck rebase or merge locks
        rm -fr .git/rebase-merge .git/rebase-apply .git/MERGE_HEAD
        
        # 2. Ensure main branch is active
        if git show-ref --verify --quiet refs/heads/main; then
            git checkout main >/dev/null 2>&1
        else
            git checkout -b main >/dev/null 2>&1 || git checkout -B main >/dev/null 2>&1
        fi
        
        # 3. Pull rebase & push updates using existing local credentials
        if git pull origin main --rebase --autostash >/dev/null 2>&1; then
            if git push -u origin main >/dev/null 2>&1; then
                echo "✅ Successfully synced: $repo_name"
                success_count=$((success_count + 1))
            else
                echo "⚠️ Push skipped/failed for $repo_name"
            fi
        else
            echo "⚠️ Rebase/Pull skipped for $repo_name (manual check needed)"
        fi
    fi
done < <(find ~ -name ".git" -type d 2>/dev/null)

echo "=================================================="
echo "🎯 Complete! Successfully synchronized $success_count out of $count local repositories found."
echo "=================================================="
