" ========================================
" General vim sanity improvements
" ========================================
"
"
" alias yw to yank the entire word 'yank inner word'
" even if the cursor is halfway inside the word
" FIXME: will not properly repeat when you use a dot (tie into repeat.vim)
nnoremap ,yw yiww

" ,ow = 'overwrite word', replace a word with what's in the yank buffer
" FIXME: will not properly repeat when you use a dot (tie into repeat.vim)
nnoremap ,ow "_diwhp

"make Y consistent with C and D
nnoremap Y y$
function! YRRunAfterMaps()
  nnoremap Y   :<C-U>YRYankCount 'y$'<CR>
endfunction

" Make 0 go to the first character rather than the beginning
" of the line. When we're programming, we're almost always
" interested in working with text rather than empty space. If
" you want the traditional beginning of line, use ^
nnoremap 0 ^
nnoremap ^ 0

" ,# Surround a word with #{ruby interpolation}
map ,# ysiw#
vmap ,# c#{<C-R>"}<ESC>

" ," Surround a word with "quotes"
map ," ysiw"
vmap ," c"<C-R>""<ESC>

" ,' Surround a word with 'single quotes'
map ,' ysiw'
vmap ,' c'<C-R>"'<ESC>

" ,) or ,( Surround a word with (parens)
" The difference is in whether a space is put in
map ,( ysiw(
map ,) ysiw)
vmap ,( c( <C-R>" )<ESC>
vmap ,) c(<C-R>")<ESC>

" ,[ Surround a word with [brackets]
map ,] ysiw]
map ,[ ysiw[
vmap ,[ c[ <C-R>" ]<ESC>
vmap ,] c[<C-R>"]<ESC>

" ,{ Surround a word with {braces}
map ,} ysiw}
map ,{ ysiw{
vmap ,} c{ <C-R>" }<ESC>
vmap ,{ c{<C-R>"}<ESC>

map ,` ysiw`

" gary bernhardt's hashrocket
imap <c-l> <space>=><space>

"Go to last edit location with ,.
nnoremap ,. '.

"When typing a string, your quotes auto complete. Move past the quote
"while still in insert mode by hitting Ctrl-a. Example:
"
" type 'foo<c-a>
"
" the first quote will autoclose so you'll get 'foo' and hitting <c-a> will
" put the cursor right after the quote
imap <C-a> <esc>wa

" ==== NERD tree
" Open the project tree and expose current file in the nerdtree with Ctrl-\
" " calls NERDTreeFind iff NERDTree is active, current window contains a modifiable file, and we're not in vimdiff
function! OpenNerdTree()
  if &modifiable && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
  else
    NERDTreeToggle
  endif
endfunction
nnoremap <silent> <C-\> :call OpenNerdTree()<CR>

" ,q to toggle quickfix window (where you have stuff like Ag)
" ,oq to open it back up (rare)
nmap <silent> ,qc :cclose<CR>
nmap <silent> ,qo :copen<CR>

"Move back and forth through previous and next buffers
"with ,z and ,x
nnoremap <silent> ,z :bp<CR>
nnoremap <silent> ,x :bn<CR>

" ==============================
" Window/Tab/Split Manipulation
" ==============================
" Move between split windows by using the four directions H, L, K, J
" NOTE: This has moved to vim/settings/vim-tmux-navigator.vim.
" nnoremap <silent> <C-h> <C-w>h
" nnoremap <silent> <C-l> <C-w>l
" nnoremap <silent> <C-k> <C-w>k
" nnoremap <silent> <C-j> <C-w>j

" Make gf (go to file) create the file, if not existent
nnoremap <C-w>f :sp +e<cfile><CR>
nnoremap <C-w>gf :tabe<cfile><CR>

" Zoom in
map <silent> ,gz <C-w>o

" Create window splits easier. The default
" way is Ctrl-w,v and Ctrl-w,s. I remap
" this to vv and ss
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

" create <%= foo %> erb tags using Ctrl-k in edit mode
imap <silent> <C-K> <%=   %><Esc>3hi

" create <%= foo %> erb tags using Ctrl-j in edit mode
imap <silent> <C-J> <%  %><Esc>2hi

" ============================
" Shortcuts for everyday tasks
" ============================

" copy current filename into system clipboard - mnemonic: (c)urrent(f)ilename
" this is helpful to paste someone the path you're looking at
nnoremap <silent> ,cf :let @* = expand("%:~")<CR>
nnoremap <silent> ,cr :let @* = expand("%")<CR>
nnoremap <silent> ,cn :let @* = expand("%:t")<CR>

"Clear current search highlight by double tapping //
nmap <silent> // :nohlsearch<CR>

"(v)im (c)ommand - execute current line as a vim command
nmap <silent> ,vc yy:<C-f>p<C-c><CR>

"(v)im (r)eload
nmap <silent> ,vr :so %<CR>

" Type ,hl to toggle highlighting on/off, and show current value.
noremap ,hl :set hlsearch! hlsearch?<CR>

" These are very similar keys. Typing 'a will jump to the line in the current
" file marked with ma. However, `a will jump to the line and column marked
" with ma.  It’s more useful in any case I can imagine, but it’s located way
" off in the corner of the keyboard. The best way to handle this is just to
" swap them: http://items.sjbach.com/319/configuring-vim-right
nnoremap ' `
nnoremap ` '

" ============================
" SplitJoin plugin
" ============================
nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>

" Get the current highlight group. Useful for then remapping the color
map ,hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")<CR>

" ,hp = html preview
map <silent> ,hp :!open -a Safari %<CR><CR>

"paste text in insertion mode
inoremap <C-X><C-V> <esc>"+pa
"paste text in normal mode
nnoremap <C-X><C-V> "+p"

"------------------------------------------------------------------------------
" Misc
"------------------------------------------------------------------------------
" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>
" copy all out of vim
nnoremap <C-X><C-A> <esc>gg"+yG
" copy text in visual mode
vnoremap <C-C> "+yy
" copy all inside vim
nnoremap <C-A> <esc>ggyG
" edit file
nmap <leader>ev :tabedit $MYVIMRC<cr>'tzo
nmap <leader>em :tabedit makefile

" move around compile errors
nnoremap <leader>n :cnext<cr>
nnoremap <leader>p :cprevious<cr>

nnoremap <leader>l :redraw!<cr>
imap <leader>cb 『』
nnoremap <leader>n :cn<cr>
nnoremap <leader>p :cp<cr>

" Fast Saving
map <Leader>w :w<CR>
imap <Leader>w <ESC>:w<CR>
vmap <Leader>w <ESC><ESC>:w<CR>

" :W sudo saves the file
" (useful for handling the permission-denied error)
if !exists(':W')
  command W w !sudo tee % > /dev/null
endif

" Highlight current line - allows you to track cursor position more easily
set cursorline

" map CTRL-L to piece-wise copying of the line above the current one
imap <C-L> @@@<esc>hhkywjl?@@@<CR>P/@@@<cr>3s


" Allow to copy/paste between VIM instances
"copy the current visual selection to ~/.vbuf
vmap <leader>y :w! ~/.vbuf<cr>

"copy the current line to the buffer file if no visual selection
vmap <leader>y :.w! ~/.vbuf<cr>

"paste the contents of the buffer file
nmap <leader>p :r ~/.vbuf<cr>

"------------------------------------------------------------------------------
" Moving around, tabs, windows and buffers
"------------------------------------------------------------------------------
" Switch between the last two files
nnoremap <leader><leader> <C-^>

" easy way to edit reload .vimrc
nmap <leader>V :source $MYVIMRC<cr>
nmap <leader>v :vsp $MYVIMRC<cr>

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

"------------------------------------------------------------------------------
" Spell checking
"------------------------------------------------------------------------------

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" Close the current buffer (w/o closing the current window)
map <leader>bd :bd<cr>

" Close all the buffers
map <leader>bda :1,1000 bd!<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>tj :tabnext
map <leader>tk :tabprevious

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

"------------------------------------------------------------------------------
" Visual mode related
"------------------------------------------------------------------------------

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>


noremap <Up> :echo '戒黄赌毒及上下左右键！'<CR>
noremap <Down> :echo '戒黄赌毒及上下左右键！'<CR>
noremap <Left> :echo '戒黄赌毒及上下左右键！'<CR>
noremap <Right> :echo '戒黄赌毒及上下左右键！'<CR>
inoremap <leader>fn <C-R>=expand("%:t")<CR>


function! TogglePaste()
  if &paste
    setlocal nopaste
  else
    setlocal paste
  endif
endfunction

function! ToggleRspecTest()
  let l:line=getline('.')
  if l:line =~? ',\s*now:\s.*true'
    call setline('.', substitute(l:line, "\,\\s*now:\\s*true", "", ""))
  else
    call setline('.', substitute(l:line, "\\([^\\s]\\)\\s*do", "\\1, now: true do", ""))
  endif
endfunction

" set paste
nnoremap <localleader>tp :call TogglePaste()<cr>
nnoremap ,tt :call ToggleRspecTest()<cr>

vmap <localleader>js :!python -m json.tool<cr>

" nvim-blame-line
nnoremap <silent> <leader>b :ToggleBlameLine<CR>
