" ======= Plug 套件設定 ===== "
" 安裝
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" PlugInstall

call plug#begin('~/.vim/plugged')

" 主題配色
Plug 'morhetz/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'ghifarit53/tokyonight-vim'
Plug 'catppuccin/vim'
"Plug 'darcula/vim'

" 狀態列美化
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-fugitive'  "顯示Git Branch

" 自動補全 (須搭配 coc.nvim, 先簡化不裝)
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

" 語法強化 & 樹狀顯示
Plug 'preservim/nerdtree'
Plug 'sheerun/vim-polyglot'

call plug#end()



" ===== Vim基本設定 ===== "

" 顯示行數
set number

" 自動縮排與 smart indent
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set scrolloff=5

" 搜尋時高亮 & 即時搜尋
set hlsearch
set incsearch
set ignorecase
set smartcase

" 語法高亮
syntax on

" 顯示游標所在行
set cursorline

" log不要自動換行
set nowrap

" 顯示括號配對
set showmatch

" 避免Windows換行干擾
set fileformat=unix
set ff=unix

" 背景設定
set background=dark

" 顏色主題
"colorscheme desert
"colorscheme elflord
"colorscheme gruvbox-material
"colorscheme gruvbox
colorscheme tokyonight
"colorscheme darcula/vim

" 啟動Plug中的Git Branch顯示
let g:airline#extensions#branch#endbled=1
