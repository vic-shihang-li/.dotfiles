set number
set relativenumber
set noerrorbells
set belloff=all
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set signcolumn=yes
set colorcolumn=80
set noshowmode  " no -- INSERT -- because of a fancier status bar

set wildignore+=*.o

" jsonc syntax highlighting
autocmd FileType json syntax match Comment +\/\/.\+$+

highlight clear SignColumn

highlight ColorColumn ctermbg=233 guibg=lightgrey

" configure status bar
set laststatus=2 " always show file name
highlight StatusLine ctermbg=black ctermfg=250 guibg=darkgrey 
highlight StatusLineNC ctermbg=248 ctermfg=235 guibg=darkgrey 
highlight VertSplit cterm=NONE ctermfg=250

highlight Comment ctermfg=grey

source $HOME/.config/nvim/plugins.vim

lua require('lsp_config')
lua require('nvimtree_config')
lua require('telescope_config')

if executable('rg')
    let g:rg_derive_root='true'
endif

let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '>'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '<'

let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night_Eighties',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

let mapleader=" "

" filetree tweaks
let g:netrw_browse_split=2
let g:netrw_banner=0
let g:netrw_winsize=25

" clang-format settings
let g:clang_format#detect_style_file=1
let g:clang_format#auto_format=1

autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 200)

" ctrl-p config
let g:ctrlp_use_caching=0

" ctrl-w wincmd remaps
nnoremap <leader>h :wincmd h<CR>    
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

" remap for showing undo tree
nnoremap <leader>u :UndotreeShow<CR>

" remap for showing file tree on the left
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

" remap for quickly accessing ripgrep
nnoremap <leader>ps :Rg<SPACE>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Code navigation shortcuts
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> rn    <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <C-n> :NvimTreeToggle<CR>

" Ignore files (for ctrl-p, among other things)
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" C/C++ setup
lua <<EOF
require'lspconfig'.clangd.setup{}
EOF

" Rust setup
lua <<EOF
require('rust-tools').setup({})
EOF

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF

"auto-close config
lua <<EOF
require('nvim-autopairs').setup{}
EOF
