# Shotify for VS Code

Take beautiful screenshots of your code directly from Visual Studio Code.

## Features

- Screenshot selected code or entire files
- Copy screenshots directly to clipboard
- Syntax highlighting for 100+ languages
- Customizable themes, width, padding, and more
- Automatic line numbering
- Beautiful default styling

## Usage

### Commands

Open the Command Palette (`Cmd+Shift+P` on macOS, `Ctrl+Shift+P` on Windows/Linux) and search for:

- **Shotify: Screenshot Selection** - Take a screenshot of the selected code and save to file
- **Shotify: Screenshot File** - Take a screenshot of the entire active file and save to file
- **Shotify: Screenshot Selection to Clipboard** - Take a screenshot of the selected code and copy to clipboard
- **Shotify: Screenshot File to Clipboard** - Take a screenshot of the entire file and copy to clipboard

### Keyboard Shortcuts

You can add custom keyboard shortcuts by opening the Keyboard Shortcuts editor (`Cmd+K Cmd+S` on macOS, `Ctrl+K Ctrl+S` on Windows/Linux) and searching for "Shotify".

Example keybindings you could add to your `keybindings.json`:

```json
[
  {
    "key": "cmd+shift+s",
    "command": "shotify.screenshotSelection",
    "when": "editorTextFocus && editorHasSelection"
  },
  {
    "key": "cmd+shift+alt+s",
    "command": "shotify.screenshotSelectionToClipboard",
    "when": "editorTextFocus && editorHasSelection"
  }
]
```

## Configuration

Configure Shotify through VS Code settings:

- `shotify.theme` - Color theme for screenshots (default: `"github-dark"`)
- `shotify.width` - Screenshot width in pixels (default: `800`)
- `shotify.showLineNumbers` - Show line numbers (default: `true`)
- `shotify.outputDirectory` - Directory to save screenshots (default: `"~/Screenshots"`)
- `shotify.padding` - Padding around code (default: `"2rem"`)
- `shotify.background` - Background color (default: `"#1e1e1e"`)

### Example Settings

```json
{
  "shotify.theme": "github-dark",
  "shotify.width": 1000,
  "shotify.showLineNumbers": true,
  "shotify.outputDirectory": "~/Desktop/Screenshots",
  "shotify.padding": "3rem",
  "shotify.background": "#0d1117"
}
```

## Clipboard Support

Clipboard functionality is supported on:
- **macOS** - Native support using osascript
- **Windows** - Native support using PowerShell
- **Linux** - Requires `xclip` to be installed: `sudo apt-get install xclip`

## Building from Source

```bash
# Install dependencies
pnpm install

# Build the extension
pnpm run build

# Package the extension
pnpm run package
```

## License

MIT
