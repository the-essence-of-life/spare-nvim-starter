-- local echo = function(str)
--   vim.cmd "redraw"
--   vim.api.nvim_echo({ { str, "Bold" } }, true, {})
-- end
--
-- if not vim.api.nvim_get_runtime_file("lua/custom/chadrc.lua", false)[1] then
--   local path = vim.fn.stdpath("config") .. "/lua/custom/"
--   local input = "N"
--
--   if next(vim.api.nvim_list_uis()) then
--     input = vim.fn.input("Clone user config or auto config?[N/y]:")
--   end
--
--   -- clone example_config repo
--   if input == "y" then
--     echo("Cloning starter...")
--     vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/the-essence-of-life/space-nvim", path })
--     vim.fn.delete(path .. ".git", "rf")
--   else
--     -- use very minimal chadrc
--     vim.fn.mkdir(path, "p")
--
--     local file = io.open(path .. "chadrc.lua", "w")
--     file:write("---@type ChadrcConfig \n local M = {}\n M.ui = {theme = 'onedark'}\n return M")
--     file:close()
--   end
-- end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
})
