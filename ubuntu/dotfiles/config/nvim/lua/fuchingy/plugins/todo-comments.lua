return {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local todo_comments = require("todo-comments")
        -- set keymaps
        local keymap = vim.keymap -- for conciseness

        keymap.set("n", "]t", function()
            todo_comments.jump_next()
        end, { desc = "Next todo comment" })

        keymap.set("n", "[t", function()
            todo_comments.jump_prev()
        end, { desc = "Previous todo comment" })
        todo_comments.setup({
            opts = {
                signs = true,
            },
            keywords = {
                FIX = {
                    icon = "🛠️",
                    color = "error",
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
                },
                TODO = { icon = "✓", color = "info" },
                FC   = { icon = "✓", color = "info" }, -- My own keyword
                HACK = { icon = "⚡", color = "warning" },
                WARN = { icon = "⚠️", color = "warning", alt = { "WARNING", "XXX" } },
                PERF = { icon = "🚀", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = "📝", color = "hint", alt = { "INFO" } },
                TEST = { icon = "🧪", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
        })
  end,
}
