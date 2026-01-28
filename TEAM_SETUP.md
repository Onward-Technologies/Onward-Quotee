# Onward Quotee - Getting Started

## One-Line Setup (Recommended)

Open Terminal (Mac/Linux) or Git Bash (Windows) and run:

```bash
curl -sL https://raw.githubusercontent.com/Onward-Technologies/Onward-Quotee/main/scripts/init-quotee.sh | bash
```

The script will:
1. Detect your name from Azure CLI or prompt you to enter it
2. Clone the repository (if needed)
3. Create your personal worktree (`~/Quotee-yourname`)
4. Offer to launch Claude Code

---

## Manual Setup (Alternative)

```bash
# Clone the repo (once)
git clone https://github.com/Onward-Technologies/Onward-Quotee.git ~/Onward-Quotee

# Create your worktree (replace YOUR_NAME)
cd ~/Onward-Quotee
git worktree add ../Quotee-YOUR_NAME main

# Open Claude Code
cd ~/Quotee-YOUR_NAME
claude
```

---

## Prerequisites

- **Claude Code** - [Install here](https://claude.ai/claude-code)
- **Git** - Should already be installed
- **Azure CLI** (optional) - For API key access and auto-detecting your username

---

## After Setup

Claude will automatically initialize and ask how it can help with your quote. Example prompts:

- "Create a quote for a 15-user law firm needing managed services"
- "Price out digital signage HaaS for 10 displays"
- "Validate this quote: managed services at $150/user"

---

## Cleanup When Done

```bash
cd ~/Onward-Quotee
git worktree remove ~/Quotee-YOUR_NAME
```
