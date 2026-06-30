#!/usr/bin/env bash
# bump-version.sh — Read the latest git tag and bump Cargo.toml + package.json.
# Usage: ./bump-version.sh [patch|minor|major]
# If no argument given, reads the latest git tag and sets that version.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/.."

cd "$PROJECT_DIR"

# Get the latest tag or default to v0.1.0-alpha.0
LAST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.1.0-alpha.0")
LAST_VERSION="${LAST_TAG#v}"

# If a specific version bump was requested, increment from the last tag
if [ $# -ge 1 ]; then
    IFS='.-' read -r MAJOR MINOR PATCH ALPHA <<< "$LAST_VERSION"
    case "$1" in
        patch) PATCH=$((PATCH + 1)) ;;
        minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
        major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
        *) echo "Usage: $0 [patch|minor|major]"; exit 1 ;;
    esac
    NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}-alpha.${ALPHA:-0}"
else
    NEW_VERSION="$LAST_VERSION"
fi

echo "Bumping version from $LAST_VERSION to $NEW_VERSION"

# Update Cargo.toml
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/^version = \".*\"/version = \"$NEW_VERSION\"/" src-tauri/Cargo.toml
    sed -i '' "s/\"version\": \".*\"/\"version\": \"$NEW_VERSION\"/" package.json 2>/dev/null || true
else
    sed -i "s/^version = \".*\"/version = \"$NEW_VERSION\"/" src-tauri/Cargo.toml
    sed -i "s/\"version\": \".*\"/\"version\": \"$NEW_VERSION\"/" package.json 2>/dev/null || true
fi

echo "Done: $NEW_VERSION"