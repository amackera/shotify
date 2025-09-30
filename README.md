# Shotify

Take beautiful screenshots of code.

## Status

**Implemented:**
- ✅ `@shotify/core` - Core screenshot generation (HTML/PNG rendering)
- ✅ `@shotify/cli` - Command-line interface

**Planned:**
- ⏳ VS Code extension
- ⏳ Zed editor integration
- ⏳ Neovim plugin
- ⏳ Emacs integration

## Installation

```bash
pnpm install
pnpm build
```

## Usage

### Core Package

```typescript
import { renderHtml, renderPng } from '@shotify/core';

// Generate HTML
const html = await renderHtml(code, {
  lang: 'typescript',
  theme: 'github-dark',
  title: 'example.ts',
  showLineNumbers: true,
});

// Generate PNG
const { outPath } = await renderPng(code, {
  lang: 'typescript',
  theme: 'github-dark',
  out: './screenshot.png',
});
```

### CLI

```bash
# Screenshot a file
shotify example.ts -o screenshot.png

# From stdin
echo "console.log('hello')" | shotify --lang js

# Custom options
shotify code.py --theme github-light --title "My Script" --width 1000
```

**Options:**
- `-l, --lang <language>` - Programming language (default: typescript)
- `-t, --theme <theme>` - Color theme (default: github-dark)
- `--title <title>` - Title bar text
- `--line-numbers/--no-line-numbers` - Toggle line numbers
- `--start-line <number>` - Starting line number
- `-w, --width <pixels>` - Screenshot width (default: 800)
- `-p, --padding <value>` - Padding (default: 2rem)
- `-b, --background <color>` - Background color (default: #1e1e1e)
- `-o, --out <path>` - Output file path

## Development

```bash
# Build all packages
pnpm build

# Watch mode
pnpm dev

# Test core package
cd packages/core && pnpm test
```
