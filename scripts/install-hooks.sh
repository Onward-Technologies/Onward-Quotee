#!/bin/bash
#
# Install git hooks for Onward Quotee
#
# Usage:
#   bash scripts/install-hooks.sh
#
# This installs hooks that notify you when CLAUDE.md changes,
# prompting you to restart Claude Code.
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_SOURCE="$SCRIPT_DIR/hooks"

# Find the git hooks directory (works in worktrees too)
GIT_DIR=$(git rev-parse --git-dir)
HOOKS_TARGET="$GIT_DIR/hooks"

echo "Installing Quotee git hooks..."
echo "  Source: $HOOKS_SOURCE"
echo "  Target: $HOOKS_TARGET"
echo ""

for hook in post-merge post-checkout; do
    if [ -f "$HOOKS_SOURCE/$hook" ]; then
        cp "$HOOKS_SOURCE/$hook" "$HOOKS_TARGET/$hook"
        chmod +x "$HOOKS_TARGET/$hook"
        echo "  Installed: $hook"
    fi
done

echo ""
echo "Done! You'll be notified when CLAUDE.md changes after git pull or checkout."
