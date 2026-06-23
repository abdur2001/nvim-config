-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.breakindent = true -- line wraps will be visually indented
vim.o.colorcolumn = "+1"
vim.o.signcolumn = "yes:1"
vim.o.winborder = "rounded"

vim.opt.number = true -- line numbers
vim.opt.relativenumber = true -- relative to current line
vim.opt.mouse = "a" -- enable mouse mode for all vim modes
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)
vim.g.clipboard = "osc52"
vim.opt.undofile = true -- save undo history
vim.opt.ignorecase = true -- ignore case in searches
vim.opt.smartcase = true -- unless \C or one or more capitals in search
vim.opt.updatetime = 250 -- decrease swap file update time
vim.opt.splitright = true -- default split to the right
vim.opt.splitbelow = true -- and below
vim.opt.list = true -- improve visibility for tabs, spaces and nbs
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" } -- customise display
vim.opt.inccommand = "split" -- display substitution live
vim.opt.cursorline = true -- show cursor line
vim.opt.scrolloff = 10 -- minimal lines above and below cursor
vim.opt.confirm = true -- ask for confirmation when closing unsaved buffer

vim.opt.hlsearch = true -- highlight on search

vim.opt.spell = true
vim.opt.spelllang = { "en_gb" }

vim.diagnostic.config({
	virtual_text = true,
})

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- shortcut to clear highlights

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "[L]SP show diagnostic error messages" })
vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "[L]SP open diagnostic [Q]uickfix list" })

-- Keybinds to make split navigation easier.
-- Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

function ipdb_set_trace()
	local row = vim.api.nvim_win_get_cursor(0)[1] -- 1-based
	local line = vim.api.nvim_get_current_line()

	-- capture indentation (leading spaces only)
	local indent = line:match("^(%s*)") or ""

	local new_lines = {
		"",
		"# fmt: off",
		"import ipdb; ipdb.set_trace()",
		"# fmt: on",
		"",
	}

	-- apply same indent to every non-empty line (optional; remove the if to indent blanks too)
	for i, v in ipairs(new_lines) do
		if v ~= "" then
			new_lines[i] = indent .. v
		end
	end

	-- nvim_buf_set_lines uses 0-based indices; insert *below* current line:
	local insert_at = row
	vim.api.nvim_buf_set_lines(0, insert_at, insert_at, true, new_lines)
end

vim.keymap.set("n", "<leader>lp", ipdb_set_trace, { desc = "Insert ipdb set_trace" })

function append_type_ignore()
	local current_row = vim.api.nvim_win_get_cursor(0)[1]
	local current_line = vim.api.nvim_get_current_line()
	vim.api.nvim_buf_set_lines(0, current_row - 1, current_row, true, { current_line .. "  # type: ignore" })
end

vim.keymap.set("n", "<leader>ii", append_type_ignore, { desc = "Insert `  # type: ignore` at the end of the line" })

vim.keymap.set("n", "gs", function()
	vim.cmd("vsplit")

	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if clients and #clients > 0 then
		vim.lsp.buf.definition()
	else
		vim.api.nvim_echo({ { "Failed to find LSP" } }, false, { err = true })
	end
end, { desc = "Vertical split and go to definition" })

local function go_to_definition()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if clients and #clients > 0 then
		vim.lsp.buf.definition()
	else
		vim.notify("Failed to find LSP", vim.log.levels.ERROR)
	end
end

vim.keymap.set("n", "gS", function()
	if #vim.api.nvim_tabpage_list_wins(0) > 1 then
		vim.cmd("on")
	end

	vim.cmd("vsplit")
	go_to_definition()
end, { desc = "only - vertical split and go to definition" })

vim.keymap.set("n", "gz", function()
	local buf = vim.api.nvim_get_current_buf()
	vim.cmd("tabnew")
	vim.api.nvim_set_current_buf(buf)
end, { desc = "Open current buffer in new tab" })

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true, notify = false, frequency = 86400 },

	ui = {
		border = "rounded",
	},
})
