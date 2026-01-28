# Onward Quotee

Claude Code Quoting/Pricing Assistant for Onward Technology Solutions sales team.

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/Onward-Technologies/Onward-Quotee.git
```

### 2. Create a Worktree for Your Session

Each team member should create their own worktree to avoid conflicts:

```bash
cd Onward-Quotee

# Create a worktree with your name or purpose
git worktree add ../Quotee-<yourname> main

# Navigate to your worktree
cd ../Quotee-<yourname>
```

**Example:**
```bash
git worktree add ../Quotee-john main
cd ../Quotee-john
```

### 3. Open in Claude Code

```bash
claude
```

Claude Code will automatically read `CLAUDE.md` and initialize as the Onward Quotee assistant.

### 4. Load API Keys (for validation)

```bash
# Login to Azure (if not already)
az login

# Load keys from Key Vault
source scripts/load-ai-keys.sh
```

### 5. Start Quoting

Ask Claude to help with quotes:

```
Create a quote for a 15-user accounting firm needing managed services
```

```
Validate this HaaS pricing: 55" display at $150/mo including platform and support
```

## Worktree Management

### List Active Worktrees
```bash
git worktree list
```

### Remove a Worktree When Done
```bash
# From the main repo
cd Onward-Quotee
git worktree remove ../Quotee-<yourname>
```

### Why Worktrees?
- Each sales rep has an isolated workspace
- No merge conflicts between concurrent sessions
- Easy cleanup when quote session is complete
- Shared base repo for updates

## Features

- **MSA/OSG Knowledge** - Pre-loaded with Onward's standard terms and service offerings
- **Quote Templates** - Structured quote format with inclusions/exclusions
- **AI Validation** - Multi-provider pricing validation (Google, OpenAI, Anthropic)
- **White-Label Policy** - Automatically follows Onward's vendor naming conventions

## AI Validation

Validate quotes before delivery:

```bash
# Single provider
python3 scripts/ai.py --provider google "Review: Managed services at $150/user for 20-user law firm"

# Multi-provider consultation
python3 scripts/ai.py --consult "Validate: Digital signage HaaS at $175/display including hardware"
```

Target **9/10 confidence** before finalizing quotes.

## Files

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Agent instructions and knowledge base |
| `scripts/ai.py` | AI consultation for pricing validation |
| `scripts/load-ai-keys.sh` | Load API keys from Azure Key Vault |

## Requirements

- [Claude Code](https://claude.ai/claude-code) installed
- Azure CLI (for API key access)
- Python 3.8+ (for validation scripts)

## Dependencies (for validation)

```bash
pip install openai google-generativeai anthropic
```

## Reference Documents

- [Master Services Agreement](https://onward.solutions/msa)
- [Onward Services Guide](https://onward.solutions/osg)

## Support

Contact: support@onward.solutions
