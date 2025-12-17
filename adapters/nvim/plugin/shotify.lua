-- Prevent loading plugin twice
if vim.g.loaded_shotify then
  return
end
vim.g.loaded_shotify = true

-- Create user commands
vim.api.nvim_create_user_command('ShotifySelection', function()
  require('shotify').screenshot_selection(false)
end, { range = true, desc = 'Screenshot selected code' })

vim.api.nvim_create_user_command('ShotifyFile', function()
  require('shotify').screenshot_file(false)
end, { desc = 'Screenshot entire file' })

vim.api.nvim_create_user_command('ShotifySelectionToClipboard', function()
  require('shotify').screenshot_selection(true)
end, { range = true, desc = 'Screenshot selected code to clipboard' })

vim.api.nvim_create_user_command('ShotifyFileToClipboard', function()
  require('shotify').screenshot_file(true)
end, { desc = 'Screenshot entire file to clipboard' })
