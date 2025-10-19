# @shotify/cli

Command-line tool for taking beautiful screenshots of code with syntax highlighting.

## Installation

```bash
npm install -g @shotify/cli
```

## Quick Start

```bash
# Screenshot a file
shotify example.ts -o screenshot.png

# From stdin
echo "console.log('hello')" | shotify --lang js

# Custom theme and styling
shotify code.py --theme dracula --width 1000 --title "My Script"
```

## Usage

```
shotify [file] [options]
```

If no file is provided, reads from stdin.

## Options

- `-l, --lang <language>` - Programming language (default: `typescript`)
- `-t, --theme <theme>` - Color theme (default: `github-dark`)
- `--title <title>` - Title displayed in screenshot title bar
- `--line-numbers` - Show line numbers (default: `true`)
- `--no-line-numbers` - Hide line numbers
- `--start-line <number>` - Starting line number (default: `1`)
- `-w, --width <pixels>` - Screenshot width in pixels (default: `800`)
- `-p, --padding <value>` - CSS padding around code (default: `2rem`)
- `-b, --background <color>` - Background color (default: `#1e1e1e`)
- `-o, --out <path>` - Output file path

## Examples

### Screenshot a File

```bash
shotify app.js -o screenshot.png
```

### Custom Theme

```bash
shotify server.py --theme tokyo-night --title "FastAPI Server"
```

### From Clipboard (macOS)

```bash
pbpaste | shotify --lang bash -o terminal-output.png
```

### Hide Line Numbers

```bash
shotify config.json --no-line-numbers -o config-screenshot.png
```

### Large Screenshot

```bash
shotify component.tsx --width 1200 --padding 3rem -o component.png
```

### Start Line Numbers at 42

```bash
shotify function.rs --start-line 42 -o rust-function.png
```

## Available Themes

Choose from 55+ beautiful themes:

**Popular Dark Themes:**
- `github-dark`, `dracula`, `monokai`, `nord`, `tokyo-night`
- `one-dark-pro`, `material-theme`, `synthwave-84`

**Popular Light Themes:**
- `github-light`, `light-plus`, `one-light`, `material-theme-lighter`

See all themes at: https://shiki.style/themes

## Supported Languages

100+ programming languages including:

JavaScript, TypeScript, Python, Rust, Go, Java, C++, Ruby, PHP, Swift, Kotlin, Shell, SQL, HTML, CSS, JSON, YAML, Markdown, and [many more](https://shiki.style/languages).

## Output Filenames

Screenshots are automatically named with the theme:
```
screenshot-github-dark-1234567890.png
screenshot-dracula-1234567891.png
```

## Integration

Use `@shotify/cli` in your scripts or workflows:

```bash
# Generate documentation screenshots
for file in examples/*.js; do
  shotify "$file" --theme github-light -o "docs/$(basename "$file" .js).png"
done
```

## Programmatic Usage

For Node.js usage, see [@shotify/core](https://www.npmjs.com/package/@shotify/core).

## Links

- [Main Repository](https://github.com/amackera/shotify)
- [Core Library](https://www.npmjs.com/package/@shotify/core)
- [VS Code Extension](https://github.com/amackera/shotify#vs-code)
- [Documentation](https://github.com/amackera/shotify#readme)
- [Issues](https://github.com/amackera/shotify/issues)

## License

MIT
