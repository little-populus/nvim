-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- 定义一个函数来检查窗口是否居中
local function is_centered_float(win_id)
  local config = vim.api.nvim_win_get_config(win_id)
  local screen_width = vim.o.columns
  local screen_height = vim.o.lines
  local win_width = config.width
  local win_height = config.height
  local row = type(config.row) == "table" and config.row[false] or config.row
  local col = type(config.col) == "table" and config.col[false] or config.col

  -- 检查窗口是否居中
  -- return (math.abs(row - (screen_height - win_height) / 2) < 1) and
  return (math.abs(col - (screen_width - win_width) / 2) < 1)
end

-- 定义一个函数来设置浮动窗口的边框和透明度
local function set_floating_window_border_and_transparency()
  local win_id = vim.api.nvim_get_current_win()
  local config = vim.api.nvim_win_get_config(win_id)

  -- 如果当前窗口是浮动窗口且居中
  if config.relative ~= "" and is_centered_float(win_id) then
    -- 获取所有窗口
    local wins = vim.api.nvim_tabpage_list_wins(0)

    -- 移除所有浮动窗口的边框和透明度
    for _, win in ipairs(wins) do
      local win_config = vim.api.nvim_win_get_config(win)
      if win_config.relative ~= "" then
        vim.api.nvim_win_set_config(win, { border = "none" })
        vim.api.nvim_set_option_value("winblend", 70, { scope = "local", win = win }) -- 重置透明度
      end
    end

    -- 为当前窗口添加边框和透明度
    vim.api.nvim_win_set_config(win_id, { border = "double" }) -- 你可以选择 "double", "rounded", "solid", "shadow"
    vim.api.nvim_set_option_value("winblend", 0, { scope = "local", win = win_id }) -- 设置浮动窗口的透明度
  end
end

-- 定义一个函数来处理浮动窗口关闭事件
local function handle_floating_window_close()
  -- 延迟执行以确保窗口关闭事件完成
  vim.defer_fn(function()
    -- 获取所有窗口
    local wins = vim.api.nvim_tabpage_list_wins(0)
    local max_zindex = -1
    local top_win = nil

    -- 找到 zindex 最大的窗口，即最上层的浮动窗口
    for _, win in ipairs(wins) do
      local win_config = vim.api.nvim_win_get_config(win)
      if
        win_config.relative ~= ""
        and is_centered_float(win)
        and win_config.zindex
        and win_config.zindex > max_zindex
      then
        max_zindex = win_config.zindex
        top_win = win
      end
    end

    -- 为最上层的浮动窗口添加边框和透明度
    if top_win and vim.api.nvim_win_is_valid(top_win) then
      vim.api.nvim_win_set_config(top_win, { border = "double" })
      vim.api.nvim_set_option_value("winblend", 0, { scope = "local", win = top_win }) -- 设置浮动窗口的透明度
    end
  end, 10) -- 延迟 10毫秒
end

-- 使用 Neovim 的 Lua API 设置自动命令
vim.api.nvim_create_augroup("FloatingWindowBorder", { clear = true })
vim.api.nvim_create_autocmd("WinNew", {
  group = "FloatingWindowBorder",
  callback = set_floating_window_border_and_transparency,
})
vim.api.nvim_create_autocmd("WinClosed", {
  group = "FloatingWindowBorder",
  callback = handle_floating_window_close,
})
