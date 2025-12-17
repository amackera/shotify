# Shotify for Neovim

Take beautiful screenshots of your code in Neovim.

## Prerequisites

You must have the Shotify CLI installed and available in your PATH. Install it from the root of the Shotify monorepo:

```bash
cd packages/cli
pnpm install
pnpm build
pnpm link --global
```

Verify the installation:
```bash
shotify --version
```

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  dir = '/path/to/shotify/adapters/nvim',
  name = 'shotify',
  config = function()
    require('shotify').setup({
      -- Configuration options (all optional)
      theme = 'github-dark',           -- Color theme
      width = 800,                     -- Screenshot width in pixels
      show_line_numbers = true,        -- Show line numbers
      padding = '2rem',                -- Padding around code
      background = '#1e1e1e',          -- Background color
      scale = 2,                       -- Resolution scale (1=normal, 2=retina, 3=ultra)
      output_directory = '~/Screenshots', -- Where to save screenshots
      cli_path = 'shotify',            -- Path to shotify CLI
    })
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  '/path/to/shotify/adapters/nvim',
  as = 'shotify',
  config = function()
    require('shotify').setup()
  end
}
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug '/path/to/shotify/adapters/nvim'

lua << EOF
require('shotify').setup()
EOF
```

## Usage

### Commands

The plugin provides four commands:

- `:ShotifySelection` - Screenshot the selected code (visual mode)
- `:ShotifyFile` - Screenshot the entire file
- `:ShotifySelectionToClipboard` - Screenshot selection and copy to clipboard
- `:ShotifyFileToClipboard` - Screenshot entire file and copy to clipboard

### Keybindings

You can add custom keybindings in your config:

```lua
-- Example keybindings
vim.keymap.set('v', '<leader>ss', ':ShotifySelection<CR>', { desc = 'Screenshot selection' })
vim.keymap.set('n', '<leader>sf', ':ShotifyFile<CR>', { desc = 'Screenshot file' })
vim.keymap.set('v', '<leader>sc', ':ShotifySelectionToClipboard<CR>', { desc = 'Screenshot selection to clipboard' })
vim.keymap.set('n', '<leader>sfc', ':ShotifyFileToClipboard<CR>', { desc = 'Screenshot file to clipboard' })
```

## Configuration

All configuration options with their defaults:

```lua
require('shotify').setup({
  -- Path to shotify CLI (defaults to 'shotify' in PATH)
  cli_path = 'shotify',

  -- Theme for syntax highlighting
  -- See https://shiki.style/themes for available themes
  theme = 'github-dark',

  -- Screenshot width in pixels
  width = 800,

  -- Show line numbers
  show_line_numbers = true,

  -- Padding around code (CSS units)
  padding = '2rem',

  -- Background color (hex color)
  background = '#1e1e1e',

  -- Resolution scale factor
  -- 1 = normal DPI
  -- 2 = retina/HiDPI (recommended)
  -- 3 = ultra HD
  scale = 2,

  -- Output directory for screenshots
  output_directory = '~/Screenshots',
})
```

## Platform-specific Notes

### macOS
Clipboard functionality works out of the box using `osascript`.

### Linux
Requires `xclip` for clipboard functionality:
```bash
sudo apt-get install xclip
```

### Windows
Clipboard functionality uses PowerShell (built-in).

## Troubleshooting

### "shotify: command not found"

Make sure the Shotify CLI is installed and in your PATH. You can also specify the full path in your config:

```lua
require('shotify').setup({
  cli_path = '/full/path/to/shotify',
})
```

### Screenshots look blurry

Try increasing the `scale` option:

```lua
require('shotify').setup({
  scale = 3,  -- Ultra HD
})
```

### Language not detected correctly

The plugin uses Neovim's filetype detection. Ensure your file has the correct filetype set:
```vim
:set filetype?
```

## License

See the root LICENSE file in the Shotify monorepo.
