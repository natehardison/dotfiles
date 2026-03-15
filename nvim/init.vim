set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc

" -- treesitter ----------------------------------------------------------------

lua <<EOF
local ok, ts = pcall(require, 'nvim-treesitter.configs')
if ok then
  ts.setup {
    ensure_installed = {
      "bash", "c", "go", "json", "lua", "python",
      "rust", "toml", "vim", "vimdoc", "yaml",
    },
    highlight = { enable = true },
    indent = { enable = true },
  }
end
EOF

" -- coc.nvim ------------------------------------------------------------------

let g:coc_global_extensions = [
  \ '@yaegassy/coc-ansible',
  \ '@yaegassy/coc-ruff',
  \ 'coc-cmake',
  \ 'coc-clangd',
  \ 'coc-git',
  \ 'coc-go',
  \ 'coc-json',
  \ 'coc-pyright',
  \ 'coc-rust-analyzer',
\]

let g:coc_filetype_map = {
  \ 'yaml.ansible': 'ansible',
\}

" needed in zenburn to show completion menu highlights
highlight! link CocPumMenu Pmenu
highlight! link CocMenuSel PmenuSel

" tab/shift-tab to navigate completion menu
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1):
    \ CheckBackspace() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"

" -- gutentags + tagbar --------------------------------------------------------

let g:gutentags_cache_dir = '~/.tags'

nnoremap <leader>g :TagbarToggle f<CR>
nnoremap <C-]> g<C-]>
nnoremap g] g<C-]>
nnoremap ]g :tnext<CR>
nnoremap [g :pop<CR>

" -- chadtree ------------------------------------------------------------------

nnoremap <leader>v <cmd>CHADopen<cr>
