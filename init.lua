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

vim.g.mapleader = " "
vim.g.maplocalleader = ","  -- For vimtex
vim.opt.smartindent = true
vim.opt.relativenumber = true
vim.opt.nu = true
vim.opt.showmode = false
vim.opt.scrolloff = 20
vim.o.shell = "/usr/bin/zsh"
vim.opt.textwidth = 79
vim.opt.conceallevel = 1
vim.o.termguicolors = true

require("lazy").setup("plugins")

function insert_debug_statement()
    -- Get the filetype of the current buffer
    local filetype = vim.bo.filetype

    -- Determine the action based on the filetype
    if filetype == 'python' then
        insert_python_debug()
    elseif filetype == 'rust' then
        insert_rust_debug()
    else
        print("Debug statements not supported for this filetype: " .. filetype)
        return
    end
end

function insert_rust_debug()
    local line = vim.fn.line('.') - 1
    local col = vim.fn.col('.')
    local var_name = vim.fn.expand("<cword>")  -- Gets the word under cursor

    -- Get the current line's text to determine the indentation
    local current_line = vim.api.nvim_buf_get_lines(0, line, line + 1, false)[1]
    local indent = current_line:match("^%s*")  -- Capture leading whitespace

    -- Prepare the debug statement with the same indentation
    local debug_statement = string.format('%sprintln!("DEBUG: {:?}", %s);', indent, var_name)

    -- Insert the debug statement on the next line
    vim.api.nvim_buf_set_lines(0, line + 1, line + 1, false, {debug_statement})
end

function insert_python_debug()
    local line = vim.fn.line('.') - 1
    local current_line = vim.api.nvim_buf_get_lines(0, line, line + 1, false)[1]
    local indent = current_line:match("^%s*")
    local var_name = vim.fn.expand("<cword>")
    local debug_statement = string.format('%sprint(f"DEBUG: {%s}")', indent, var_name)
    vim.api.nvim_buf_set_lines(0, line + 1, line + 1, false, {debug_statement})
end

-- C and C++ adjusments
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.expandtab = true
    end,
})

vim.keymap.set("n", "<leader>dp", insert_debug_statement )
vim.keymap.set("n", "<leader>pf", vim.cmd.Ex)
vim.keymap.set("n", "<leader>o", vim.cmd.MarkdownPreview)

vim.cmd.colorscheme "catppuccin"

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

--
-- -- next greatest remap ever 
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
