# Claude Code Provider Manager

Multi-provider manager for Claude Code with automatic API key failover.

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/whitemonkey01/Claude_code_proxy/main/install.sh | bash
```

Or via npm:

```bash
npx claude-provider-manager
```

## Usage

```bash
provider add aerolink          # Add a provider
provider list                  # List saved providers
provider switch aerolink       # Switch to a provider
provider gui                   # Launch terminal GUI
provider proxy status          # Check proxy status
```

### Multi-Key Failover

Add backup API keys — if one hits a rate limit or auth error, the next is tried automatically.

```bash
# Via CLI:
provider set FreeModel API_KEYS "key1,key2,key3"

# Via GUI:
provider gui → select provider → press [k] → add keys
```

## Providers

| Provider | Type | Notes |
|----------|------|-------|
| Aerolink | Direct | `ANTHROPIC_BASE_URL=https://capi.aerolink.lat/` |
| FreeModel | Multi-key failover | `ANTHROPIC_BASE_URL=https://api-cc.freemodel.dev` |
| NVIDIA NIM | Proxy (claude-code-proxy) | `ANTHROPIC_BASE_URL=http://127.0.0.1:8082` |

## Files

| File | Purpose |
|------|---------|
| `bin/provider` | CLI (bash) |
| `bin/provider-gui` | TUI (Python curses) |
| `bin/key-failover-proxy` | Failover proxy (Flask) |
| `~/.claude-providers` | Provider config |
| `~/.claude/settings.json` | Active provider env vars for Claude Code |

## License

MIT
