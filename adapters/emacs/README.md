# Shotify for Emacs

Take beautiful screenshots of code from Emacs.

## Installation

### Manual Installation

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

## Usage

1. Select a region of code
2. Run `M-x shotify-screenshot` (or use your keybinding)
3. Screenshot saved to `~/Screenshots/` and opened automatically (on macOS)

### Commands

- `shotify-screenshot` - Screenshot selected region
- `shotify-screenshot-buffer` - Screenshot entire buffer

### Configuration

Customize settings with `M-x customize-group RET shotify RET` or add to your config:

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

## Features

- Auto-detects programming language from major mode
- Includes filename as title
- Preserves line numbers from source
- Configurable theme, width, and output location
- Opens screenshot automatically on macOS
