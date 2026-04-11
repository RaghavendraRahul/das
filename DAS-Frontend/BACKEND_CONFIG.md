# Backend Configuration Guide

This guide explains how to configure the DAS Flutter frontend to connect to different backend ports.

## Current Setup

- **Default Backend URL**: `http://localhost:8001/api`
- **Default Web Port**: `63105`

## Configuration Methods

### Method 1: Using .env File (Recommended for Development)

Edit the [.env](.env) file in the root directory:

```env
API_BASE_URL=http://localhost:8001/api
```

**To change the backend port:**
1. Open `.env` file
2. Change `8001` to your desired port number
3. Restart the Flutter app

**Example for port 9000:**
```env
API_BASE_URL=http://localhost:9000/api
```

### Method 2: Using VS Code Launch Configurations

We've created multiple launch configurations in `.vscode/launch.json`:

#### Available Configurations:

1. **DAS Frontend (Chrome - HTML) - Port 8001**
   - Default configuration with backend on port 8001
   - Web port: 63105
   - Backend: http://localhost:8001/api

2. **DAS Frontend (Edge - HTML) - Port 8001**
   - Same as Chrome but uses Edge browser
   - Web port: 63105
   - Backend: http://localhost:8001/api

3. **DAS Frontend (Chrome) - Custom Backend Port**
   - Uses the port specified in `.env` file
   - Web port: 63105
   - Backend: Reads from `.env`

#### How to Use:
1. Open VS Code
2. Press `F5` or click Run > Start Debugging
3. Select one of the configurations from the dropdown
4. Flutter will start on port 63105 and connect to the specified backend

### Method 3: Command Line with --dart-define

You can override the backend URL when running from terminal:

```bash
# General syntax
flutter run -d chrome --web-port=63105 --dart-define=API_BASE_URL=http://localhost:PORT/api

# Example for port 8001
flutter run -d chrome --web-port=63105 --dart-define=API_BASE_URL=http://localhost:8001/api

# Example for port 9000
flutter run -d chrome --web-port=63105 --dart-define=API_BASE_URL=http://localhost:9000/api
```

### Method 4: Update Default in Code

Edit [lib/src/core/networking/api_client.dart](lib/src/core/networking/api_client.dart):

Find this section:
```dart
if (baseUrl.isEmpty) {
  if (kIsWeb) {
    baseUrl = 'http://localhost:8001/api';  // ← Change this
  // ...
}
```

Change `8001` to your preferred default port.

## Priority Order

The app checks for backend URL in this order:

1. **--dart-define** (highest priority) - from command line or launch.json
2. **.env file** - from API_BASE_URL in .env
3. **Code default** (lowest priority) - hardcoded in api_client.dart

## Checking Current Configuration

When the app starts, it prints the active backend URL in the console:

```
🌐 API Base URL: http://localhost:8001/api
```

Look for this message in:
- VS Code Debug Console (when using F5)
- Terminal output (when using `flutter run`)
- Browser DevTools Console

## Common Scenarios

### Scenario 1: Backend Running on Different Port

**Problem:** Your DAS backend is running on port 9000 instead of 8001

**Solution:**
```bash
# Option A: Update .env
echo "API_BASE_URL=http://localhost:9000/api" >> .env

# Option B: Run with dart-define
flutter run -d chrome --web-port=63105 --dart-define=API_BASE_URL=http://localhost:9000/api
```

### Scenario 2: Multiple Developers with Different Ports

**Problem:** Team members use different backend ports

**Solution:** Each developer should:
1. Copy `.env` to `.env.local` (add to .gitignore)
2. Set their own `API_BASE_URL` in `.env.local`
3. Update code to load from `.env.local` if it exists

### Scenario 3: Production vs Development

**Problem:** Need different URLs for dev and production

**Solution:** Use build flavors and environment-specific configs:

```bash
# Development
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8001/api

# Production
flutter build web --dart-define=API_BASE_URL=https://api.production.com/api
```

## Troubleshooting

### Issue: "Failed to connect to backend"

**Check:**
1. Backend is running: `netstat -ano | findstr :8001`
2. Correct URL in console: Look for "🌐 API Base URL: ..."
3. CORS is enabled on backend
4. No firewall blocking the port

### Issue: "Wrong backend URL being used"

**Check:**
1. Which configuration method you're using
2. Console output for actual URL
3. Clear browser cache and restart app
4. Check all three config sources (.env, dart-define, code)

### Issue: "Port already in use"

**For Flutter web port (61060, 63105, etc.):**
```bash
# Kill process using the port (Windows)
netstat -ano | findstr :63105
taskkill /F /PID <process_id>

# Change to different port
flutter run -d chrome --web-port=63106
```

## Examples

### Start with Custom Ports

```bash
# Backend on 8001, Frontend on 63105
flutter run -d chrome --web-port=63105 --dart-define=API_BASE_URL=http://localhost:8001/api

# Backend on 9000, Frontend on 50000  
flutter run -d chrome --web-port=50000 --dart-define=API_BASE_URL=http://localhost:9000/api
```

### Using with HRM Integration

For the HRM-DAS auto-login flow to work:
1. HRM backend must be on port 8000
2. DAS backend must be on port 8001
3. DAS frontend can be on any port (default: 63105)

The auto-login redirect from HRM will use the DAS frontend port in the URL.

## Quick Reference

| Method | File/Command | Priority | Best For |
|--------|-------------|----------|----------|
| dart-define | `--dart-define=...` | 1 (Highest) | CI/CD, one-time runs |
| .env | `.env` file | 2 | Development |
| Code | `api_client.dart` | 3 (Lowest) | Team defaults |

---

**Last Updated:** 2026-02-25
**Related Files:**
- [.env](.env) - Environment variables
- [api_client.dart](lib/src/core/networking/api_client.dart) - Network configuration
- [launch.json](.vscode/launch.json) - VS Code run configurations
