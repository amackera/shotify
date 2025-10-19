# @shotify/core

Core screenshot generation library for beautiful code screenshots with syntax highlighting.

## Installation

```bash
npm install @shotify/core
```

## Features

- 🎨 Syntax highlighting powered by [Shiki](https://shiki.style)
- 🌈 55+ built-in themes
- 🔢 Line numbering with custom start positions
- 📐 Customizable width, padding, and styling
- 🖼️ PNG output via Puppeteer
- 💻 100+ programming languages supported

## Usage

### Generate HTML

```typescript
import { renderHtml } from '@shotify/core';

const html = await renderHtml(code, {
  lang: 'typescript',
  theme: 'github-dark',
  title: 'example.ts',
  showLineNumbers: true,
  startLine: 1,
  width: 800,
  padding: '2rem',
  background: '#1e1e1e'
});
```

### Generate PNG Screenshot

```typescript
import { renderPng } from '@shotify/core';

const { outPath } = await renderPng(code, {
  lang: 'typescript',
  theme: 'github-dark',
  title: 'example.ts',
  out: './screenshot.png'
});

console.log(`Screenshot saved: ${outPath}`);
```

## API

### `renderHtml(code: string, options: RenderOptions): Promise<string>`

Generates syntax-highlighted HTML from code.

**Options:**
- `lang` (string, required) - Programming language
- `theme` (string) - Theme name (default: `'github-dark'`)
- `title` (string) - Optional title displayed in title bar
- `showLineNumbers` (boolean) - Show line numbers (default: `true`)
- `startLine` (number) - Starting line number (default: `1`)
- `width` (number) - Screenshot width in pixels (default: `800`)
- `padding` (string) - CSS padding value (default: `'2rem'`)
- `background` (string) - Background color (default: `'#1e1e1e'`)

### `renderPng(code: string, options: RenderOptions & { out?: string }): Promise<{ outPath: string }>`

Generates a PNG screenshot from code.

Takes all the same options as `renderHtml`, plus:
- `out` (string) - Output file path (default: auto-generated in current directory)

## Available Themes

Popular themes include: `github-dark`, `github-light`, `dracula`, `monokai`, `nord`, `tokyo-night`, `material-theme`, `one-dark-pro`, and [50+ more](https://shiki.style/themes).

## Examples

### Different Themes

```typescript
// Dark theme
await renderPng(code, {
  lang: 'python',
  theme: 'dracula',
  out: './dracula-screenshot.png'
});

// Light theme
await renderPng(code, {
  lang: 'python',
  theme: 'github-light',
  out: './light-screenshot.png'
});
```

### Custom Styling

```typescript
await renderPng(code, {
  lang: 'rust',
  theme: 'tokyo-night',
  width: 1200,
  padding: '3rem',
  background: '#1a1b26',
  showLineNumbers: false,
  out: './custom-screenshot.png'
});
```

## Links

- [Main Repository](https://github.com/amackera/shotify)
- [CLI Package](https://www.npmjs.com/package/@shotify/cli)
- [Documentation](https://github.com/amackera/shotify#readme)
- [Issues](https://github.com/amackera/shotify/issues)

## License

MIT
