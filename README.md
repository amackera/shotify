# Shotify

Take beautiful screenshots of code.

![Example screenshot](./example.png)

## Status

**Implemented:**
- ✅ `@shotify/core` - Core screenshot generation (HTML/PNG rendering)
- ✅ `@shotify/cli` - Command-line interface
- ✅ Emacs integration

**Planned:**
- ⏳ VS Code extension
- ⏳ Zed editor integration
- ⏳ Neovim plugin

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

### Emacs

**Installation:**

1. Ensure `shotify` CLI is installed and available in your PATH:
   ```bash
   cd packages/cli
   pnpm link --global
   ```

2. Add to your Emacs config (`~/.emacs.d/init.el` or `~/.emacs`):
   ```elisp
   (add-to-list 'load-path "/path/to/shotify/adapters/emacs")
   (require 'shotify)

   ;; Optional: bind to a key
   (global-set-key (kbd "C-c s") 'shotify-screenshot)
   ```

3. Restart Emacs or evaluate the configuration.

**Usage:**

- `M-x shotify-screenshot` - Screenshot selected region
- `M-x shotify-screenshot-buffer` - Screenshot entire buffer

**Configuration:**

```elisp
;; Path to shotify CLI (default: "shotify")
(setq shotify-cli-path "/custom/path/to/shotify")

;; Theme (default: "github-dark")
(setq shotify-theme "github-light")

;; Screenshot width in pixels (default: 800)
(setq shotify-width 1000)

;; Show line numbers (default: t)
(setq shotify-show-line-numbers nil)

;; Output directory (default: "~/Screenshots")
(setq shotify-output-directory "~/Pictures/Code")
```

See [adapters/emacs/README.md](adapters/emacs/README.md) for more details.

## Development

```bash
# Build all packages
pnpm build

# Watch mode
pnpm dev

# Test core package
cd packages/core && pnpm test
```
