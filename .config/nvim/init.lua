if vim.g.neovide then
	vim.g.neovide_scale_factor = 1.0
	vim.g.neovide_floating_shadow = false
	local change_scale_factor = function(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end
	vim.keymap.set("n", "<C-=>", function()
		change_scale_factor(1.05)
	end)
	vim.keymap.set("n", "<C-->", function()
		change_scale_factor(1 / 1.05)
	end)
end

if vim.g.vscode then
	vim.keymap.set({ "n", "v", "x" }, "gc", "<Plug>VSCodeCommentary<CR>")
	vim.keymap.set("n", "gcc", "<Plug>VSCodeCommentaryLine<CR>")
end

require("hover").setup("light")

-- Vim settings {{{

local diagnostic_config = {
	text = {},
	texthl = {},
	linehl = {},
	numhl = {},
}

local signs = {
	[vim.diagnostic.severity.ERROR] = { " ", nil, "DiagnosticError" },
	[vim.diagnostic.severity.WARN] = { " ", nil, "DiagnosticWarn" },
	[vim.diagnostic.severity.HINT] = { " ", nil, "DiagnosticHint" },
	[vim.diagnostic.severity.INFO] = { " ", nil, "DiagnosticInfo" },
}

for key, val in ipairs(signs) do
	diagnostic_config["text"][key] = val[1]
	diagnostic_config["linehl"][key] = val[2]
	diagnostic_config["numhl"][key] = val[3]
end

vim.diagnostic.config({
	signs = diagnostic_config,
	float = {
		source = true,
		border = require("hover").border, --- @diagnostic disable-line
	},
	severity_sort = true,
})

-- use system clipboard
-- vim.api.nvim_set_option("clipboard","unnamedplus")

-- map leader to space
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.guifont = "Iosevka Nerd Font:h9"
vim.opt.linespace = 1
vim.opt.wildmenu = true

-- Set highlight on search
vim.opt.hlsearch = true

-- deal with case sensitivity on search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.hidden = true
vim.opt.ruler = true
vim.opt.confirm = true
vim.opt.visualbell = true

-- -- add manual folding
-- vim.opt.foldmethod     = 'marker'
--
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldenable = false
-- vim.opt.foldlevel = 40

vim.opt.cmdheight = 1
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 2

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.signcolumn = "yes"

vim.opt.cursorline = true

vim.opt.scrolloff = 3

vim.opt.wrap = false
-- vim.opt.timeout = false
-- vim.opt.timeoutlen = 300

vim.opt.backupcopy = "yes"

vim.opt.linebreak = true
-- save undo history
vim.opt.undofile = true

vim.opt.inccommand = "split"
vim.opt.incsearch = true

vim.opt.completeopt = "menu,menuone,noselect,noinsert"

-- fix vim screen geometry on alacritty -e nvim
if os.getenv("TERM") == "alacritty" then
	vim.api.nvim_create_autocmd({ "VimEnter" }, {
		callback = function()
			local pid, WINCH = vim.fn.getpid(), vim.uv.constants.SIGWINCH
			vim.defer_fn(function()
				vim.uv.kill(pid, WINCH)
			end, 10)
		end,
	})
end

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = "*",
  callback = function ()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = "*",
  callback = function ()
    vim.highlight.on_yank({ timeout = 200 })
  end
})

vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "<Leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({ "n", "v" }, "<Leader>Y", '"+y$')
vim.keymap.set({ "n", "v" }, "<Leader>P", '"+p$')

vim.keymap.set({ "n" }, "<ESC>", "<CMD>nohlsearch<CR><ESC>", { silent = true, noremap = true })

vim.keymap.set({ "v" }, "g/", ":'<,'>s///g<Left><left>", { silent = false, noremap = true })
vim.keymap.set({ "n" }, "g/", ':%s///g<Left><left>', { silent = false, noremap = true })

vim.keymap.set({ "t" }, "<C-\\><C-R>", "'<C-\\><C-N>\"'.nr2char(getchar()).'pi'", { expr = true, noremap = true })

vim.api.nvim_create_autocmd('CmdwinEnter', {
  pattern = '[:>]',
  desc = 'If the treesitter vim parser is installed, set the syntax again to get highlighting in the command window',
  group = vim.api.nvim_create_augroup('cmdwin_syntax', {}),
  callback = function ()
    local is_loadable, _ = pcall(vim.treesitter.language.add, 'vim')
    if is_loadable then
      vim.cmd('set syntax=vim')
    end
  end
})

-- vim.kemap.set({ "i", "c" }, "<C-b>", "<Left>", { silent = true, noremap = true })
-- vim.kemap.set({ "i", "c" }, "<C-f>", "<Right>", { silent = true, noremap = true })
-- vim.kemap.set({ "i", "c" }, "<C-a>", "<Home>", { silent = true, noremap = true })
-- vim.kemap.set({ "i", "c" }, "<C-e>", "<End>", { silent = true, noremap = true })
-- vim.kemap.set({ "i", "c" }, "<C-d>", "<Del>", { silent = true, noremap = true })
-- vim.kemap.set({ "i", "c" }, "<C-h>", "<BS>", { silent = true, noremap = true })
-- vim.kemap.set({ "i" }, "<C-k>", "<C-r>=<SID>kill_line()<CR>", { silent = true, noremap = true })
-- vim.kemap.set({ "c" }, "<C-k>", "<C-f>D<C-c><C-c>:<Up>", { silent = true, noremap = true })

if vim.fn.has('mouse') then
  vim.opt.mouse = 'a'
end

-- }}}

vim.cmd([[
filetype plugin indent on

augroup Term
  autocmd!
  autocmd TermClose * ++nested stopinsert | au Term TermEnter <buffer> stopinsert
augroup end

]])

if vim.fn.executable('rg') then
  vim.opt.grepprg = 'rg --vimgrep'
end

function NOT_VSCODE()
	return not vim.g.vscode
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
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

require("lazy").setup("plugins", {
	dev = {
		path = "~/Projects",
		fallback = true,
	},
	defaults = {
		lazy = true,
	},
})

-- vim.api.nvim_create_autocmd({ 'TermRequest' }, {
--   desc = 'Handles OSC 7 dir change requests',
--   pattern = "*",
--   callback = function(ev)
--     vim.notify("received => " .. vim.v.termrequest)
--     if string.sub(vim.v.termrequest, 1, 4) == '\x1b]7;' then
--       -- local dir = string.gsub(vim.v.termrequest, '\x1b]7;file://[^/]*', '')
--       -- if vim.fn.isdirectory(dir) == 0 then
--       --   vim.notify('invalid dir: '..dir)
--       --   return
--       -- end
--       -- vim.api.nvim_buf_set_var(ev.buf, 'osc7_dir', dir)
--       -- vim.cmd.lcd(dir)
--       -- if vim.o.autochdir and vim.api.nvim_get_current_buf() == ev.buf then
--       --   vim.cmd.cd(dir)
--       -- end
--     end
--   end
-- })
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'DirChanged' }, {
--   callback = function(ev)
--     if vim.b.osc7_dir and vim.fn.isdirectory(vim.b.osc7_dir) == 1 then
--       vim.cmd.cd(vim.b.osc7_dir)
--     end
--   end
-- })

-- require("tabline").setup()

-- vim: ts=2 sts=2 sw=2 et
