-- partly taken from https://github.com/joshmedeski/dotfiles/blob/main/.config/nvim/lua/config/options.lua
-- Tab Completion

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Leader Key 

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Conceallevel for Obsidian Plugin

vim.opt.conceallevel = 1

-- Completion menu

vim.cmd("set completeopt=menu,menuone,noselect")

-- colors
vim.opt.termguicolors = true
vim.g.syntax = "enable"
vim.o.winblend = 0

-- default position
vim.opt.scrolloff = 8 -- scroll page when cursor is 8 lines from top/bottom
vim.opt.sidescrolloff = 8 -- scroll page when cursor is 8 spaces from left/right

-- open splits in a more natural direction
-- https://vimtricks.com/p/open-splits-more-naturally/
vim.opt.splitright = true
vim.opt.splitbelow = true

-- wrapping
vim.opt.wrap = true
vim.opt.linebreak = true

-- gutter
vim.opt.number = true
vim.opt.relativenumber = true
