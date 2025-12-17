# Shotify for Emacs

Take beautiful screenshots of code from Emacs.

## Prerequisites

Ensure `shotify` CLI is installed and available in your PATH:

```bash
npm install -g @shotify/cli
```

Or build from source:

```bash
cd packages/cli
pnpm install
pnpm link --global
```

## Installation

### Using use-package with vc (Emacs 29+)

```elisp
(use-package shotify
  :vc (:url "https://github.com/amackera/shotify"
       :lisp-dir "adapters/emacs"
       :rev :newest)
  :bind (("C-c s s" . shotify-screenshot)
         ("C-c s b" . shotify-screenshot-buffer)
         ("C-c s c" . shotify-screenshot-to-clipboard)
         ("C-c s C" . shotify-screenshot-buffer-to-clipboard)))
```

Note: `:rev :newest` is required because the package lives in a subdirectory of the monorepo.

### Using straight.el

```elisp
(straight-use-package
 '(shotify :type git
           :host github
           :repo "amackera/shotify"
           :files ("adapters/emacs/*.el")))
```

### Manual Installation

1. Clone this repository or download `shotify.el`

2. Add to your Emacs config (`~/.emacs.d/init.el` or `~/.emacs`):
   ```elisp
   (add-to-list 'load-path "/path/to/shotify/adapters/emacs")
   (require 'shotify)

   ;; Optional: bind to keys
   (global-set-key (kbd "C-c s s") 'shotify-screenshot)
   (global-set-key (kbd "C-c s c") 'shotify-screenshot-to-clipboard)
   ```

3. Restart Emacs or evaluate the configuration.

## Usage

1. Select a region of code (or use buffer commands for entire file)
2. Run the desired command
3. Screenshot is saved to `~/Screenshots/` and/or copied to clipboard

### Commands

| Command | Description |
|---------|-------------|
| `shotify-screenshot` | Screenshot selected region, save to file |
| `shotify-screenshot-buffer` | Screenshot entire buffer, save to file |
| `shotify-screenshot-to-clipboard` | Screenshot selected region, copy to clipboard |
| `shotify-screenshot-buffer-to-clipboard` | Screenshot entire buffer, copy to clipboard |

## Configuration

Customize settings with `M-x customize-group RET shotify RET` or add to your config:

```elisp
;; Path to shotify CLI (default: "shotify")
(setq shotify-cli-path "shotify")

;; Theme (default: "github-dark")
;; See https://shiki.style/themes for available themes
(setq shotify-theme "github-dark")

;; Screenshot width in pixels (default: 800)
(setq shotify-width 800)

;; Show line numbers (default: t)
(setq shotify-show-line-numbers t)

;; Output directory (default: "~/Screenshots")
(setq shotify-output-directory "~/Screenshots")

;; Padding around code (default: "2rem")
(setq shotify-padding "2rem")

;; Background color (default: "#1e1e1e")
(setq shotify-background "#1e1e1e")

;; DPI scale factor (default: 2)
(setq shotify-scale 2)
```

### Example Configuration with use-package

```elisp
(use-package shotify
  :vc (:url "https://github.com/amackera/shotify"
       :lisp-dir "adapters/emacs"
       :rev :newest)
  :custom
  (shotify-theme "dracula")
  (shotify-width 1000)
  (shotify-padding "3rem")
  (shotify-output-directory "~/Pictures/Screenshots")
  :bind (("C-c s s" . shotify-screenshot)
         ("C-c s b" . shotify-screenshot-buffer)
         ("C-c s c" . shotify-screenshot-to-clipboard)
         ("C-c s C" . shotify-screenshot-buffer-to-clipboard)))
```

## Features

- Auto-detects programming language from major mode
- Includes filename as title in the screenshot
- Preserves line numbers from source file
- Cross-platform clipboard support (macOS, Linux, Windows)
- Configurable theme, width, padding, background, and more
- Opens screenshot location automatically after saving

## Supported Languages

Language detection maps Emacs major modes to Shiki language identifiers:

| Major Mode | Language |
|------------|----------|
| `typescript-mode`, `typescript-ts-mode` | typescript |
| `javascript-mode`, `js-mode`, `js2-mode` | javascript |
| `python-mode`, `python-ts-mode` | python |
| `ruby-mode`, `ruby-ts-mode` | ruby |
| `rust-mode`, `rust-ts-mode` | rust |
| `go-mode`, `go-ts-mode` | go |
| `java-mode`, `java-ts-mode` | java |
| `c++-mode`, `c++-ts-mode` | cpp |
| `c-mode`, `c-ts-mode` | c |
| `sh-mode`, `bash-ts-mode` | bash |
| `emacs-lisp-mode` | lisp |
| `clojure-mode` | clojure |
| `html-mode`, `mhtml-mode` | html |
| `css-mode` | css |
| `json-mode`, `json-ts-mode` | json |
| `yaml-mode`, `yaml-ts-mode` | yaml |
| `markdown-mode` | markdown |

Other modes default to `text`.
