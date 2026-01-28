#!/usr/bin/env bash
# Load AI API Keys from Azure Key Vault
#
# Usage:
#   source scripts/load-ai-keys.sh
#   python3 scripts/ai.py --provider google "Test query"
#
# Prerequisites:
#   - Azure CLI installed and logged in (az login)

VAULT_NAME="${VAULT_NAME:-awetomly-dev-kv-cvdr5hre}"

echo -e "\033[36mLoading AI API keys from Azure Key Vault: $VAULT_NAME\033[0m"

# Check Azure CLI login
ACCOUNT=$(az account show --query name -o tsv 2>/dev/null)
if [ -z "$ACCOUNT" ]; then
    echo -e "\033[31m[ERROR] Not logged into Azure CLI. Run: az login\033[0m"
    return 1 2>/dev/null || exit 1
fi
echo -e "\033[32m[OK] Azure account: $ACCOUNT\033[0m"

# Load each API key
declare -A SECRETS=(
    ["GOOGLE_API_KEY"]="gemini-api-key"
    ["OPENAI_API_KEY"]="openai-api-key"
    ["ANTHROPIC_API_KEY"]="anthropic-api-key"
)

for ENV_VAR in "${!SECRETS[@]}"; do
    SECRET_NAME="${SECRETS[$ENV_VAR]}"
    echo -n "  Loading $ENV_VAR from $SECRET_NAME..."

    VALUE=$(az keyvault secret show --vault-name "$VAULT_NAME" --name "$SECRET_NAME" --query value -o tsv 2>/dev/null)

    if [ -n "$VALUE" ]; then
        export "$ENV_VAR"="$VALUE"
        echo -e " \033[32mOK\033[0m"
    else
        echo -e " \033[33mFAILED (check Key Vault access)\033[0m"
    fi
done

echo ""
echo -e "\033[36mAPI keys loaded. Run: python3 scripts/ai.py --list-providers\033[0m"
