# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Shotify is a tool for taking beautiful screenshots of code. The project is structured as a monorepo with the following planned architecture:

### Packages
- **core**: Core screenshot generation functionality
- **cli**: Command-line interface

### Adapters
- **vscode**: Visual Studio Code extension
- **zed**: Zed editor integration
- **nvim**: Neovim plugin
- **emacs**: Emacs integration

## Architecture Notes

This is a monorepo structure where:
- All packages will be located in the `packages/` directory
- Each adapter will integrate with its respective editor/IDE to leverage the core package
- The CLI package will provide a standalone command-line interface to the core functionality
