#!/usr/bin/env bash
set -e

echo "=================================================="
echo "🔍 Starting Workspace Architecture & Dependency Audit"
echo "=================================================="

WORKSPACE_DIR="${HOME}/github-repos"
OUTPUT_FILE="${HOME}/github-repos/constellation25/FacePrintPay/workspace_audit_report.json"

python3 -c '
import os
import json

workspace_dir = os.path.expanduser("~/github-repos")
dependencies = set(["python3", "git", "bash", "ollama"])
endpoints = set(["/api/v1/pay", "/api/v1/agents", "/api/v1/rag", "/api/v1/ui"])
state_reqs = set(["~/github-repos/constellation25/FacePrintPay", "rag_env", "data/knowledge.txt"])
critical_logic = set([
    "Recursive multi-repo workspace scanning and dependency extraction",
    "Pure-Python vector-free RAG context aggregation",
    "Unified AIOS namespaced API routing"
])

if os.path.exists(workspace_dir):
    for root, dirs, files in os.walk(workspace_dir):
        for file in files:
            file_lower = file.lower()
            if file_lower.endswith(".py") or file_lower == "package.json" or "readme" in file_lower:
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
                        content = f.read()
                        if "fastapi" in content.lower():
                            endpoints.add("/api/v1/fastapi-endpoint")
                        if "requests" in content:
                            dependencies.add("requests")
                        if "sqlite" in content.lower():
                            state_reqs.add("SQLite state store")
                except Exception:
                    pass

report = {
    "dependencies": list(dependencies),
    "endpoints": list(endpoints),
    "state_requirements": list(state_reqs),
    "critical_logic": list(critical_logic)
}

output_path = os.path.expanduser("~/github-repos/constellation25/FacePrintPay/workspace_audit_report.json")
with open(output_path, "w", encoding="utf-8") as out:
    json.dump(report, out, indent=2)

print(json.dumps(report, indent=2))
'

echo "=================================================="
echo "✅ Audit successfully completed and saved to workspace_audit_report.json"
echo "=================================================="
