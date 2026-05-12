return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPost", "BufNewFile" },
	version = "v2.*",
	config = function()
		require("gitsigns").setup({
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "jump to next hunk" })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "jump to previous hunk" })

				-- Actions
				map("n", "<leader>gs", gs.stage_hunk, { desc = "stage hunk" })
				map("n", "<leader>gr", gs.reset_hunk, { desc = "reset hunk" })
				map("v", "<leader>gs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "stage hunk" })
				map("v", "<leader>gr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "reset hunk" })
				map("n", "<leader>gS", gs.stage_buffer, { desc = "stage buffer" })
				map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
				map("n", "<leader>gR", gs.reset_buffer, { desc = "reset buffer" })
				map("n", "<leader>gp", gs.preview_hunk, { desc = "preview hunk" })
				map("n", "<leader>gl", function()
					gs.blame_line({ full = true })
				end, { desc = "blame line" })
				map("n", "<leader>gd", gs.diffthis, { desc = "diff this" })
				map("n", "<leader>gD", function()
					gs.diffthis("~")
				end, { desc = "diff this" })

				require("which-key").add({ { "<leader>gq", "which_key_ignore", name = "[Q]uickfix" } })
				map("n", "<leader>gqa", function()
					gs.setqflist("all")
				end, { desc = "add all hunks to quickfix" })
				map("n", "<leader>gqq", function()
					gs.setqflist()
				end, { desc = "add hunks from current buffer to quickfix" })

				require("which-key").add({ { "<leader>gt", "which_key_ignore", name = "[T]oggle" } })
				map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "toggle current line blame" })
				map("n", "<leader>gtd", gs.toggle_deleted, { desc = "toggle deleted" })

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select hunk" })
			end,
		})
	end,
}
