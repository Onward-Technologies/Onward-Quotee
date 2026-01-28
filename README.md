# Onward Quotee

Claude Code Quoting/Pricing Assistant for Onward Technology Solutions sales team.

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/Onward-Technologies/Onward-Quotee.git
cd Onward-Quotee
```

### 2. Open in Claude Code

```bash
claude
```

Claude Code will automatically read `CLAUDE.md` and initialize as the Onward Quotee assistant.

### 3. Load API Keys (for validation)

```bash
# Login to Azure (if not already)
az login

# Load keys from Key Vault
source scripts/load-ai-keys.sh
```

### 4. Start Quoting

Ask Claude to help with quotes:

```
Create a quote for a 15-user accounting firm needing managed services
```

```
Validate this HaaS pricing: 55" display at $150/mo including platform and support
```

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
