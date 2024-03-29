" vim:fdm=marker:sw=2:ts=2:et:fdl=0:fileencoding=utf-8:
"============================
" Author:   Cornelius < cornelius.howl{at}gmail{dot}com >
" Web:      http://c9s.blogspot.com
" Date:     Wed 28 Mar 2007 04:37:26 AM CST
"============================
"   general settings       
set nocompatible  " must be the first line
" behave xterm
syntax on
filetype on
filetype plugin on
filetype indent on

set winaltkeys=no lazyredraw showtabline=2 hlsearch
" set cursorline

set guioptions+=M    " no system menu

highlight WhiteSpaceEOL ctermbg=darkgreen guibg=lightgreen
match WhiteSpaceEOL /\s*\ \s*$/
autocmd WinEnter * match WhiteSpaceEOL /\s*\ \s*$/
"set mouse=a

"behave mswin
set viewdir=~/.vim/view

"   options ================================================= {{{
"set cedit=<C-y>
"nm : q:i
"nm / q/i
"nm ? q?i

"set mps+==:;
"set title titlestring=%<%F%=%l/%L-%P titlelen=70
"set title titlestring=%<%F titlelen=70

fun! s:find_bin(bin)
  let paths = split(expand('$PATH'),':')
  for p in paths 
    if filereadable( p . '/' . a:bin )
      return p . '/' . a:bin
    endif
  endfor
  return 
endf

let mapleader = ","

let shells = [ 'bash' , 'zsh' , 'sh' ]
while ! exists('&shell') && len(shells) > 0
  let sh = remove(shells,0)
  let path = s:find_bin(sh)
  if strlen(path) > 0
    exec 'set shell='.path
  endif
endwhile

"set previewwindow
set previewheight=9
"set winheight=7
"set winminheight=3

" set autowrite
" numbers of colo
" set t_Co=256

" scroll jump && scroll off
set sj=1 so=1

"nnoremap <C-E> <C-E><C-E><C-E><C-E>
"nnoremap <C-Y> <C-Y><C-Y><C-Y><C-Y>

set tags+=~/.tags
set dict+=~/vim_completion
"set thesaurus=
"setlocal spell spelllang=en_US

"If you want to put swap files in a fixed place, put a command resembling the
"following ones in your .vimrc
" set  dir=~/tmp
set noswapfile

"(for MS-DOS and Win32)
"set dir=c:\\tmp   

"set wildmode=full,list
"set wildmode=list:full
set  wildmode=longest,list
set  wildignore+=*.o,*.a,*.so,*.obj,*.exe,*.lib,*.ncb,*.opt,*.plg,.svn,.git
"set  wildignore+=*.png,*.jpg,*.gif,*.svg,*.xpm
" set wildoptions

" statusline format
" set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",bom\":\"\")}]\ %-14.(%l,%c%v%)\ %p

"com! DefaultStatusLine set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",bom\":\"\")}]\ %-14.(%l,%c%v%)\ %p
"com! DefaultStatusLine set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",bom\":\"\")}]\ %-14.(%l,%c%)\ %p



" scrollbind
"set scb

" history
set history=100
set sr sta sc noeb nocp nu et
set wildmenu
set sw=4 ts=4 sts=4

" no error bell,visual bell
" set novb 
set modeline mat=15 maxmem=10096 ignorecase 

" current is no smartcase for command line completion ignorecase
"set smartcase

set ruler is wrap ai si sm bs=indent,eol,start 
set ff=unix
"set wm=6

" encoding
"set fileencodings=utf-8,big5,gbk,sjis,euc-jp,euc-kr,utf-bom,iso8859-1
"set fencs=utf-8,big5,euc-jp,utf-bom,iso8859-1,utf-16le
"set fencs=utf-8,gbk,big5,euc-jp,utf-16le
set fencs=utf-8,gbk,gb2312,big5,euc-jp,ascii,latin1,utf-16le
set fenc=utf-8 
set enc=utf-8 
set tenc=utf-8
" =========================================================== }}}
"   fold options ============================================ {{{
"set  fdt=FoldText()
set vop=folds,cursor
set fdc=2 " fdc: fold column
set fdn=3 " fdn: fold nest max
set fdl=3 " fdl: fold level
" set fml=3 " fml: fold min line
" set fdm=marker
" set fdm=manual
"
" }}}
" my perl fold {{{
fu! GetPerlFold()
  let l = getline(v:lnum)
  if l =~ '^\v(sub\s+.*\{\s*$|template\s|\=\w+\s)'
    retu '>1'
  elsei l =~ '^\v(for|while)>'
    retu '>1'
  elsei l =~ '^\v(\};?|\=cut)'
    retu '<1'
  elseif l =~ '^\s*#.*'
    return 'a1'
  elseif l =~ '^\s*#.*'
    retu 's1'
  el
    retu "="
  en
endf
"}}}
" fold text  {{{
fu! FoldText()
  let line = getline(v:foldstart)
  let cms = &commentstring

  " make pattern
  let cms = substitute( cms , '%s' , '|' , 'g' )
  let cms = substitute( cms , '[*<!>]' , '\\\0' , 'g' ) 
  let cms = '\v(' . cms
  if cms =~ '|$' 
  else 
    let cms .= '|'
  en
  let cms .= '\{\{\{\d=)'

  " for debug
  "let g:test = cms

  " strip commentstring
  if line =~ cms 
    let sub = substitute( line,  cms , '', 'g')
    " strip prefix
  elseif line =~ '^\v(sub|template)\s'
    let sub = substitute( line, '^\v(sub|template)\s''?(\w+)''?.*','\1: \2','')
  elseif line =~ '^\v\=(\w+)\s'
    let sub = substitute( line, '^\v\=(\w+)\s(\w+)','\1: \2','')
  else
    let sub = line
  en

  " strip space
  let sub = substitute( sub,  '^\s*' , '', 'g')
  let sub = substitute( sub,  '\s*$' , '', 'g')

  " count line
  let num = v:foldend - v:foldstart

  " make format line
  let fline = printf( "|%3d|- %s " , v:foldend - v:foldstart ,sub )

  "return fold
  retu v:folddashes . v:folddashes . v:folddashes . fline
endf  
" }}}
"   skeleton ================================================ {{{
" au bufnewfile *.c     0r ~/.vim/skeleton/template.c
" au bufnewfile *.cpp   0r ~/.vim/skeleton/template.cpp
" au bufnewfile *.h     0r ~/.vim/skeleton/template.h
" au bufnewfile *.java  0r ~/.vim/skeleton/template.java
" au bufnewfile *.sh    0r ~/.vim/skeleton/template.sh
" au bufnewfile *.css   0r ~/.vim/skeleton/template.css
" au bufnewfile *.html  0r ~/.vim/skeleton/template.html
" au bufnewfile *.s     0r ~/.vim/skeleton/template.s
" =========================================================== }}}
"   autocommand ============================================= {{{
" make view ( save folds , tabs , cursor position ) 
" au  bufwinleave *.c,*.pm,*.pl,*.t,*.cpp silent mkview
" autocmd  BufWinLeave *.*      silent mkview



fun! s:EnableView()
  augroup UpdateView
      au!
      autocmd! BufWritePost *.*     silent mkview
      autocmd! BufReadPost *.*      silent loadview
  augroup END
endf
com! EnableView     :cal s:EnableView()
com! DisableView    :au! UpdateView
let s:enable_view = 1
if s:enable_view
  cal s:EnableView()
endif
" autocmd  BufWinLeave [a-z]      silent mkview
" autocmd  BufWinEnter [a-z]      silent loadview

" :autocmd BufRead   *    set tw=79 nocin ic infercase fo=2croq
"autocmd  bufread,bufnewfile *.txt   :set textwidth=80
"au bufwritepost ~/.vimrc  source ~/.vimrc
" =========================================================== }}}
" mapping "{{{
" make tab in v mode indent code"{{{
nm <tab>   v>
nm <s-tab> v<
xmap <tab>   >gv
xmap <s-tab> <gv
"}}}
" quick w and q"{{{
nnoremap ,w  :w<CR>
nnoremap ,q  :q<CR>
"}}}

nm ,F  :tabedit 

" paste mass text
set  pastetoggle=<F1>

" highlight search toggle
nm <silent> <C-h> :set hlsearch!<CR>

" time stamp
im      <F2>    <c-r>=strftime("%c")<CR>

" window resize mapping "{{{
nm   <a-x> <c-w><c-w><c-w>_
nm   <a-=> <c-w>=
nn   <c-w>9  8<c-w>+
nn   <c-w>0  8<c-w>-
"}}}

" Bash-like command mapping ================================= "{{{
cm      <c-a>   <home>
cm      <c-e>   <end>
cno  <c-b>      <left>
cno  <c-d>      <del>

" preserve for 
" cno  <c-f>      <right>
cno  <c-n>      <down>
cno  <c-p>      <up>

cno  <esc><c-b> <s-left>
cno  <esc><c-f> <s-right>
"}}}
" wrapper"{{{
nnoremap _{   bi{<ESC>ea}<ESC>
nnoremap _(   bi(<ESC>ea)<ESC>
nnoremap _'   bi'<ESC>ea'<ESC>
nnoremap _"   bi"<ESC>ea"<ESC>
"}}}
" change assign"{{{
nm  cr= ^f=cf;
nm  cl= ^f=c^
"}}}
" change ( sp1 , sp2 , var3 , spl )
"nmc  s
nm  gp1 0f(lvf,h
nm  gp2 0f(f,lvf,h
nm  gp3 0f(f,;lvf,h
nm  gp0 0f(lvi(
nm  gpl 0f)hvf,l


"nm     <f2>    :w<cr>
"nm     <f3>    :q<cr>
nm      <f4>    ggvg"+y''
"nm      dt  f<vf>f>d
"nm      <c-k>mx :!chmod u+x %<cr>
"nm      <c-k>sh :sh<cr>
"nm      <c-k>mf [{v]}zf
"nm      <c-k>mh :tohtml<cr>:w %:r.html<cr>:q<cr>
nm      =b      {=}''

fun! MakeExecutable(file)
  cal system("chmod +x " . a:file)
  exec 'edit! ' . a:file
endf
com! -nargs=0 MakeExecutableCurrent :cal MakeExecutable( expand('%') )
com! -nargs=1 MakeExecutable   :cal MakeExecutable( <args> )

" insert perl interpolation
im  <c-v>@    @{[  ]}<esc>2hi
im  <c-v>"    ""<esc>i
im  <c-v>'    ''<esc>i
im  <c-v>{    {  }<esc>hi

" XXX: hate
"nn     ; :
" maybe this

nn      q;  q:i
nn      q/  q/i
"}}}


" commands
" grep pattern in this file
" com! -nargs=* VG   :vimgrep <args> % 
com! RC :tabedit $MYVIMRC
com! Reload :source $MYVIMRC
com! -complete=file -nargs=* G :grep <args>
" convert <arrow  {{{
com! -range -nargs=0 ConvertArrow  :cal s:ConvertArrow(<line1>,<line2>)
cabbr carrow ConvertArrow
fu! s:ConvertArrow(s,e)
  silent! exec a:s . ',' . a:e . 's/</\&lt;/g'
  silent! exec a:s . ',' . a:e . 's/>/\&gt;/g'
endf  
" }}}
"   buffer sel by pattern {{{
fu! BufSel(pattern)
  let buf_count = bufnr("$")
  let cur_bufnr = 1
  let nummatches = 0
  let firstmatchingbufnr = 0
  while cur_bufnr <= buf_count
    if(bufexists(cur_bufnr))
      let currbufname = bufname(cur_bufnr)
      if(match(currbufname, a:pattern) > -1)
        echo cur_bufnr . ": ". bufname(cur_bufnr)
        let nummatches += 1
        let firstmatchingbufnr = cur_bufnr
      endif
    endif
    let cur_bufnr = cur_bufnr + 1
  endwhile
  if(nummatches == 1)
    execute ":buffer ". firstmatchingbufnr
  elseif(nummatches > 1)
    let desiredbufnr = input("Enter buffer number: ")
    if(strlen(desiredbufnr) != 0)
      execute ":buffer ". desiredbufnr
    endif
  else
    echo "No matching buffers"
  endif
endf

fu! BufSelInput()
  let pattern = input( "pattern: " )
  call BufSel( pattern )
endf

"Bind the BufSel() function to a user-command
com! -nargs=1 Bs    :call BufSel("<args>")
nm <leader>bf      :call BufSelInput()<CR>
"}}}

"   blogger template"{{{
" ctrl-f5
fu! GetColorCode()
  let name = input( "name:" )
  let desp = input( "description:" )
  "let line = getline(".")
  sil! exec 'silent! s/\(#[0-9a-f]\{3,6\}\)\(.\{-}$\)/$'.name.' \2\r' 
        \ . '<variable name="'.name.'" '
        \ . 'description="'.desp.'" \r\t\t' 
        \ . 'type="color" default="\1" value="\1">\r'
        \ . '/'
  sil exec "normal vkkx"
  sil exec "/\\v<b:skin><![cdata["
  sil exec "normal p"
endf   
" nm   <c-f5> :cal Getcolorcode()<cr>

fu! GetBtFold() " blogger template fold
  if getline(v:lnum) =~ '\v\<(b:widget|b:includable|b:section|b:skin).{-}(\/)@<!\>'
    retu 'a1'
  elsei getline(v:lnum) =~ '\v\<\/(b:widget|b:includable|b:section|b:skin)\>'
    retu 's1'
  el
    retu "="
  en
endf
setlocal foldexpr=GetBtFold()
"}}}
"                                                                                             

" Space commands {{{ all space command : expand tab to space.
com! -nargs=0 AllSpace :setlocal et | retab!
cabbr allspace AllSpace
" }}}
" Trim Space {{{
com! -range TrimSpace  :setlocal nohls | :silent <line1>,<line2>s!\s*$!!g
cabbr trimspace TrimSpace
" }}}
" Find file  "{{{
fu! Find(name)
  let l:list=system("find . -name '".a:name."' | perl -ne 'print \"$.\\t$_\"'")
  let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
  if l:num < 1
    echo "'".a:name."' not found"
    return
  endif
  if l:num != 1
    echo l:list
    let l:input=input("Which ? (CR=nothing)\n")
    if strlen(l:input)==0
      return
    endif
    if strlen(substitute(l:input, "[0-9]", "", "g"))>0
      echo "Not a number"
      return
    endif
    if l:input<1 || l:input>l:num
      echo "Out of range"
      return
    endif
    let l:line=matchstr("\n".l:list, "\n".l:input."\t[^\n]*")
  else
    let l:line=l:list
  endif
  let l:line=substitute(l:line, "^[^\t]*\t./", "", "")
  execute ":e ".l:line
endf
com! -nargs=1 Find :call Find("<args>")
"}}}
"   VimGrep  {{{
"   XXX: deprecated? orz
fun! Vimgrep()
  cal inputsave()
  let g:mypattern = input("pattern(vimgrep):")
  if strlen( g:mypattern ) == 0 
    " do nothing
  else
    exec ':vimgrep "' . g:mypattern . '"  *  ' 
  en
  cal inputrestore()
endf  
"nnoremap   .gr :vimgrep  *<left><left>
nn      ,gr :cal Vimgrep()<cr>
" }}}
" QuickFix window toggle"{{{
com! -bang -nargs=? QFix cal QFixToggle(<bang>0)
fu! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  en
endf   
nn  <silent>     <leader>q :QFix<cr>
""}}}
" Gist plugin cabbr {{{
cabbr gist Gist
" }}}

" ==== FILE SPECIFIED OPTIONS ===============================
fun! s:setup_exec_cmd()
  let cmd = input("cmd:",'','file')
  return cmd
endf

fun! s:run_exe()
  if ! exists('g:exec_cmd')
    let g:exec_cmd = s:setup_exec_cmd()
  endif
  echo "Executing.."
  exec '! clear && '  . g:exec_cmd
  echo "Done"
endf

fun! s:init_c()
  let c_comment_strings=1

  set path+=/usr/local/include/js/
  set path+=/opt/local/include/cairo/
  set path+=/opt/local/include/glib-2.0/

  com! RunExe      :cal s:run_exe()
  nmap <C-c><C-c>  :make<CR>
  nmap <C-c><C-x>  :RunExe<CR>

  setlocal cindent
  setlocal fdm=syntax
  ab #d #define
  ab #i #include
  setlocal equalprg=indent
endf  

fu! s:init_cpp()
  let c_comment_strings=1
  set ep=indent
  nm <F7>  :make<CR>
  "au bufread,bufnewfile *.cpp  nm <c-f7> :!g++ -wall % -o %:r.out<cr>
  "au bufread,bufnewfile *.cpp  :set makeprg=g++\ -wall\ %\ -o\ %:r.out
endf  


"                                                                                             }}}
"   html code                                                                                 

let html_use_css = 1
fun! s:init_html()
  nm  <F7>  :!firefox %<CR>
endf

" Filetype Rc Autocmd {{{
augroup FiletypeRC
  au!
  au Filetype c              :cal s:init_c()
  au Filetype cpp            :cal s:init_cpp()
  au Filetype css            :cal s:init_css()
  au Filetype html           :cal s:init_html()
  au Filetype javascript     :cal s:js_rc()
  au Filetype mason          :cal s:js_rc()
  au Filetype perl           :cal s:perl_rc()
  au Filetype xul            :0r ~/.vim/skeleton/template.xul
  au filetype haskell        :cal HASKELL_RC()
  au filetype vim            :cal s:init_vim()
augroup END
"}}}


" vim script helpers ======================================== 
" bind load key for vim script file  
fun! s:init_vim()
  com! SearchCamelCaseFunctions /\<\([A-Z][a-z]*\)*(.*)
  com! TranslateNamingStyle     :cal s:TranslateNamingStyle()
  setlocal sw=2
  nmap <buffer><silent> <F6> :so %<CR>
  nmap <buffer><silent> ,s   :so %<CR>
  " select vim function
  nmap sf  ?^fu\%[nction]!?\s\+<CR>V/^endf\%[unction]<CR>
endf

" XXX translate naming style {{{
fun! s:TranslateNamingStyle()
  let word = expand('<cword>')
  normal ciw
  put=word
endf
" }}}

" perl template
" au BufNewFile *.pl  :0r ~/.vim/skeleton/template.pl
" au BufNewFile *.pm  :0r ~/.vim/skeleton/template.pm
" au BufNewFile *.tt  :0r ~/.vim/skeleton/template.tt

cabbr iamperl IamPerl
com! IamPerl :call s:i_am_perl()

fu! s:i_am_perl()
	setf perl
  cal s:perl_rc()
endf

fun! s:perl_test_growl(file)
  redraw
  echo "Test Running..."
  cal system( 'perl -Ilib ' . a:file . ' 2>&1 | growlnotify -t Perl &' )
endf
com! PerlTestThis :cal s:perl_test_growl( expand('%') )

fun! s:perl_rc()
  "check perl code with :make
  set makeprg=perl\ -c\ %\ $*
  set errorformat=%f:%l:%m

  "iabbr w warn
  "iabbr p print
  "iabbr end __END__
  iabbr pkg __PACKAGE__
  "iabbr $s_  $self
  "iabbr $c_  $class

  iabbr _perl #!/usr/bin/env perl
  iabbr _s    $self->
  iabbr _pkg  package
  " set tt2 as html
  "au BufRead,BufNewFile *.tt2  :setfiletype html

  " syntax tuning.
  let perl_include_pod             = 1
  let perl_extended_vars           = 1
  let perl_want_scope_in_variables = 1
  let perl_fold                     = 1
  let perl_fold_blocks              = 1
  let perl_include_pod = 1

  " jifty syntax
  let jifty_fold_schema             = 1
  let jifty_fold_schema_column      = 1
  let jifty_fold_template           = 1
  let jifty_fold_tags               = 1
  let jifty_fold_dispatcher         = 1

  " run perl code
  " nmap <C-c><C-c>  :!perl %<CR>
  " syntax check
  " nmap <C-c><C-y>  :!perl -c %<CR>

  nmap <buffer> <silent> <C-c><C-c>  :make<CR>
  nnoremap <silent><buffer> [[ m':call search('^\s*sub\>', "bW")<CR>
  vnoremap <silent><buffer> [[ m':<C-U>exe "normal! gv"<Bar>call search('^\s*sub\>', "bW")<CR>
  nnoremap <silent><buffer> ]] m':call search('^\s*sub\>', "W")<CR>
  vnoremap <silent><buffer> ]] m':<C-U>exe "normal! gv"<Bar>call search('^\s*sub\>', "W")<CR>

  " Data::Dumper Helper
  nmap <buffer> <leader>dd  Iuse<Space>Data::Dumper;warn<Space>Dumper(<ESC>A);<ESC>

  setlocal equalprg=perltidy
  setlocal fdm=syntax

  "set  fdm=manual
  " indentexpr , indent-expression , XXX read from <cWORD>
  "set fde=GetPerlFold()

endf  

fun! s:perl_test_rc()
  " nmap <silent> <C-c><C-c>   :!clear && perl -Ilib %<CR>
  nmap <buffer> <silent> <C-c><C-c>   :PerlTestThis<CR>
endf

autocmd BufReadPost *.t :cal s:perl_test_rc()

" mason filetype
autocmd BufReadPost,BufNew *.mt  :setfiletype mason

" quick visual select
imap <C-v><C-v>  <ESC>v

fun! s:js_rc()
  abbr func function
  setlocal sw=4
  setlocal  equalprg=/Users/c9s/bin/js_beautifier

  map <buffer> <leader>jj :JSLint<CR>
  cabbr jsl JSLint

  vmap +c    <ESC>`<ko/*<ESC>`>o*/<ESC>''

  " inoremap {   {<Space>}<Left><Left>
  " inoremap [   [<Space>]<Left><Left>
  " inoremap (   (<Space>)<Left><Left>
  " inoremap $   $(<Space>)<Left><Left>
endf

"                                                                                             
"=============================================================
"     PLUGIN SETTING
"=============================================================
"   ctags for windows                                                                         
if has("win32")
  let Tlist_ctags_cmd = $vimruntime . '/ctags/ctags.exe'
endif

" taglist {{{
let tlist_compact_format=1
let tlist_display_prototype=1
nm      <leader>t :TlistToggle<cr>
" }}}

"   nerd tree explorer"{{{
nm <silent> <leader>e :NERDTreeToggle<CR>
cabbr ntf  NERDTreeFind
cabbr ntm  NERDTreeMirror
"}}}
"   mru recent file list {{{
let MRU_Auto_Close = 0 
let MRU_Use_Current_Window = 1 
let MRU_Max_Entries = 20 
"}}}
" 
" Mac Custom tabpage key for mac and other platform {{{
" window size key for macbook
if ( has('gui_mac') || has('gui_macvim') ) && has('gui_running')
    nmap <silent>  <D-->   :resize -5<CR>
    nmap <silent>  <D-=>   :resize +5<CR>
    nmap <silent>  <D-]>   :vertical resize +5<CR>
    nmap <silent>  <D-[>   :vertical resize -5<CR>

    nmap <silent>  <D-\>   <C-w><C-w>
    "  nmap <c-x>tf  :tabfind  
    "  nmap <c-x>th  :tab help<CR>
    nmap <D-s>       :w<CR>
elseif has('gui_macvim') 



endif
" }}}
" nmap    <C-t><C-e>  :tabedit  
" nmap    <C-t><C-f>  :tabfind  
nm      <c-n>   gt
nm      <c-p>   gT

" CPAN ChangeLogs  {{{
map <buffer> ,w /p5-([^/]+)/<CR> "vyaW
nm <F12> ,w /^Changes:<CR> Ahttp://search.cpan.org/dist/<C-R>v<ESC> :1<CR> :/dist/[^/]+/p5<CR> :. s,dist/[^/]+/p5-,dist/,<CR> :. s,Makefile,Changes,<CR>
" }}}
" Scrollbind  {{{
fun! BindScroll()
  set scrollbind
  wincmd w
  set scrollbind
  syncbind
endf
com! BindScroll :cal BindScroll()
nnoremap <C-x><C-b>  :BindScroll
"  }}}
nm      <M-n>   :m .+1<cr>
nm      <M-p>   :m .-2<cr>

" 


if has('gui_running')
    "hi CursorLine gui=underline guibg=NONE 
    set nocursorline
    " Show popup menu if right click.
    set mousemodel=popup

    " Don't focus the window when the mouse pointer is moved.
    set nomousefocus
    " Hide mouse pointer on insert mode.
    set mousehide
endif
" Terminal HighLight Config  {{{
if ! has('gui_running') 
  if &term == 'xterm-color'
    set t_Co=16
  elseif &term == 'xterm-color256'
    set t_Co=256
  endif
  "hi WildMenu ctermbg=Red ctermfg=
  hi Pmenu      ctermfg=black ctermbg=cyan
  hi PmenuSel   ctermfg=black ctermbg=red
  hi PmenuSbar  ctermbg=black ctermfg=cyan
  "hi ModeMsg ctermbg=green ctermfg=black
  hi ModeMsg    ctermbg=magenta ctermfg=black

  hi Comment    ctermfg=gray ctermbg=darkblue
  " hi Comment    ctermbg=darkgreen ctermfg=black

  hi IncSearch ctermfg=black ctermbg=darkred
  hi Search    ctermfg=black ctermbg=darkgreen

  hi LineNr     ctermbg=black ctermfg=green
  hi Folded     ctermbg=darkgreen ctermfg=black
  " hi FoldColumn ctermbg=black ctermfg=green
  hi FoldColumn ctermbg=black ctermfg=darkblue

  hi TabLineFill ctermfg=black 
  hi TabLine     ctermfg=darkgreen ctermbg=black
  hi TabLineSel  ctermbg=darkgreen ctermfg=black
  hi Cursor      ctermbg=darkgreen
  hi VertSplit   ctermbg=black ctermfg=black

  hi StatusLine ctermfg=darkgreen
  hi StatusLineNC ctermfg=black ctermbg=darkgreen
  hi Visual ctermbg=green ctermfg=black
  hi NonText ctermfg=darkgreen
  " hi Normal      ctermfg=blue

  hi Directory ctermfg=yellow
  " Gui HighLigth Config
else
  hi CursorLine guibg=#111111
endif
" }}}
" SVK plugin 

au BufNewFile,BufRead svk-commit*.tmp   setf svk

" Find Sub 
" command! FindSub :call Find_Sub()
fu! Find_Sub(pattern)
  "XXX: can not use
  "exec ":!grep -rP -o '(?<=sub )\s*\w+' " + expand('%')
endf

com! Sublist :!grep -rP -o '(?<=sub )\s*\w+' %
" 
" SQL Helpers "{{{
com! -range SQLF :'<,'>!/Users/c9s/bin/sql-beautify.pl

" "}}}
" CSS Comment Helpers "{{{
fun! s:init_css()
  "imap <buffer> <C-c>c /*   */<ESC>hhhi
  "imap <buffer> <C-c>l /***********************/<CR>
  "imap <buffer> <C-c>[ /*<CR>
  imap <buffer> <C-c>] <CR>*/<CR>
  vmap <buffer> +c <Esc>`<i/* <Esc>`>a */<Esc>
  vmap <buffer> -c <Esc>`<xxx<Esc>`>axxx<Esc>
endf

" "}}}
" dbext "{{{

let g:dbext_default_profile_p9x9 = 'type=PGSQL:user=c9s:passwd=:host=localhost:port=5432:dbname=p9x9'
let g:dbext_default_profile_aiink = 'type=PGSQL:user=c9s:passwd=:host=localhost:port=5432:dbname=aiink_rc'
let g:dbext_default_profile = 'p9x9'

" "}}}
" Cscope Plugin ==========================="{{{
if has("cscope")
  set csprg=/usr/local/bin/cscope
  set csto=0
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
    " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  set csverb
endif
""}}}
" Option Mode =============================                              

fun! ToggleFoldColumn()
  if &fdc == 0 
    exec 'set fdc=' . g:default_fdc
  else
    let g:default_fdc = &fdc
    set fdc=0
  endif
endf

fun! OptionValue(opt)
  let v = input(a:opt . ':','')
  exec 'set ' . a:opt . '=' . v
endf

fun! OptionToggle(opt)
  exec 'set ' . a:opt . '!'
  redraw
  exec printf('echo "option (%s):" . &%s',a:opt,a:opt)
endf

fun! s:optionmode_toggle()
  redraw
  if g:optionmode 
    silent mapclear <buffer> 
    echohl WarningMsg | "Option Mode Off" | echohl None
  else
    nmap <silent> <buffer> <c-f>  :cal ToggleFoldColumn()<CR>
    nmap <silent> <buffer> <c-p>  :cal OptionToggle('paste')<CR>
    nmap <silent> <buffer> <c-s>  :cal OptionToggle('smartcase')<CR>
    nmap <silent> <buffer> <c-l>  :cal OptionToggle('number')<CR>
    echohl WarningMsg | "Option Mode On" | echohl None
  endif
  let g:optionmode = g:optionmode ? 0 : 1
endf

let g:optionmode = 0
com! OptionModeToggle  :cal s:optionmode_toggle()
nm <silent> <leader>k  :OptionModeToggle<CR>

fun! s:VimComplete(findstart, base)
  if a:findstart
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\a'
      let start -= 1
    endwhile
    return start
  else
    let b:lcontext = getline('.')

    if b:lcontext =~ '^\s*com'

    elseif b:lcontext =~ '^\s*fun'

    elseif b:lcontext =~ '^\s*let'

    elseif b:autocmd  =~ '^\s*auto'

    else  " statement completion

    endif
    return res
  endif
endfun
" set completefunc=VimComplete


" vmap = :retab!<CR>
" au bufnewfile *.xul :0r ~/.vim/skeleton/template.xul

autocmd BufRead *.json :setf javascript
" open tag in new tab
nm g+ yiw:tab tag <C-R>"<CR>

" Fold Help "{{{
" display a block only (fold other) ( just use zx )
" zE: erase all folds
" `< : jump to the start of a visual block
" `> : jump to the end of a visual block
" ma : bookmark the position into register a
" mb : bookmark the position into register b
" k : upper
" V : enter visual line mode
" gg : go to the top of a file
" zf : make fold"}}}

" Pod Helpers 
"
" Pod outline helper
"   just read template from file
fu! PodHelperOutline()
  let lines = readfile( expand("~/template.pod") )
  :call append( 0 , lines )
endf


" 


" XXX: fix me ( if condition )
" something if $ok ;
" something if $ok;
" something if($ok) ;
" something if ($ok) ;
" something if ( $ok );
" fu! PerlPostIF()
"   let line = getline(".")
"   echo line
"   if line =~ '\sif\s*(.\{-})\s*;'     " for post-condition that has parenthesis
"     call feedkeys("^/if<CR>e<ESC>f;xa<Space>{<ESC>^/if<CR>d$kpj>>o}<ESC>")
"   elseif line =~ '\sif\s\+.\{-}\s*;'   " for non-parenthesis post-condition
"     call feedkeys("^/if<CR>ea<Space>(<ESC>f;xa<Space>)<Space>{<ESC>^/if<CR>d$kpj>>o}<ESC>")
"   else
"     echo "none"
"   endif
" endf
" nmap <C-x><C-t> ^/if<CR>ea<Space>(<ESC>f;xa<Space>)<Space>{<ESC>^/if<CR>d$kpj>>o}<ESC>
" nmap <C-x><C-t> :call PerlPostIF()<CR>

com! -range Morse :'<,'>!/Users/c9s/bin/morse-encode.pl
com! -range Entities :'<,'>!/Users/c9s/bin/html-entities.pl

fun! EvalVimScriptRegion(s,e)
  let lines = getline(a:s,a:e)
  let file = tempname()
  cal writefile(lines,file)
  redir @e
  silent exec ':source '.file
  cal delete(file)
  redraw
  redir END
  echo "Region evaluated."

  if strlen(getreg('e')) > 0
    10new
    redraw
    silent file "EvalResult"
    setlocal noswapfile  buftype=nofile bufhidden=wipe
    setlocal nobuflisted nowrap cursorline nonumber fdc=0
    " syntax init
    set filetype="eval"
    syn match ErrorLine +^E\d\+:.*$+
    hi link ErrorLine Error
    silent $put =@e
  endif
endf
augroup VimEval
  au!
  au filetype vim :command! -range Eval  :cal EvalVimScriptRegion(<line1>,<line2>)
  au filetype vim :vnoremap <silent> e   :Eval<CR>
augroup END

fun! RenameFromSearchConfirm()
  let s = getreg('/')
  let sub = input("replace:")
  if strlen(sub) == 0 
    return 
  endif
  exec '%s!' . s . '!' . sub . '!gc'
endf
fun! RenameFromSearch()
  let s = getreg('/')
  let sub = input("replace '".s."':")
  if strlen(sub) == 0 
    return 
  endif
  exec '%s!' . s . '!' . sub . '!g'
endf


fun! s:rename_all()
  let s = expand('<cword>')
  let sub = input("replace '".s."':")
  if strlen(sub) == 0 
    return 
  endif
  exec ':bufdo :%s!\<' . s . '\>!' . sub . '!g'
endf

fun! RenameWord(w)
  let s = expand('<cword>')
  exec ':%s!\<' . s . '\>!' . a:w . '!g'
endf

fun! RenameRange(s,e)
  let from = input("replace:")
  let sub = input("replace '\\<".a:ndl."\\>':")
  if strlen(sub) == 0 
    return 
  endif
  exec printf('%d,%ds/\<%s\>/%s/gc',a:s,a:e,from,sub)
endf
com! -narg=1 -range RN     :cal RenameRange(<line1>,<line2>)
com! -narg=1        RNword :cal RenameWord(<q-args>)

com! RenameAll :cal s:rename_all()
com! RenameFromSearch :cal RenameFromSearch()
com! RenameFromSearchConfirm    :cal RenameFromSearchConfirm()


" =========================================================== 

" delete all unlisted buffer but left current one 
fun! BufferClear()
  let curbuffer = bufnr('%')
  let lastbuffernr = last_buffer_nr()
  let nr = 0
  let deleted = 0
  while nr <= lastbuffernr
    if nr == curbuffer
      let nr = nr + 1
      continue
    endif
    if bufexists( nr ) && ! buflisted( nr )
      exec nr . 'bw'
      let deleted = deleted + 1
    endif
    let nr = nr + 1
  endwhile
  redraw
  ls!
  echo deleted . " buffer deleted!"
endf
com! BufferClear :call BufferClear()


" fold vim syntax
let g:vimsyn_folding = 'afp'

augroup AutoPreviewWord
  au!
  "au CursorHold      *.[ch],*.p[ml]  nested call PreviewWord()
augroup END

fun! PreviewWord()
  if &previewwindow      " don't do this in the preview window
    return
  endif
  let w = expand("<cword>")    " get the word under cursor
  if w =~ '\a'     " if the word contains a letter

    " Delete any existing highlight before showing another tag
    silent! wincmd P     " jump to preview window
    if &previewwindow      " if we really get there...
      match none     " delete existing highlight
      wincmd p     " back to old window
    endif

    " Try displaying a matching tag for the word under the cursor
    try
      exe "ptag " . w
    catch
      return
    endtry

    silent! wincmd P     " jump to preview window
    if &previewwindow    " if we really get there...
      if has("folding")
        silent! .foldopen    " don't want a closed fold
      endif
      call search("$", "b")    " to end of previous line
      let w = substitute(w, '\\', '\\\\', "")
      call search('\<\V' . w . '\>') " position cursor on match
      " Add a match highlight to the word at this position
      hi previewWord term=bold ctermbg=green guibg=green
      exe 'match previewWord "\%' . line(".") . 'l\%' . col(".") . 'c\k*"'
      wincmd p     " back to old window
    endif
  endif
endfun

imap <F3>   warn 'hate';<CR>

" open new file tab (abandon)
fun! OpenNewFileTab()
  let x = input("OpenFile:","",'file')  
  if strlen(x) == 0
    redraw
    return
  endif
  exec 'tabedit ' . x
endf
" nmap <silent> <c-x><c-f>   :call OpenNewFileTab()<CR>


" add prefix
fu! AddPrefix()
  let s = expand('<cword>')
  let prefix = input('prefix for "\<'.s.'\>":')
  if strlen(prefix) == 0  
    echo 'canceled.'
    return 
  endif
  exec ':bufdo %s!\<' . s . '\>!' . prefix . s . '!g'
endf
command! AddPrefix  :call AddPrefix()
nm <C-x><lt>   :AddPrefix<CR>


fun! DefineCommand(text,var)
  let l:cmd = input(a:text)
  if strlen(l:cmd) > 0 
    exec var . ' = ' . l:cmd
  endif
endf

let g:make_command = ''
let g:run_command = ''
fun! DefineRunCommand()
  let run_command = input("Define Run Command:")
  if strlen(run_command) > 0 
    let g:run_command = run_command
  endif
endf
com! DefineMakeCommand :call DefineCommand("Define Make Command:","g:make_command")
com! DefineRunCommand  :call DefineCommand("Define Run Command:","g:run_command")

nm <C-x>0  :exec "!clear && ".g:make_command<CR>
nm <C-x>9  :exec "!clear && ".g:run_command<CR>

au filetype    perl   :let g:run_command = 'perl -Ilib ' . expand('%')
au BufReadPost *.xs   :let g:make_command = 'perlmake > /dev/null'
au filetype    perl  :let g:make_command = 'perlmake > /dev/null'

fun! InsertTabWrapper()
  if pumvisible()
    return "\<c-n>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col -1] !~ '\k\|<\|/'
    return "\<tab>"
  elseif exists('&omnifunc') && &omnifunc == ''
    return "\<c-n>"
  else
    return "\<c-x>\<c-o>"
  endif
endf
autocmd VimEnter * inoremap <c-\> <c-r>=InsertTabWrapper()<cr>

" prevent completion conflict by autocomplpop when entering newline
fun! CompCheck()
  if pumvisible()
    return "\<ESC>o"
  else
    return "\<CR>"
  endif
endf
inoremap <silent> <CR>   <C-R>=CompCheck()<CR>

" autocmd! BufNewFile *.user.js 0r $HOME/.vim/template/greasemonkey.txt

let g:gist_clip_command = 'pbcopy'

" open lib and corresponding test at a new tab 
command! -nargs=1 Lib call s:open_lib_and_corresponding_test(<f-args>)
" AlternateCommand lib Lib
fun! s:open_lib_and_corresponding_test(fname)
  execute 'tabnew lib/' . a:fname . '.rb'
  execute 'vnew test/' . a:fname . '_test.rb'
  execute "normal \<Plug>(quickrun)\<C-w>J\<C-w>7_"
endf 
" 



" listcharsを切り替える
command! ListCharsDispFull set listchars=tab:^-,eol:$,trail:_,nbsp:% list
command! ListCharsDispTab set listchars=tab:^- list
command! ListCharsDispEol set listchars=eol:$ list

autocmd CmdwinEnter * AutoComplPopDisable
autocmd CmdwinLeave * AutoComplPopEnable

" set wrapscan " 検索時に最後まで行ったら最初に戻る
" set nobackup " バックアップファイルは作らない
" set autoread " 外部のエディタで編集中のファイルが変更されたら自動で読み直す



" surround.vim
" surroundに定義を追加する【ASCIIコードを調べるには:echo char2nr("-")】
" タグ系
let g:surround_33 = "<!-- \r -->"
let g:surround_37 = "<% \r %>"
let g:surround_45 = "<!-- \r -->"
"変数展開系
let g:surround_35 = "#{\r}"
let g:surround_36 = "${\r}"
let g:surround_64 = "@{\r}"


"---------------------------------
" 最後に選択したテキストを取得する
"-----------------------------
fun! x:selected_text()
  let [visual_p, pos, r_, r0] = [mode() =~# "[vV\<C-v>]", getpos('.'), @@, @0]

  if visual_p
    execute "normal! \<Esc>"
  endif
  normal! gvy
  let _ = @@

  let [@@, @0] = [r_, r0]
  if visual_p
    normal! gv
  else
    call setpos('.', pos)
  endif
  return _
endf


" fixme
fun! Smartchr(fallback_literal, ...)
  let args = reverse(copy(a:000))
  call add(args, a:fallback_literal)
  let args = map(args, 'type(v:val) == type("") ? [0, v:val] : v:val')

  for i in range(len(args) - 1)
    let [pattern1, literal1] = args[i]
    let [pattern2, literal2] = args[i+1]

    if pattern1 is 0
      if search('\V' . escape(literal2, '\') . '\%#', 'bcn')
        return repeat("\<BS>", len(literal2)) . literal1
      endif
    else
      throw 'FIXME: pattern is not implemented yet: ' . string(args[i])
    endif
  endfor
  return a:fallback_literal
endf


" c programming
" setlocal tags+=/usr/include/tags,/usr/include/sys/tags


func! LContext()
  let c = col(".")
  let l = line(".")
  let w = winline()
  normal! L
  if c == col(".") && l == line(".") && w == winline()
    exe "normal! \<C-b>"
  endif
endfunc


fun! BufInfo()
  echo "[bufnr ] ".bufnr("%")
  echo "[bufname ] ". expand("%:p")
  echo "[cwd ] " . getcwd()
  if filereadable(expand("%"))
    echo "[mtime ] " . strftime("%Y-%m-%d %H:%M %a",getftime(expand("%")))
  endif
  echo "[size ] " . Bufsize() . " bytes"
  echo "[comment ] " . (exists('b:commentSymbol') ? b:commentSymbol : "undefined")
  echo "[filetype ] " . &ft
  echo "[tab ] " . &ts . " (" . (&et ? "" : "no") . "expandtab)"
  echo "[keywordprg] " . &keywordprg
  echo "[makeprg ] " . &makeprg
  echo "[Buffer local mappings]"
  nmap <buffer>
endf


fun! FileInfo(filename)
  let fn = expand(a:filename)
  echo "[filename ] " . fn
  echo "[type ] " . getftype(fn)
  echo "[mtime ] " . strftime("%Y-%m-%d %H:%M %a",getftime(fn))
  echo "[size ] " . getfsize(fn) . " bytes"
  echo "[perm ] " . getfperm(fn)
endf

fun! Strip(str)
  return substitute(a:str, '\%(^\s\+\|\s\+$\)', '', 'g')
endf
fun! LStrip(str)
  return substitute(a:str, '^\s\+', '', 'g')
endf
fun! RStrip(str)
  return substitute(a:str, '\s\+$', '', 'g')
endf
com! RTrim :s/\s*$//
com! LTrim :s/^\s*//
cabbr rtrim RTrim
cabbr ltrim LTrim

"smart home function
fun! SmartHome(mode)
  let curcol = col(".")
  if &wrap
    normal! g^
  else
    normal! ^
  endif
  if col(".") == curcol
    if &wrap
      normal! g0
    else
      normal! 0
    endif
  endif
  if a:mode == "v"
    normal msgv`s
  endif
  return ""
endf

"smart end function
fun! SmartEnd(mode)
  let curcol = col(".")
  let lastcol = a:mode == "i" ? col("$") : col("$") - 1

  "gravitate towards ending for wrapped lines
  if curcol < lastcol - 1
    call cursor(0, curcol + 1)
  endif

  if curcol < lastcol
    if &wrap
      normal g$
    else
      normal $
    endif
  else
    normal g_
  endif

  "correct edit mode cursor position, put after current character
  if a:mode == "i"
    call cursor(0, col(".") + 1)
  endif

  if a:mode == "v"
    normal msgv`s
  endif

  return ""
endf 


" IncBufSwitch {{{
"-----------------------------------------------------------------------------
" IncBufSwitch
" - Emacs
" - C-c 
"-----------------------------------------------------------------------------
if 1
  command! IncBufSwitch :call IncBufferSwitch()
  hi link IncBufSwitchCurrent Search
  hi IncBufSwitchOnlyOne cterm=reverse ctermfg=1 ctermbg=6 cterm=bold

  fun! PartialBufSwitch(partialName, first)
    let lastBuffer = bufnr("$")
    let g:ibs_buflist = ''
    let flag = 0
    let i = 1
    while i <= lastBuffer
      if (bufexists(i) != 0 && buflisted(i))
        let filename = expand("#" . i . ":t")
        if (match(filename, a:partialName) > -1)
          if flag == g:ibs_tabStop
            if a:first == 0
              let g:ibs_current_buffer = i
            endif
          endif
          let g:ibs_buflist = g:ibs_buflist .','. expand("#" . i . ":t")
          let flag = flag + 1
        endif
      endif
      let i = i + 1
    endwhile
    let g:ibs_buflist = substitute(g:ibs_buflist, '^,', '', '')

    if flag == g:ibs_tabStop + 1
      let g:ibs_tabStop = - 1
    endif
    return flag
  endf

  fun! IncBufferSwitch()
    let origBufNr = bufnr("%")
    let g:ibs_current_buffer = bufnr("%")
    let partialBufName = ""
    let g:ibs_tabStop = 0

    let cnt = PartialBufSwitch('', 1)
    echon "ibs: "
    if cnt == 1
      echon ' {'
      echohl IncBufSwitchCurrent | echon g:ibs_buflist | echohl None
      echon '}'
    else
      echon ' {'. g:ibs_buflist .'}'
    endif

    while 1
      let flag = 0
      let rawChar = getchar()
      if rawChar == 13 " <CR>
        exe "silent buffer " . g:ibs_current_buffer
        break
      endif
      if rawChar == 27 || rawChar == 3 " <ESC> or <C-c>
        "echon "\r "
        let g:ibs_current_buffer = origBufNr
        break
      endif
      if rawChar == "\<BS>"
        let g:ibs_tabStop = 0
        if strlen(partialBufName) > 0
          let partialBufName = strpart(partialBufName, 0, strlen(partialBufName) - 1)
          if strlen(partialBufName) == 0
            let flag = 1
            if bufnr("%") != origBufNr
              let g:ibs_current_buffer = origBufNr
            endif
          endif
        else
          if bufnr("%") != origBufNr
            let g:ibs_current_buffer = origBufNr
          endif
          break
        endif
      elseif rawChar == 9 " TAB -- find next matching buffer
        let g:ibs_tabStop = (g:ibs_tabStop == -1) ? 0 : g:ibs_tabStop + 1
      else
        let nextChar = nr2char(rawChar)
        let partialBufName = partialBufName . nextChar
      endif

      let matchcnt = PartialBufSwitch(partialBufName, flag)
      if matchcnt == 0
        let partialBufName = strpart(partialBufName, 0, strlen(partialBufName) - 1)
        let matchcnt = PartialBufSwitch(partialBufName, flag)
      endif
      redraw
      echon "\ribs: " . partialBufName
      call ShowBuflist(partialBufName, matchcnt)
    endwhile
  endf

  fun! ShowBuflist(partialName, matchcnt)
    let lastBuffer = bufnr("$")
    let i = 1
    let first = 1
    echon " {"
    while i <= lastBuffer
      if (bufexists(i) != 0 && buflisted(i))
        let filename = expand("#" . i . ":t")
        if (a:partialName != "" && match(filename, a:partialName) > -1)
          if first
            let first = 0
          else
            echon ","
          endif
          if (g:ibs_current_buffer == i)
            if a:matchcnt == 1
              echohl IncBufSwitchOnlyOne
            else
              echohl IncBufSwitchCurrent
            endif
          endif
          echon filename
          echohl None
        endif
      endif
      let i = i + 1
    endwhile
    echon "}"
  endf
endif
" }}}
" Showfunc {{{
com! ShowFunc call ShowFunc()
fun! ShowFunc()
  let gf_s = &grepformat
  let gp_s = &grepprg
  let &grepformat = '%*\k%*\sfunction%*\s%l%*\s%f %*\s%m'
  let &grepprg = 'ctags -x --c-types=f --sort=no -o -'
  silent! grep %
  cwindow
  let &grepformat = gf_s
  let &grepprg = gp_s
endfunc
" }}}
" {<CR> hack {{{ 
fun! ElectricEnter()
  let l = getline(".")
  let len = strlen(l)
  if len + 1 == col(".") && l[len-1] == "{"
    return "\<CR>\<left>\<right>\<CR>}\<up>\<end>"
  else
    return "\<CR>"
  endif
endf
"imap <silent> <CR>  <C-R>=ElectricEnter()<CR>
" }}}
" Rename Helper {{{
" Christian J. Robinson <infynity@onewest.net> 
" http://www.vim.org/scripts/script.php?script_id=1928
command! -nargs=* -complete=file -bang RenameI :call RenameI("<args>", "<bang>")
fun! RenameI(name, bang)
  let l:curfile = expand("%:p")
  let v:errmsg = ""
  silent! exe "saveas" . a:bang . " " . a:name
  if v:errmsg =~# '^$\|^E329'
    if expand("%:p") !=# l:curfile && filewritable(expand("%:p"))
      silent exe "bwipe! " . l:curfile
      if delete(l:curfile)
        echoerr "Could not delete " . l:curfile
      endif
    endif
  else
    echoerr v:errmsg
  endif
endf
" }}}
" Screen + GDB {{{
" screen + gdb ----------------------------------------------------
"  sign define br text=>> texthl=Search
"  command! Breakpoint call Breakpoint() | se nu
"  command! ListBreakpoints sign place
"  let g:bpmap = {}
"  let g:bpsignplace = 0
"  function! Breakpoint()
"    let pos = expand("%") . ":" . line(".")
"    if !has_key(g:bpmap, pos)
"      let g:bpsignplace += 1
"      let g:bpmap[pos] = g:bpsignplace
"      exe ":sign place " . g:bpsignplace . " line=" . line(".") . " name=br file=" .expand("%")
"      call system("screen -X eval focus 'stuff \"b " . pos . "\"\\015' focus")
"    else
"      exe ":sign unplace " . g:bpmap[pos]
"      unlet g:bpmap[pos]
"      call system("screen -X eval focus 'stuff \"clear " . pos . "\"\\015' focus")
"    endif
"  endf
"  nnoremap <F9> :call Breakpoint()<CR>
"   
"  command! Clear call system("screen -X eval focus 'stuff \"clear " . expand("%") . ":" . line(".") . "\"\\015' focus")
"  command! Step call system("screen -X eval focus 'stuff s\\015' focus")
"  command! Continue call system("screen -X eval focus 'stuff c\\015' focus")
"  command! NextStep call system("screen -X eval focus 'stuff c\\015' focus") | +
"  command! Advance call system("screen -X eval focus 'stuff \"advance " . expand("%") . ":" . line(".") . "\"\\015' focus")
"  command! -nargs=+ PrintVariable call system("screen -X eval focus 'stuff \"p " . "<args>" . "\"\\015' focus")
" }}}

" mouse and selection should work as in xterm
set visualbell t_vb=

" set terse
" because we prefer terse error messages

"set grepprg=grep\ -Prn\ --exclude-from=$HOME/.grepignore\ '$*'\ *\ /dev/null
" GNU grep 2.5 (requires pcre for -P), use with :grep, :cn, :cp, :cl

" set grepprg=ack\ --nocolor\ --nogroup\ '$*'\ *\ /dev/null

" Trim Blank Lines {{{
fun! TrimBlankLines()
  while ( line('.') ) > 1 && getline( line('.') - 1 ) =~ '^\s*$' 
    cal cursor( line('.')-1, col('.'))
  endwhile
  cal cursor( line('.')+1 , col('.'))
  while getline('.') =~ '^\s*$'
    normal dd
  endwhile
endf
nnoremap <silent> dss  :cal TrimBlankLines()<CR>
" }}}

" buffer helper 
" XXX: find a better mapping for this , because i am using C-c to do <esc>
"nnoremap <silent>  <C-c>j   :bn<CR>
"nnoremap <silent>  <C-c>k   :bp<CR>
" 

" cpan.vim hook
let use_pcre_grep = 1

" init perl pm file  {{{
fun! s:get_packagename()
  return substitute(matchstr(expand('%:r'),'\(lib/\)\@<=.*'),'/','::','g')
endf
fun! s:apply_lines(lines,from,to)
  let lines = map(copy(a:lines) , "substitute(v:val,'".a:from."','".a:to."','g')" )
  return lines
endf
fun! s:append_pod()
  let pkg = s:get_packagename()
  let lines = readfile( expand('~/.vim/skeleton/perl.pod') )
  let lines = s:apply_lines(lines,'{PackageName}',pkg)
  cal append( '$' , lines  )
endf
fun! s:init_perl_pkg()
  let dir = expand('%:h')
  let pkg = s:get_packagename()
  silent exec '!mkdir -p  ' . dir
  call append(0, ["package " . pkg . ';' , 'use warnings;' , 'use strict;' , '' , '1;' ]) 
endf
autocmd BufNewFile *lib/*.pm :cal s:init_perl_pkg()
autocmd Filetype perl command! AddPod   :cal s:append_pod()

"}}}
" Mac clipboard copy from terminal  {{{
nm <C-y>  "+y
omap <C-y>  "+y
vmap <C-y>  "+y
"  }}}

" markdown text type ======================================== 
autocmd BufRead *.mkd       :setf mkd
autocmd BufRead *.markdown  :setf mkd

" tab helper mapping  {{{
nnoremap <silent> ty  :tab split<CR>
nnoremap <silent> td  :exec 'tabedit '.expand('%')<CR>
nnoremap <silent> tq  :tabclose<CR>
nnoremap <silent> tn  :tabnew<CR>
nnoremap <silent> th  :tab help<CR>
nnoremap <silent> tmh  :exec ':tabmove ' . ( tabpagenr()-2 )<CR>
nnoremap <silent> tml  :exec ':tabmove ' . tabpagenr()<CR>
nnoremap <silent> t]  gt 
nnoremap <silent> t[  gT
"  "}}}

fun! FTabMoveToLast()
  let lasttabnv = tabpagenr()
  silent exec ':tabmove ' . lasttabnv
endf
com! TabMoveToLast :call FTabMoveToLast()<CR>
nnoremap <silent> t$ :FTabMoveToLast<CR>

let vimtwitter_login = "user:password"

nnoremap <Space>   1<C-E><C-E><C-E><C-E>
nnoremap <leader>\   :w<CR>
nnoremap <leader>a   :bufdo! w<CR>

" select function name
" omap F :<C-U>normal! 0f(hviw<CR>

" select perl function name 
nnoremap <silent> vF   ?sub<CR>WviW
nm     <silent> yF   vFy
" 
" pod mapping 
nnoremap <silent> va= ?^=\w\+<CR>V/^=\w\+<CR>
nnoremap <silent> vi= ?^=\w\+<CR>jV/^=\w\+<CR>k
nm <silent> ca= va=c
nm <silent> ci= vi=c

" select/change pod header
nnoremap <silent> vh ?^=\w\+<CR>Wvg_
nm <silent> ch vhc

" mark as pod 
vmap += <ESC>`<O=pod<ESC>`>o=cut<ESC>gv
vmap +c <ESC>`<O/*<ESC>`>o*/<ESC>gv
" 
" post syntax init ========================================== 
" syn match url +orz+    containedin=ALL
"fun! PostSyntaxInit()
"  hi url ctermbg=yellow
"  syn match url +orz+    containedin=ALL
"endf
"autocmd Syntax * :call PostSyntaxInit()
"autocmd BufReadPost * :call PostSyntaxInit()
" =========================================================== 
" Itemfy  {{{
fun! Itemfy()
  let attr = [ '# vim' , "fdm=expr" , "fdl=1" ]
  let expr = "foldexpr=getline(v:lnum)=~'^=='"
        \ . "?'>1':getline(v:lnum)[0]=~'[*x(]'"
        \ . "?'>2':getline(v:lnum)=~'^--'?'<2':'='"
  let expr = substitute( expr , ':' , '\\\:' , 'g')

  cal add(attr , expr )
  cal append( 0, join( attr ,':') )
  w
  e! %
endf
com! Itemfy :call Itemfy()
" }}}
" Current Dir vimrc {{{
fun! s:CurDirVIMRC()
  if getcwd() == expand("~") 
    return 
  endif
  for f in [ '.vimrc' , '_vimrc' ]
    if filereadable(f) 
      redraw
      exec 'silent so '.f
      echo "Found .vimrc in current directory. Loaded"
      return
    endif
  endfor
endf
com! LoadCurDirVimRC  :cal s:CurDirVIMRC()
augroup CurDirVimRC
  au!
  autocmd VimEnter * :LoadCurDirVimRC
augroup END
" }}}
" ================================================== 
" fucking small <ESC> ( from kana ) 
map <C-@> <ESC>

" nmap :  q:i
nm ; :
" nm ,bs :buffers<CR>:buffer<Space>
vmap ; :

"nnoremap : ;
" 
" pod-helper mappings {{{
nnoremap <C-c><C-b>  :BumpVersion<CR>
nnoremap <C-c><C-p>  :FillPodHere<CR>
" }}}
" cpan.vim mappings {{{
nnoremap <silent> <C-c><C-m>        :OpenCPANWindowS<CR>
nnoremap <silent> <C-c><C-v>        :OpenCPANWindowSV<CR>
" }}}
" Firebug {{{
fun! BufferRemoveFireBugConsole()
  if &filetype == "javascript"
    :g/\s*console\.\(log\|info\|dir\)/d
    :w
  endif
endf
com! RemoveFireBugConsole :bufdo :cal BufferRemoveFireBugConsole()
" }}}

" Bar Helper ================================================ 
fun! FillBar(s,e,f)
  let cmstr = '"'
  let list = [ [a:s,''] ]
  if a:s != a:e 
    cal add(list,[a:e,''])
  endif
  for [l,fmark] in list
    let line = getline( l )
    let line = substitute(line,'\s*$','','')

    if strlen(line) == 0 
      let line = cmstr 
    endif

    " padding
    let line = line . ' '

    let len = 60
    for i in range( strlen(line) , len )
      let line = line . '='
    endfor
    if a:f 
      let line = line . ' ' . fmark
    endif
    cal setline( l , line )
  endfor
endf

com! -range FillBar :cal FillBar(<line1>,<line2>,0)
com! -range FillBarFold :cal FillBar(<line1>,<line2>,1)
" ============================================================ 

fun! GrepCSSClass()
  let pattern = input('pattern:')
  if strlen(pattern) == 0
    return
  endif

  vnew
  setl noswapfile  buftype=nofile bufhidden=hide
  setl nobuflisted nowrap cursorline nonumber fdc=0

  exec 'file grep-css-' . pattern
  let out = system( printf("ack -A6 --group '^\S.*%s' share/web/static/css/" , pattern ) )
  silent put=out

  syn match File "^share/.*$"
  syn match LineNr "^\d\+:"
  syn match Comment +//.*$+

  hi link File Function

  "setfiletype javascript
  cal cursor(1,1)
  autocmd BufWinLeave <buffer> :bw
endf

" jifty grep js ============================================= 
fun! GrepJS()
  let pattern = input('pattern:')
  if strlen(pattern) == 0
    return
  endif

  vnew
  setl noswapfile  buftype=nofile bufhidden=hide
  setl nobuflisted nowrap cursorline nonumber fdc=0


  exec 'file grep-js-' . pattern
  let out = system( printf("ack --group '%s' share/web/static/js/" , pattern ) )
  silent put=out

  syn match File "^share/.*$"
  syn match LineNr "^\d\+:"
  syn match Comment +//.*$+

  hi link File Function

  "setfiletype javascript
  cal cursor(1,1)
  autocmd BufWinLeave <buffer> :bw
endf
com! GrepJS  :cal GrepJS()
" =========================================================== 
com! EnableStringComplete   :set omnifunc=StringComplete#GetList

" autocmd FileType html setl omnifunc=htmlcomplete#CompleteTags
" autocmd FileType css  setl omnifunc=csscomplete#CompleteCSS
" autocmd FileType xml  setl omnifunc=xmlcomplete#CompleteTags
" autocmd FileType php  setl omnifunc=phpcomplete#CompletePHP
" autocmd FileType c    setl omnifunc=ccomplete#Complete


" com! AutoResource autocmd BufWritePost *.vim,.vimrc :so %

" console menu
:source $VIMRUNTIME/menu.vim
":set wildmenu
:set cpo-=<
:set wcm=<C-Z>
:map <F4> :emenu <C-Z>


let s:plurk_file = expand('~/.plurk')
if filereadable( s:plurk_file )
  exec 'source ' . s:plurk_file
endif

" Gist configuration
if has('mac')
  let g:gist_clip_command = 'pbcopy'
  let g:gist_open_browser_after_post = 1
  "let g:gist_browser_command = 'open -a Chromium %URL%'
  let g:gist_browser_command = 'open -a Chromium %URL%'
endif



" search helper {{{
nm <C-w>/  <C-w>v<C-w>l:redraw<CR>/
nm <C-w>*  <C-w>v<C-w>l:redraw<CR>*
nm <C-w>#  <C-w>v<C-w>l:redraw<CR>#
" }}}

" statusline ================================================
set laststatus=2 " All windows have statusline
if winwidth(0) >= 120
  " set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %(%{GitBranch()}\ %)\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
  " set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %(%{GitBranch()}\ %)\ %F%=[%{GetB()}]\ %l,%c%V%8P
endif
let status_str =
    \ ' %=opt:%{g:optionmode?''o'':''x''}'
"exec 'set statusline=%mb%n:%f%R%Y\ %l/%L,%c:%v' . escape(status_str,' \')

" ===========================================================
fun! s:clean_view()
  if strlen( &viewdir ) > 0 
    echo "Found " . &viewdir . " Cleaning up..."
    exec '!rm -rvf '. &viewdir
    echo &viewdir . "View Cleaned."
    redraw
  else
    echo "Please set viewdir option."
  endif
endf
com! CleanView   :cal s:clean_view()
cabbr cleanview CleanView

" ignore hidden and unloaded buffers
"set sessionoptions-=buffers
set sessionoptions=tabpages,resize
set isfname-==

au! BufReadPost,BufNewFile *.psgi :setf perl

fun! s:delete_this_file()
  silent exec '!rm ' . expand('%')
  silent bw!
endf
com! DeleteThis :cal s:delete_this_file()
cabbr delthis DeleteThis


" virtual tabstops using spaces
" set shiftwidth=4
" set softtabstop=4
" expandtab
" allow toggling between local and default mode
fun! TabToggle()
  if &expandtab
    set shiftwidth=8
    set softtabstop=0
    retab!
  else
    set shiftwidth=4
    set softtabstop=4
    retab!
  endif
endf


set ssop-=folds
com! Big wincmd _ | wincmd |

set cmdwinheight=5
set cmdheight=1

" fuzzyfinder configuration"{{{
nm <silent> <leader>fb :FufBuffer<CR>
nm <silent> <leader>ff :FufFile<CR>
"}}}
" ruby rc "{{{
fun! s:ruby_rc()
  nmap <C-c><C-c>   :w<CR>:!clear && ruby %<CR>

  " rubycomplete.vim
  let g:rubycomplete_buffer_loading = 1
  let g:rubycomplete_classes_in_global = 1
  let g:rubycomplete_rails = 0   " i dont need rails
endf
autocmd! filetype ruby :cal s:ruby_rc()
"}}}
" filetype completion hacks {{{
fun! FiletypeCompletion(lead,cmd,pos)
  let list = glob(expand('$VIMRUNTIME/syntax'). '/*.vim')
  let items = split(list,"\n")
  cal map(items,'matchstr(v:val,''\w\+\(.vim$\)\@='')')
  cal filter(items,"v:val =~ '^" . a:lead . "'")
  return items
endf
com! -complete=customlist,FiletypeCompletion -nargs=1 SetFiletype :setf <args>
cabbr sft SetFiletype
cabbr setf SetFiletype
" }}}

" XXX: plug completion {{{
fun! PlugCompletion(findstart,base)
  for func in b:plug_completion 

  endfor
endf
fun! SetupPlugCompletion(func)
  if ! exists('b:plug_completion') 
    let  b:plug_completion = [ &omnifunc ]
    set omnifunc=PlugCompletion
  endif
  cal add(b:plug_completion,a:func)
endf
" }}}
" scopy {{{
fun! s:scopy(host)
  echo a:host
  let target = '/tmp/' . expand('%:t')
  cal system( printf("scp %s %s:%s" , expand('%') , a:host , target ) )
  echo a:host . ':' . target
  cal system('echo '.a:host.':'.target.' | pbcopy ')
endf
com! -nargs=1 SCopy :cal s:scopy(<q-args>)
" }}}
" vimshell Config {{{
let g:VimShell_EnableInteractive = 1
let g:VimShell_EnableSmartCase = 1
let g:VimShell_EnableAutoLs = 1
" }}}
" open url lines {{{
fun! s:OpenURLLine(f,e)
  if ! exists('g:browser_cmd')
    if has('mac')
      let g:browser_cmd = 'open -a Chromium %s'
    else
      let g:browser_cmd = 'firefox %s'
    endif
  endif

  let l:cnt = 0
  if a:f == a:e 
    cal system( printf(g:browser_cmd,  url ) )
    let l:cnt += 1
  else
    for i in range(a:f,a:e)
      let url = getline(i)
      if url !~ '^http'
        next
      endif

      redraw
      echo "Opening '" . url . "'.."
      sleep 300m
      cal system( printf(g:browser_cmd,  url ) )
      let l:cnt += 1
    endfor
  endif
  redraw
  echo "Done. " . l:cnt . " Items opened."
endf
com! -range OpenURLLine :cal s:OpenURLLine( <line1> , <line2> )
" }}}
" French Query XXX {{{
fun! FrVerb(word)
  :cal system(printf('open http://french.about.com/od/verb_conjugations/%s/%s.htm',a:word[0],a:word))
endf
fun! EnFr(word)
  :cal system(printf('open http://www.wordreference.com/enfr/%s',a:word ) )
  :cal system(printf('open http://www.babelnation.com/french/dictionary/index.html?qe=%s&qv=%s&q=%s',a:word,a:word,a:word))
  :cal system(printf('open http://www.french-linguistics.co.uk/dictionary/englishfrench/?word=%s',a:word))
endf
com! -nargs=1 EnFr  :cal EnFr(<q-args>)
com! -nargs=1 FrVerb  :cal FrVerb(<q-args>)
" }}}

let g:acp_enableAtStartup = 0


"nnoremap <CR>       5<C-e>
"nnoremap <S-space>  5<C-e>

let g:bufExplorerFindActive = 0

" pair closing {{{
" inoremap ( ()<ESC>i
" inoremap <expr> ) ClosePair(')')
" 
" inoremap { {}<ESC>i
" inoremap <expr> } ClosePair('}')
" 
" inoremap [ []<ESC>i
" inoremap <expr> ] ClosePair(']')

"inoremap < <><ESC>i
"inoremap <expr> > ClosePair('>')
 
" pair close checker.
" from othree vimrc ( http://github.com/othree/rc/blob/master/osx/.vimrc )
fun! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf
" }}}

let g:NERDTreeInitWhenNoMirrorFound = 1

nm <leader>ak  :AckFromSearch<CR>

" bash-like ctrl-k
inoremap <C-k>   <C-o>c$

fun! s:edit_wip()
  tabedit ~/aiink/wip/current
  lcd ~/aiink/wip
endf
com! EditWIP   :cal s:edit_wip()
cabbr ewip EditWIP

fun! s:edit_dotfile(file)
  exec 'tabedit ~/mygit/private-dotfile/' . a:file
  lcd ~/mygit/private-dotfile/
endf
com! EditVimrc  :cal s:edit_dotfile('vimrc')
com! EditGVimrc  :cal s:edit_dotfile('gvimrc')
"cabbr config   EditVimrc
"cabbr gconfig  EditGVimrc 

" Enable mouse support.
set mouse=a

" For screen.
if &term =~ "^screen"
    augroup MyAutoCmd
        autocmd VimLeave * :set mouse=
     augroup END

    " screenでマウスを使用するとフリーズするのでその対策
    set ttymouse=xterm2
endif


" i like to use different register for cut,copy,paste
"nnoremap yy "0y
"vnoremap y "0y
"nnoremap p "0p
"vnoremap x "0d
"cabbr ejs tabedit share/web/static/js/

hi Todo guibg=yellow guifg=black ctermbg=yellow ctermfg=black

cabbr jiftydir    :lcd ~/aiink/jifty
cabbr jiftydbidir :lcd ~/aiink/jifty-dbi
cabbr aiinkdir    :lcd ~/aiink/aiink

" Enable Perl Folding"{{{
let perl_fold = 1
let perl_fold_blocks = 1
let perl_include_pod = 1
"}}}
" Extra Plugin Loader {{{
" mv your seldom used plugin files to ~/.vim/extra_plugin/ directory
" and you can load plugins in oneline
" e.g.
"   LoadExtraPlugin vimshell.vim gist.vim 
" 
" completion is supported.
let g:extra_plugin_dir = '~/.vim/extra_plugin/'
fun! ExtraPluginNameCompletion(lead,cmd,cur)
  let args = split(a:cmd)
  cal remove(args,0)
  if strlen(a:lead) > 0 
    cal remove(args,-1)
  endif

  let path = split(glob(g:extra_plugin_dir.'*'))
  let names = map(path, 'matchstr(v:val,''\(/\)\@<=[a-zA-Z0-9-_+.]*$'')'  )
  cal filter(names," v:val =~ '^".a:lead."'")

  let comps = { }
  for n in extend(names,args)
    let comps[ n ] = 1
  endfor
  for a in args
    unlet comps[ a ]
  endfor
  return keys(comps)
endf
fun! s:LoadExtraPlugin(args)
  for plugin in split(a:args)
    echohl MoreMsg | echo "Loading " . plugin . " plugin..."   | echohl None
    exec ':source ' . g:extra_plugin_dir . plugin
  endfor
  echohl MoreMsg | echo "Done"   | echohl None
endf
com! -nargs=+ -complete=customlist,ExtraPluginNameCompletion -nargs=1 LoadExtraPlugin :cal s:LoadExtraPlugin(<q-args>)
cabbr le LoadExtraPlugin
" }}}
" Gui MacVim Configurations"{{{
if has('gui_macvim')
    set showtabline=2 " タブを常に表示
    " set imdisable " IMを無効化
    set transparency=16 " 透明度を指定
    set antialias
    "set guifont=Monaco:h13
    set guifont=Courier\ New:h14
endif
"}}}

" nmap <leader>cc  :set cursorline!<CR>
" Extend Perl Moose Syntax 
" let disable_moose_extends = 1

" Insert Images from a path {{{
fun! s:InsertImage(path)
  let files = split(glob( a:path . '/*'))
  for f in files
    let img = printf('<img src="%s"/>',f)
    put=img
  endfor
endf
com! -nargs=1 -complete=dir InsertImage  :cal s:InsertImage(<q-args>)
" }}}
" Copy to then end of line {{{
nnoremap Y y$
" }}}
" New from file {{{
fun! s:NewFromFile(file)
  let file = a:file
  if strlen( a:file ) == 0 
    let file = expand('%')
  endif
  let newfile = input('New Filename:',file,'file')
  cal system(printf('cp %s %s',file,newfile))
  exec 'tabedit ' . newfile
endf
com! -nargs=? -complete=file NewFromFile :cal s:NewFromFile(<q-args>)
" }}}
" Window Resize Mode for Terminal {{{
fun! s:ResizeMode()
  let degree = 5
  if ! exists('g:resize_mode')
    let g:resize_mode = 1
    exec 'nmap <buffer> >  :vertical resize +'.degree.'<CR>'
    exec 'nmap <buffer> <  :vertical resize -'.degree.'<CR>'

    exec 'nmap <buffer> <Left>   :vertical resize +'.degree.'<CR>'
    exec 'nmap <buffer> <Right>  :vertical resize -'.degree.'<CR>'

    exec 'nmap <buffer> +  :resize +'.degree.'<CR>'
    exec 'nmap <buffer> -  :resize -'.degree.'<CR>'

    exec 'nmap <buffer> <Up>     :resize +'.degree.'<CR>'
    exec 'nmap <buffer> <Down>   :resize -'.degree.'<CR>'
    echo "ResizeMode On"
  else
    nunmap <buffer> >
    nunmap <buffer> <
    nunmap <buffer> <Left>
    nunmap <buffer> <Right>
    nunmap <buffer> <Up>
    nunmap <buffer> <Down>
    nunmap <buffer> +
    nunmap <buffer> -
    unlet g:resize_mode
    echo "ResizeMode Off"
  endif
endf
nm <leader>ww   :ResizeMode<CR>
com! ResizeMode  :cal s:ResizeMode()
" }}}

autocmd BufRead *.txt :setf txt

" Vim Function Implementor {{{
" cal s:Test( test )
fun! g:ImVimFunction()
  let line = getline('.')
  normal B
  let ocol = col('.')-1
  let col =  col('.')
  while col > 0 && line[ col - 1] =~ '[a-zA-Z0-9:_.,() ''"]'
    let col += 1
  endwhile
  let funname = strpart(line,ocol,col-ocol)
  normal {
  cal append('.', [ "fun! " . funname , "", "endf", "" ] )
  cal cursor( line('.') + 2 , col('.') )
  startinsert
  cal feedkeys("\t") 
endf
autocmd filetype vim  :nmap <silent><buffer> <C-x><C-i> :cal g:ImVimFunction()<CR> 
" }}}
" change local buffer current directory to the current file parent directory.   {{{
" and change to parent dir if a git directory is found in parent directory.
fun! s:LocalChangeDir(local)
  let path = expand('%:p:h')
  let parts = split(path,'/')
  let paths = []
  for i in range(1,len(parts))
    cal add(paths,  '/'.join(parts,'/'))
    cal remove(parts,-1)
  endfor
  for p in paths 
    if isdirectory(p . '/.git')
      redraw
      if a:local
        echo 'Found .git dir. Changing local directory to: ' . p
        exec 'lcd ' . p
      else
        echo 'Found .git dir. Changing directory to: ' . p
        exec 'cd ' . p
      endif
      return
    endif
  endfor
  redraw
  if a:local
    echo 'Changing local directory to: ' . path
    exec 'lcd ' . path
  else
    echo 'Changing directory to: ' . path
    exec 'cd ' . path
  endif
endf
com! LC  :cal s:LocalChangeDir(0)
com! LLC :cal s:LocalChangeDir(1)
" }}}
" 雷光夏
" Simple Commenter Loader {{{
let s:simplecommenter = expand('~/mygit/simplecommenter.vim/simplecommenter.vim')
if filereadable( s:simplecommenter )
  exec 'so ' . s:simplecommenter
endif
" }}}

" force reload flag for some plugin
let force_reload = 1

let g:netrw_liststyle = 3           " 0=thin 1=long 2=wide 3=tree

let s:blogger_config = expand('~/.blogger.vim')
if filereadable( s:blogger_config )
  exec 'so ' . s:blogger_config
endif

" new temp file command.
com! NewTemp   :exec 'tabe ' . tempname()

" vim messages command
nm ,m   :messages<CR>


nm <silent> ==   {=}''

set foldmethod=indent
