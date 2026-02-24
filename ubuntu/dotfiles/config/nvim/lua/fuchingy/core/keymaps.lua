vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness
local opts = {
    noremap = true, -- non-recursive
    silent = true,  -- do not show message
}

-----------------
-- Normal mode --
-----------------
-- Remove arrow key to force hjkl adoption
keymap.set("i", "jk", "<ESC>", opts)
keymap.set("n", "<Up>", "<nop>", opts)
keymap.set("n", "<Down>", "<nop>", opts)
keymap.set("n", "<Left>", "<nop>", opts)
keymap.set("n", "<Right>", "<nop>", opts)

-- Switch tab
keymap.set("n", "gt", "<nop>", opts)
keymap.set("n", "gT", "<nop>", opts)
keymap.set("n", "<C-l>", ":tabn<CR>", opts)
keymap.set("n", "<C-h>", ":tabp<CR>", opts)

-- Line number toggle
keymap.set("n", "<F3>", ":set number! number?<CR>", opts)
keymap.set("n", "<F7>", ":set relativenumber! relativenumber?<CR>", opts)

-- Searching highlight toggle
keymap.set("n", "<F4>", ":set hlsearch! hlsearch?<CR>", opts)
-- Search without moving cursor
keymap.set("n", "*", "*N", opts)
-----------------
-- Insert mode --
-----------------
-- Remove arrow key to force hjkl adoption
keymap.set("i", "jk", "<ESC>", opts)
keymap.set("i", "<ESC>", "<nop>", opts)
