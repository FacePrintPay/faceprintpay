#!/usr/bin/env bash

echo "=================================================="
echo "🔍 Comprehensive Fleet Code Discovery & Count"
echo "=================================================="

# Define search target zones
TARGET_ZONES=(
    "${HOME}/github-repos"
    "${HOME}/storage"
    "/storage/emulated/0/Documents/Obsidian"
    "/storage/emulated/0/Download"
)

total_repos=0
total_files=0

echo "📂 Scanning targeted zones: Internal Storage, Shared Storage, Vaults, & Total Recall..."
echo "--------------------------------------------------"

# 1. Discover all unique .git repositories across all zones
echo "🔎 Locating all Git Repositories..."
declare -A repo_list

for zone in "${TARGET_ZONES[@]}"; do
    if [ -d "$zone" ]; then
        while IFS= read -r gitdir; do
            repo_path="$(dirname "$gitdir")"
            if git -C "$repo_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
                if [ -z "${repo_list[$repo_path]}" ]; then
                    repo_list[$repo_path]=1
                    total_repos=$((total_repos + 1))
                fi
            fi
        done < <(find "$zone" -name ".git" -type d 2>/dev/null)
    fi
done

echo "✅ Total Unique Git Repositories Discovered: $total_repos"
echo "--------------------------------------------------"

# 2. File Type Breakdown & Total Code Count
echo "📊 Analyzing Code File Types Across Discovered Repos..."

TEMP_STATS=$(mktemp)

for repo_path in "${!repo_list[@]}"; do
    # Find all code files excluding heavy build artifacts and caches
    find "$repo_path" -type f \
        ! -path "*/.git/*" \
        ! -path "*/node_modules/*" \
        ! -path "*/__pycache__/*" \
        ! -path "*/venv/*" \
        ! -path "*/dist/*" \
        ! -path "*/build/*" \
        2>/dev/null | awk -F. '{if (NF>1) print $NF}' >> "$TEMP_STATS"
done

echo ""
echo "📈 Code File Counts by Extension:"
sort "$TEMP_STATS" | uniq -c | sort -nr | head -n 15

# Calculate total files analyzed
total_files=$(wc -l < "$TEMP_STATS")
rm -f "$TEMP_STATS"

echo "--------------------------------------------------"
echo "🎯 Discovery Summary:"
echo "   - Total Repositories: $total_repos"
echo "   - Total Code/Document Files Tracked: $total_files"
echo "=================================================="
