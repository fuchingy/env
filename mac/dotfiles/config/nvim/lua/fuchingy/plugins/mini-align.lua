return {
    "nvim-mini/mini.align",
    config = function()
        local mini_align = require("mini.align")
        mini_align.setup({
            mappings = {
                start = "ga",
                start_with_preview = "gA",
            },
        })
    end,
}
