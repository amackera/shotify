# Release Notes - v0.1.2

## 📚 Documentation Release

This patch release focuses on improving documentation and package discoverability on npm.

### What's New

#### 📖 Package Documentation
- **Added comprehensive README for @shotify/core** - Complete API documentation with usage examples for HTML and PNG generation
- **Added comprehensive README for @shotify/cli** - Detailed CLI usage guide with all command-line options and examples

#### 📄 License
- **Added MIT LICENSE file** - Official MIT license now included in repository

### Package Links

- **@shotify/core** - https://www.npmjs.com/package/@shotify/core
- **@shotify/cli** - https://www.npmjs.com/package/@shotify/cli

### Installation

```bash
# Install CLI globally
npm install -g @shotify/cli

# Or use in your project
npm install @shotify/core
```

### Quick Start

```bash
# Take a screenshot of a file
shotify example.ts -o screenshot.png

# With custom theme
shotify app.py --theme dracula --title "My Script"
```

### What's Included

All features from v0.1.1:
- 🎨 **55+ Beautiful Themes** - github-dark, dracula, monokai, tokyo-night, and more
- 💻 **100+ Languages** - JavaScript, Python, Rust, Go, TypeScript, and more
- 🔢 **Line Numbering** - Customizable line numbers with start position
- 📐 **Flexible Styling** - Width, padding, background customization
- 📋 **VS Code Integration** - Screenshot to file or clipboard
- 🖥️ **Emacs Support** - Native Emacs integration
- 🎯 **CLI Tool** - Powerful command-line interface

### Full Changelog

See [CHANGELOG.md](packages/core/CHANGELOG.md) for complete details.

---

**Full Diff**: https://github.com/amackera/shotify/compare/v0.1.1...v0.1.2
