#!/usr/bin/env bash
#
# Onward Quotee - Team Initialization Script
#
# Copy and run this in your terminal to get started:
#
#   curl -sL https://raw.githubusercontent.com/Onward-Technologies/Onward-Quotee/main/scripts/init-quotee.sh | bash
#
# Or save and run locally:
#
#   bash init-quotee.sh
#

set -e

REPO_URL="https://github.com/Onward-Technologies/Onward-Quotee.git"
REPO_DIR="$HOME/Onward-Quotee"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  Onward Quotee - Initialization"
echo "════════════════════════════════════════════════════════════"
echo ""

# Step 1: Detect or prompt for username
echo "Detecting user identity..."

# Try to get username from Azure CLI (Microsoft UPN)
if command -v az &> /dev/null; then
    UPN=$(az account show --query user.name -o tsv 2>/dev/null | cut -d'@' -f1)
fi

# Try environment variables if az didn't work
if [ -z "$UPN" ]; then
    UPN="${USER:-$USERNAME}"
fi

# Prompt user to confirm or enter name
echo ""
echo "Detected username: $UPN"
read -p "Press Enter to use '$UPN' or type a different name: " CUSTOM_NAME

if [ -n "$CUSTOM_NAME" ]; then
    USERNAME="$CUSTOM_NAME"
else
    USERNAME="$UPN"
fi

# Sanitize username (lowercase, no spaces)
USERNAME=$(echo "$USERNAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-')

WORKTREE_DIR="$HOME/Quotee-$USERNAME"
BRANCH_NAME="session/$USERNAME"

echo ""
echo "Setting up worktree: $WORKTREE_DIR"
echo ""

# Step 2: Clone repo if not exists
if [ ! -d "$REPO_DIR" ]; then
    echo "Cloning Onward-Quotee repository..."
    git clone "$REPO_URL" "$REPO_DIR"
else
    echo "Repository exists. Pulling latest..."
    cd "$REPO_DIR"
    git fetch origin
    git pull origin main 2>/dev/null || true
fi

# Step 3: Create worktree if not exists
cd "$REPO_DIR"

if [ -d "$WORKTREE_DIR" ]; then
    echo "Worktree already exists at $WORKTREE_DIR"
else
    echo "Creating worktree for $USERNAME..."
    # Create a new branch for this user's session, based on main
    git worktree add -b "$BRANCH_NAME" "$WORKTREE_DIR" origin/main 2>/dev/null || \
    git worktree add "$WORKTREE_DIR" "$BRANCH_NAME" 2>/dev/null || \
    git worktree add --detach "$WORKTREE_DIR" origin/main
fi

# Step 4: Navigate to worktree
cd "$WORKTREE_DIR"

# Step 5: Install git hooks
if [ -f "scripts/install-hooks.sh" ]; then
    echo "Installing git hooks..."
    bash scripts/install-hooks.sh
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  Setup Complete!"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "  Worktree: $WORKTREE_DIR"
echo ""
echo "  Next steps:"
echo ""
echo "    1. Open your worktree:"
echo "       cd $WORKTREE_DIR"
echo ""
echo "    2. Start Claude Code:"
echo "       claude"
echo ""
echo "    3. (Optional) Load API keys for validation:"
echo "       source scripts/load-ai-keys.sh"
echo ""
echo "════════════════════════════════════════════════════════════"
echo ""

# Ask if user wants to start Claude Code now
read -p "Start Claude Code now? [Y/n] " START_NOW

if [[ "$START_NOW" =~ ^[Nn]$ ]]; then
    echo ""
    echo "Run 'cd $WORKTREE_DIR && claude' when ready."
else
    echo ""
    echo "Starting Claude Code..."
    claude
fi
