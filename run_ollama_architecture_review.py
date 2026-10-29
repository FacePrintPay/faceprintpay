import urllib.request
import json
import os

INDEX_PATH = os.path.expanduser("~/full_stack_discovered_bundle/source_index.json")

# Load repository count and list summary
if os.path.exists(INDEX_PATH):
    with open(INDEX_PATH, "r") as f:
        data = json.load(f)
    repo_count = len(data)
    repo_sample = list(data.keys())[:15]
else:
    repo_count = 70
    repo_sample = []

prompt = f"""You are the Principal Systems Architect for Constellation25 AIOS. We have successfully discovered and indexed our local fleet of {repo_count} repositories across internal storage, shared storage, Obsidian vaults, and Total Recall.

Provide an expert, enterprise-grade, vertically integrated architecture blueprint and deployment guide to package this entire ecosystem as a sovereign, self-contained AIOS (AI Operating System).

Please structure your response with:
1. **Vertical Integration Strategy**: How to unify the 70 repositories into a single cohesive runtime namespace (`/api/v1/*`).
2. **Complete Bill of Materials (BOM)**: Every dependency, tool, runtime, and infrastructure item needed to deploy locally in Termux/Docker.
3. **Step-by-Step Deployment Guide**: Clear, precise commands to build, initialize, and run the system.
4. **Immediate Next Steps**: Concrete execution priorities for production readiness.
"""

payload = {
    "model": "llama3.2:1b",
    "prompt": prompt,
    "stream": False
}

req = urllib.request.Request(
    "http://localhost:11434/api/generate",
    data=json.dumps(payload).encode("utf-8"),
    headers={"Content-Type": "application/json"}
)

print("🧠 Querying local Ollama (Llama 3.2 1B) for Enterprise AIOS Architecture Blueprint...\n")

try:
    with urllib.request.urlopen(req, timeout=120) as response:
        result = json.loads(response.read().decode("utf-8"))
        print(result.get("response", "No response generated."))
except Exception as e:
    print(f"❌ Failed to query local Ollama: {e}")
