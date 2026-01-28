#!/usr/bin/env python3
"""
Onward Quotee - AI Consultation Script

Simple multi-provider AI consultation for quote validation.

Usage:
    python3 scripts/ai.py --provider google "Review this quote pricing"
    python3 scripts/ai.py --provider openai "Validate competitive rates"
    python3 scripts/ai.py --consult "Multi-provider review of quote"

Prerequisites:
    - API keys in environment (use load-ai-keys.sh)
    - pip install openai google-generativeai anthropic
"""

import os
import sys
import json
import argparse
from typing import Optional

# =============================================================================
# PROVIDER IMPLEMENTATIONS
# =============================================================================

def query_openai(prompt: str, system: Optional[str] = None) -> dict:
    """Query OpenAI GPT-5.2"""
    try:
        import openai
    except ImportError:
        return {"success": False, "error": "pip install openai"}

    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key:
        return {"success": False, "error": "OPENAI_API_KEY not set"}

    client = openai.OpenAI(api_key=api_key)
    messages = []
    if system:
        messages.append({"role": "system", "content": system})
    messages.append({"role": "user", "content": prompt})

    try:
        response = client.chat.completions.create(
            model="gpt-4o",  # Use latest available
            messages=messages,
            max_tokens=4096,
        )
        return {
            "success": True,
            "content": response.choices[0].message.content,
            "provider": "openai",
            "model": response.model,
        }
    except Exception as e:
        return {"success": False, "error": str(e)}


def query_google(prompt: str, system: Optional[str] = None) -> dict:
    """Query Google Gemini"""
    try:
        import google.generativeai as genai
    except ImportError:
        return {"success": False, "error": "pip install google-generativeai"}

    api_key = os.environ.get("GOOGLE_API_KEY")
    if not api_key:
        return {"success": False, "error": "GOOGLE_API_KEY not set"}

    genai.configure(api_key=api_key)

    try:
        model = genai.GenerativeModel("gemini-1.5-pro")
        full_prompt = f"{system}\n\n{prompt}" if system else prompt
        response = model.generate_content(full_prompt)
        return {
            "success": True,
            "content": response.text,
            "provider": "google",
            "model": "gemini-1.5-pro",
        }
    except Exception as e:
        return {"success": False, "error": str(e)}


def query_anthropic(prompt: str, system: Optional[str] = None) -> dict:
    """Query Anthropic Claude"""
    try:
        import anthropic
    except ImportError:
        return {"success": False, "error": "pip install anthropic"}

    api_key = os.environ.get("ANTHROPIC_API_KEY")
    if not api_key:
        return {"success": False, "error": "ANTHROPIC_API_KEY not set"}

    client = anthropic.Anthropic(api_key=api_key)

    try:
        kwargs = {
            "model": "claude-sonnet-4-20250514",
            "max_tokens": 4096,
            "messages": [{"role": "user", "content": prompt}],
        }
        if system:
            kwargs["system"] = system

        response = client.messages.create(**kwargs)
        return {
            "success": True,
            "content": response.content[0].text,
            "provider": "anthropic",
            "model": response.model,
        }
    except Exception as e:
        return {"success": False, "error": str(e)}


PROVIDERS = {
    "openai": query_openai,
    "gpt": query_openai,
    "google": query_google,
    "gemini": query_google,
    "anthropic": query_anthropic,
    "claude": query_anthropic,
}

QUOTE_VALIDATION_SYSTEM = """You are an IT services pricing expert helping validate MSP quotes.

When reviewing quotes, consider:
1. Is the pricing competitive for the SW Florida MSP market?
2. Are margins sustainable (target 40-60%)?
3. What are comparable market rates for similar services?
4. Are there any pricing gaps or risks?
5. Is the scope clearly defined with appropriate exclusions?

Always provide:
- Confidence score (1-10)
- Specific recommendations
- Market rate comparisons when possible
"""


def main():
    parser = argparse.ArgumentParser(
        description="Onward Quotee - AI Quote Validation",
        epilog="""
Examples:
  python3 ai.py --provider google "Review digital signage HaaS at $150/month"
  python3 ai.py --provider openai "Validate managed services at $150/user"
  python3 ai.py --consult "Multi-provider validation of quote"
  python3 ai.py --list-providers
"""
    )

    parser.add_argument("prompt", nargs="?", help="Quote details to validate")
    parser.add_argument("--provider", "-p", choices=list(set(PROVIDERS.keys())),
                        help="AI provider to use")
    parser.add_argument("--consult", action="store_true",
                        help="Query multiple providers")
    parser.add_argument("--system", "-s", help="Custom system prompt")
    parser.add_argument("--json", action="store_true", help="JSON output")
    parser.add_argument("--list-providers", action="store_true",
                        help="List available providers")

    args = parser.parse_args()

    if args.list_providers:
        print("\nAvailable Providers:")
        print("-" * 40)
        for name in ["openai", "google", "anthropic"]:
            env_var = f"{name.upper()}_API_KEY"
            status = "OK" if os.environ.get(env_var) else "NOT SET"
            print(f"  {name}: {env_var} [{status}]")
        print("\nRun: source scripts/load-ai-keys.sh")
        return

    if not args.prompt:
        parser.error("Prompt required")

    system = args.system or QUOTE_VALIDATION_SYSTEM

    if args.consult:
        # Multi-provider consultation
        print("=" * 60)
        print("MULTI-PROVIDER QUOTE VALIDATION")
        print("=" * 60)

        results = {}
        for provider in ["openai", "google", "anthropic"]:
            print(f"\n--- {provider.upper()} ---")
            result = PROVIDERS[provider](args.prompt, system)
            results[provider] = result

            if result["success"]:
                print(result["content"][:2000])
                if len(result["content"]) > 2000:
                    print("... [truncated]")
            else:
                print(f"[ERROR: {result['error']}]")

        if args.json:
            print(json.dumps(results, indent=2))
    else:
        # Single provider
        provider = args.provider or "openai"
        result = PROVIDERS[provider](args.prompt, system)

        if args.json:
            print(json.dumps(result, indent=2))
        else:
            if result["success"]:
                print(result["content"])
            else:
                print(f"Error: {result['error']}", file=sys.stderr)
                sys.exit(1)


if __name__ == "__main__":
    main()
