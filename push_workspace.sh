#!/usr/bin/env bash
set -e

echo "=================================================="
echo "🚀 Pushing Workspace Updates to GitHub..."
echo "=================================================="

# 1. Ensure we are in the correct repository directory
cd ~/github-repos/constellation25/FacePrintPay

# 2. Check git status
git status

# 3. Stage modified and new files (including the audit report)
git add workspace_audit_report.json rag_app.py deploy_aios.sh

# 4. Commit changes with a descriptive message
git commit -m "chore(aios): update workspace audit report, pure-python RAG engine, and deployment scripts" || echo "No changes to commit."

# 5. Push to remote main branch
git push origin main

echo "=================================================="
echo "✅ Successfully pushed updates to remote repository!"
echo "=================================================="
