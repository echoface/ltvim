return {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
        render_modes = { 'n', 'c', 't', 'i' },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion", "Avante" },
    config = function(_, opts)
        require("render-markdown").setup(opts)
    end,
}
