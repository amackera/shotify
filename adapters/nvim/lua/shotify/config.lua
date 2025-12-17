local M = {}

-- Default configuration
M.defaults = {
  -- Path to shotify CLI (defaults to 'shotify' in PATH)
  cli_path = 'shotify',

  -- Theme for syntax highlighting (see Shiki themes)
  theme = 'github-dark',

  -- Screenshot width in pixels
  width = 800,

  -- Show line numbers
  show_line_numbers = true,

  -- Padding around code
  padding = '2rem',

  -- Background color
  background = '#1e1e1e',

  -- Resolution scale factor (1=normal, 2=retina, 3=ultra)
  scale = 2,

  -- Output directory for screenshots
  output_directory = '~/Screenshots',
}

-- User configuration (merged with defaults)
M.options = {}

-- Setup function to configure the plugin
function M.setup(opts)
  M.options = vim.tbl_deep_extend('force', M.defaults, opts or {})
end

-- Initialize with defaults
M.setup()

return M
