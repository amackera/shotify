# @shotify/core

## 0.2.0

### Minor Changes

- Add high-DPI rendering support with configurable scale factor. Screenshots now default to 2x resolution for crisp, retina-quality output. New `scale` option allows choosing between 1x (normal), 2x (retina), or 3x (ultra-HD) rendering quality.

## 0.1.2

### Patch Changes

- Added comprehensive README documentation for npm packages
  - Added detailed README.md for @shotify/core with API documentation and examples
  - Added comprehensive README.md for @shotify/cli with usage examples and all CLI options
  - Added MIT LICENSE file to repository

## 0.1.1

### Patch Changes

- Initial release of Shotify with the following features:
  - Added theme name to screenshot filenames (e.g., `screenshot-github-dark-123456.png`)
  - Core screenshot generation with Shiki syntax highlighting
  - Support for 55 bundled themes
  - CLI tool with customizable options (theme, width, padding, etc.)
  - PNG rendering with Puppeteer
  - Automatic language detection
  - Line numbering support
