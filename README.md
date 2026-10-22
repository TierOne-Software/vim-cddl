# vim-cddl

Syntax highlighting for **CDDL** (Concise Data Definition Language, [RFC 8610](https://www.rfc-editor.org/rfc/rfc8610)) — the schema language for CBOR and JSON data structures. Works in Vim 8+ and Neovim. No dependencies.

## Features

- Filetype detection for `*.cddl`
- Syntax highlighting for the full RFC 8610 notation:
  - rule definitions (`name = type`, `name =< group`, generics `name<$a> = ...`)
  - map member keys
  - prelude and builtin types (`uint`, `tstr`, `bstr`, `encoded-cbor`, ...)
  - literals (`true`, `false`, `nil`, `undefined`)
  - text strings and byte strings (`h'..'`, `b64'..'`, `b64p'..'`, `b64u'..'`, single or double quotes)
  - numbers (decimal, `0x`, `0b`, `0o`, floats)
  - tags (`#6.1`), sockets/plugs (`$name`, `$$name`)
  - control operators (`.size`, `.cbor`, `.bits`, `.regexp`, ...)
  - all operators and occurrences (`=`, `=<`, `=>`, `//`, `..`, `...`, `:`, `~`, `&`, `*`, `+`, `?`)
- Comments (`; ...`) with `TODO`/`FIXME`/`XXX`/`NOTE` markers highlighted
- `commentstring=; %s` so `gcc` comments in and out correctly

## Installation

**lazy.nvim**

```lua
{ "tierone-software/vim-cddl" }
```

**vim-plug**

```vim
Plug 'tierone-software/vim-cddl'
```

**Native packages (no plugin manager)**

```sh
git clone https://github.com/tierone-software/vim-cddl \
  ~/.local/share/nvim/site/pack/plugins/start/vim-cddl   # nvim
# or ~/.vim/pack/plugins/start/vim-cddl                  # vim
```

## Testing

The test suite asserts the syntax group of every construct in `test/fixture.cddl`:

```sh
nvim --headless --clean -c "set rtp+=$PWD" -c "filetype off" -c "filetype on" \
  test/fixture.cddl -c "edit!" -S test/probe.vim
```

Replace `nvim --headless` with `vim -Es` for Vim. CI runs both.

## License

MIT — see [LICENSE](LICENSE).
