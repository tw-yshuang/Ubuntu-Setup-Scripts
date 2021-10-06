set t_Co=256
syntax enable
set mouse=a

set cursorline
hi CursorLine cterm=none ctermbg=DarkMagenta ctermfg=none
set hlsearch
set ru
set number
set ruler
set showmode
set laststatus=2

set statusline+=%1*\[%n]                                    "buffernr
set statusline+=%2*\ %<%F\                                  "File+path
set statusline+=%3*\ %=\ %{''.(&fenc!=''?&fenc:&enc).''}\   "Encoding
set statusline+=%4*\ %{(&bomb?\",BOM\":\"\")}\              "Encoding2
set statusline+=%5*\ %{&ff}\                                "FileFormat (dos/unix..)
set statusline+=%6*\ row:%l/%L\ col:%03c\ (%03p%%)\         "Rownumber/total (%)
set statusline+=%0*\ \ %m%r%w\ %P\ \                        "Modified? Readonly? Top/bot.

set cindent
set history=100
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
