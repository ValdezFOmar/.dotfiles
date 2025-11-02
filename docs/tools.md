# Tools

## Code

Command line tools (formatters, linters, etc.):

| Package      | Type              | Source |
|--------------|-------------------|--------|
| `pre-commit` | Git Hooks         | pacman |
| `ruff`       | Formatter/Linter  | pacman |
| `shellcheck` | Linter            | pacman |
| `shfmt`      | Formatter         | pacman |

Language servers for languages used in this repository and commonly used
languages in my projects:

| nvim-lspconfig name     | Package                       | Source |
|-------------------------|-------------------------------|--------|
| `basedpyright`          | basedpyright                  | pipx   |
| `bashls`                | bash-language-server          | pacman |
| `cssls`                 | vscode-langservers-extracted  | aur    |
| `emmet_language_server` | emmet-language-server         | aur    |
| `eslint`                | (same as cssls)               | aur    |
| `html`                  | (same as cssls)               | aur    |
| `jsonls`                | (same as cssls)               | aur    |
| `lua_ls`                | lua-language-server           | pacman |
| `marksman`              | marksman                      | pacman |
| `ruff`                  | ruff                          | pacman |
| `rust_analyzer`         | rustup                        | pacman |
| `texlab`                | texlab                        | pacman |
| `tombi`                 | tombi                         | pacman |
| `ts_ls`                 | typescript-language-server    | pacman |
| `ts_query_ls`           | ts_query_ls-bin               | aur    |

## Fonts and Language

| Package         | Description                   |
|-----------------|-------------------------------|
| `font-manager`  | Simple to use font explorer   |
| `hunspell-en_us`| Spelling for American English |
| `hunspell-es_mx`| Spelling for Mexican Spanish  |
| `hyphen-es`     | Hyphen rules for Spanish      |

## GUI

### Qt theming

Dependencies:

- `kvantum`
- `kvantum-theme-materia`
- `qt5ct`

To configure a theme, follow these instructions:

1. Launch "Qt5 settings" (`qt5ct`)
1. Choose *style > kvantum-dark*.
1. Launch "Kvantum Manager"
1. Go to *Change / Delete Theme > Select a Theme*
1. Choose "MateriaDark".

### Firefox

To make windows from external links open in tabs instead, apply the
changes listed in this [article](https://support.mozilla.org/en-US/questions/1193456).

## CPU Frequency

The Linux utility `cpupower` allows changing the current governor for
the CPU. Usage:

Get available governors:

```sh
cpupower frequency-info --governors
```

Set governor:

```sh
sudo cpupower --cpu all frequency-set --governor {governor}
```
