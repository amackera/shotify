local config = require('shotify.config')

local M = {}

-- Setup function (delegates to config)
M.setup = config.setup

-- Expand path with ~ to home directory
local function expand_path(path)
  if path:sub(1, 1) == '~' then
    return vim.fn.expand('~') .. path:sub(2)
  end
  return path
end

-- Get the filetype/language for syntax highlighting
local function get_language()
  local ft = vim.bo.filetype
  if ft == '' then
    return 'text'
  end

  -- Map Neovim filetypes to Shiki language identifiers
  local lang_map = {
    javascriptreact = 'jsx',
    typescriptreact = 'tsx',
    sh = 'bash',
    zsh = 'bash',
    cs = 'csharp',
  }

  return lang_map[ft] or ft
end

-- Copy image to clipboard (platform-specific)
local function copy_to_clipboard(image_path)
  local system = vim.loop.os_uname().sysname
  local cmd

  if system == 'Darwin' then
    -- macOS
    cmd = string.format(
      "osascript -e 'set the clipboard to (read (POSIX file \"%s\") as JPEG picture)'",
      image_path
    )
  elseif system == 'Linux' then
    -- Linux (requires xclip)
    cmd = string.format('xclip -selection clipboard -t image/png -i "%s"', image_path)
  elseif system == 'Windows_NT' then
    -- Windows (PowerShell)
    cmd = string.format(
      'powershell -command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.Clipboard]::SetImage([System.Drawing.Image]::FromFile(\'%s\'))"',
      image_path
    )
  else
    vim.notify('Clipboard copy not supported on this platform', vim.log.levels.WARN)
    return false
  end

  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to copy to clipboard: ' .. result, vim.log.levels.ERROR)
    return false
  end

  return true
end

-- Generate screenshot
local function generate_screenshot(opts)
  local code = opts.code
  local start_line = opts.start_line or 1
  local full_file = opts.full_file or false
  local to_clipboard = opts.to_clipboard or false

  -- Get filename for title
  local filename = vim.fn.expand('%:t')
  local title = filename ~= '' and filename or nil

  -- Build CLI command
  local cli_opts = config.options
  local theme = cli_opts.theme or 'github-dark'
  local timestamp = os.date('%Y-%m-%dT%H-%M-%S')
  local output_dir = expand_path(cli_opts.output_directory or '~/Screenshots')
  local output_path

  if to_clipboard then
    -- Use temp directory for clipboard
    output_path = vim.fn.tempname() .. '.png'
  else
    -- Create output directory if it doesn't exist
    vim.fn.mkdir(output_dir, 'p')
    output_path = string.format('%s/shotify-%s-%s.png', output_dir, theme, timestamp)
  end

  -- Build shotify CLI command
  local cmd = {
    cli_opts.cli_path,
    '--lang', get_language(),
    '--theme', theme,
    '--width', tostring(cli_opts.width),
    '--padding', cli_opts.padding,
    '--background', cli_opts.background,
    '--scale', tostring(cli_opts.scale),
    '--start-line', tostring(start_line),
    '--out', output_path,
  }

  if title then
    table.insert(cmd, '--title')
    table.insert(cmd, title)
  end

  if not cli_opts.show_line_numbers then
    table.insert(cmd, '--no-line-numbers')
  end

  -- Write code to temporary file for input
  local temp_file = vim.fn.tempname()
  local file = io.open(temp_file, 'w')
  if not file then
    vim.notify('Failed to create temporary file', vim.log.levels.ERROR)
    return
  end
  file:write(code)
  file:close()

  -- Add input file to command
  table.insert(cmd, temp_file)

  -- Execute command
  vim.notify('Generating screenshot...', vim.log.levels.INFO)
  local result = vim.fn.system(table.concat(cmd, ' '))

  -- Clean up temp file
  os.remove(temp_file)

  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to generate screenshot: ' .. result, vim.log.levels.ERROR)
    return
  end

  if to_clipboard then
    if copy_to_clipboard(output_path) then
      vim.notify('Screenshot copied to clipboard!', vim.log.levels.INFO)
    end
    -- Clean up temp file
    os.remove(output_path)
  else
    vim.notify('Screenshot saved: ' .. output_path, vim.log.levels.INFO)

    -- Ask user what to do with the screenshot
    vim.ui.select(
      { 'Open File', 'Reveal in Finder', 'Cancel' },
      { prompt = 'Screenshot saved!' },
      function(choice)
        if choice == 'Open File' then
          vim.fn.system('open "' .. output_path .. '"')
        elseif choice == 'Reveal in Finder' then
          if vim.loop.os_uname().sysname == 'Darwin' then
            vim.fn.system('open -R "' .. output_path .. '"')
          elseif vim.loop.os_uname().sysname == 'Linux' then
            vim.fn.system('xdg-open "' .. vim.fn.fnamemodify(output_path, ':h') .. '"')
          end
        end
      end
    )
  end
end

-- Screenshot selection
function M.screenshot_selection(to_clipboard)
  local start_line = vim.fn.line('v')
  local end_line = vim.fn.line('.')

  -- Ensure start_line is before end_line
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  -- Get selected lines
  local lines = vim.fn.getline(start_line, end_line)
  local code = table.concat(lines, '\n')

  if code == '' then
    vim.notify('No code selected', vim.log.levels.WARN)
    return
  end

  generate_screenshot({
    code = code,
    start_line = start_line,
    full_file = false,
    to_clipboard = to_clipboard or false,
  })
end

-- Screenshot entire file
function M.screenshot_file(to_clipboard)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local code = table.concat(lines, '\n')

  if code == '' then
    vim.notify('Buffer is empty', vim.log.levels.WARN)
    return
  end

  generate_screenshot({
    code = code,
    start_line = 1,
    full_file = true,
    to_clipboard = to_clipboard or false,
  })
end

return M
