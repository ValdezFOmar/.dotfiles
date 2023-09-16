return {
    'Fymyte/rasi.vim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    build = ":TSInstall rasi",
    ft = "rasi",
}
