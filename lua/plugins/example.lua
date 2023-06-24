return {
	{ -- colorscheme
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		init = function()
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},
	{
		"rebelot/heirline.nvim",
    init = function()
			vim.opt.laststatus = 2
    end,
    -- enabled = false,
		-- You can optionally lazy-load heirline on UiEnter
		-- to make sure all required plugins and colorschemes are loaded before setup
		config = function()
			local colors = require("tokyonight.colors").setup()
			local conditions = require("heirline.conditions")
			local utils = require("heirline.utils")
			local ViMode = {
				-- get vim current mode, this information will be required by the provider
				-- and the highlight functions, so we compute it only once per component
				-- evaluation and store it as a component attribute
				init = function(self)
					self.mode = vim.fn.mode(1) -- :h mode()
				end,
				-- Now we define some dictionaries to map the output of mode() to the
				-- corresponding string and color. We can put these into `static` to compute
				-- them at initialisation time.
				static = {
					mode_names = { -- change the strings if you like it vvvvverbose!
						n = "N",
						no = "N?",
						nov = "N?",
						noV = "N?",
						["no\22"] = "N?",
						niI = "Ni",
						niR = "Nr",
						niV = "Nv",
						nt = "Nt",
						v = "V",
						vs = "Vs",
						V = "V_",
						Vs = "Vs",
						["\22"] = "^V",
						["\22s"] = "^V",
						s = "S",
						S = "S_",
						["\19"] = "^S",
						i = "I",
						ic = "Ic",
						ix = "Ix",
						R = "R",
						Rc = "Rc",
						Rx = "Rx",
						Rv = "Rv",
						Rvc = "Rv",
						Rvx = "Rv",
						c = "C",
						cv = "Ex",
						r = "...",
						rm = "M",
						["r?"] = "?",
						["!"] = "!",
						t = "T",
					},
					mode_colors = {
						n = "red",
						i = "green",
						v = "cyan",
						V = "cyan",
						["\22"] = "cyan",
						c = "orange",
						s = "purple",
						S = "purple",
						["\19"] = "purple",
						R = "orange",
						r = "orange",
						["!"] = "red",
						t = "red",
					},
				},
				-- We can now access the value of mode() that, by now, would have been
				-- computed by `init()` and use it to index our strings dictionary.
				-- note how `static` fields become just regular attributes once the
				-- component is instantiated.
				-- To be extra meticulous, we can also add some vim statusline syntax to
				-- control the padding and make sure our string is always at least 2
				-- characters long. Plus a nice Icon.
				provider = function(self)
					return " %2(" .. self.mode_names[self.mode] .. "%)"
				end,
				-- Same goes for the highlight. Now the foreground will change according to the current mode.
				hl = function(self)
					local mode = self.mode:sub(1, 1) -- get only the first mode character
					return { fg = self.mode_colors[mode], bold = true }
				end,
				-- Re-evaluate the component only on ModeChanged event!
				-- Also allows the statusline to be re-evaluated when entering operator-pending mode
				update = {
					"ModeChanged",
					pattern = "*:*",
					callback = vim.schedule_wrap(function()
						vim.cmd("redrawstatus")
					end),
				},
			}
			local WorkDir = {
				init = function(self)
					self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
					local cwd = vim.fn.getcwd(0)
					self.cwd = vim.fn.fnamemodify(cwd, ":~")
				end,
				hl = { fg = "blue", bold = true },

				flexible = 1,

				{
					-- evaluates to the full-lenth path
					provider = function(self)
						local trail = self.cwd:sub(-1) == "/" and "" or "/"
						return self.icon .. self.cwd .. trail .. " "
					end,
				},
				{
					-- evaluates to the shortened path
					provider = function(self)
						local cwd = vim.fn.pathshorten(self.cwd)
						local trail = self.cwd:sub(-1) == "/" and "" or "/"
						return self.icon .. cwd .. trail .. " "
					end,
				},
				{
					-- evaluates to "", hiding the component
					provider = "",
				},
			}
			local Space = { provider = " " }
			local kind = {
				provider = "▊",
				hl = { fg = "blue", bold = true },
			}
			local Align = { provider = "%=" }
			-- vim.opt.showcmdloc = 'statusline'
			local ScrollBar = {
				static = {
					sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
					-- Another variant, because the more choice the better.
					-- sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' }
				},
				provider = function(self)
					local curr_line = vim.api.nvim_win_get_cursor(0)[1]
					local lines = vim.api.nvim_buf_line_count(0)
					local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
					return string.rep(self.sbar[i], 2)
				end,
				hl = { fg = "blue", bg = "black" },
			}
			vim.opt.showcmdloc = "statusline"
			local ShowCmd = {
				condition = function()
					return vim.o.cmdheight == 0
				end,
				provider = ":%3.5(%S%)",
			}
			local statusline = {
				kind,
				Space,
				ViMode,
				Space,
				WorkDir,
				Align,
				Space,
				ShowCmd,
				Space,
				ScrollBar,
				Space,
				kind,
			}
			require("heirline").setup({
				statusline = statusline,
				opts = {
					colors = colors,
				},
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {"lua"},
				highlight = {
					enable = true,
				},
			})
		end,
	},
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      {
        "<leader>nt", mode = "n",
        "<cmd>NvimTreeToggle<cr>",
        desc = "Open File Expolor",
      },
    },
    opts = {},
  },
}
