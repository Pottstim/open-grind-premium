#!/usr/bin/env bash
# P3 #21: Auto-bump Cargo.toml + package.json version from the latest git tag.
# Run in CI before build. Reads the latest `v*` tag and syncs both manifests.
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || echo "$(cd "$(dirname "$0")/.." && pwd)")"
cd "$repo_root"

latest_tag="$(git describe --tags --abbrev=0 --match 'v*' 2>/dev/null || echo "")"
if [[ -z "$latest_tag" ]]; then
  echo "[bump-version] no v* tags found; skipping bump" >&2
  exit 0
fi

# Strip leading 'v'
ver="${latest_tag#v}"
echo "[bump-version] latest tag: $latest_tag → version: $ver"

# --- Cargo.toml (src-tauri) ---
cargo="src-tauri/Cargo.toml"
if [[ -f "$cargo" ]]; then
  # Replace version under [package] (first occurrence).
  python3 - "$cargo" "$ver" <<'PY'
import re, sys
path, ver = sys.argv[1], sys.argv[2]
src = open(path).read()
new = re.sub(r'^version = "[^"]*"', f'version = "{ver}"', src, count=1, flags=re.M)
open(path, "w").write(new)
PY
  echo "[bump-version] updated $cargo"
fi

# --- package.json (frontend) ---
pkg="package.json"
if [[ -f "$pkg" ]]; then
  python3 - "$pkg" "$ver" <<'PY'
import json, sys
path, ver = sys.argv[1], sys.argv[2]
d = json.load(open(path))
d["version"] = ver
open(path, "w").write(json.dumps(d, indent=2) + "\n")
PY
  echo "[bump-version] updated $pkg"
fi
