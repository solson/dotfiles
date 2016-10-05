" Don't edit this file. It was generated by generate-colorscheme.rb.

" Copyright © 2016, Scott Olson <scott@solson.me>
"
" Permission to use, copy, modify, and/or distribute this software for any
" purpose with or without fee is hereby granted, provided that the above
" copyright notice and this permission notice appear in all copies.
"
" THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
" REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
" AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
" INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
" LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
" OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
" PERFORMANCE OF THIS SOFTWARE.

set background=dark
hi clear

if exists('syntax_on')
  syntax reset
endif

let colors_name = 'solson'

hi ColorColumn ctermbg=235
hi Comment ctermfg=243
hi LineNr ctermfg=238
hi NonText ctermfg=238
hi Normal ctermbg=234 ctermfg=253
hi SpecialComment ctermfg=66
hi Todo ctermbg=NONE ctermfg=217
hi VertSplit cterm=NONE ctermbg=235 ctermfg=235
hi Visual ctermbg=238 ctermfg=NONE
hi SignColumn ctermbg=NONE
hi DiffAdd ctermbg=NONE ctermfg=66
hi DiffChange ctermbg=NONE ctermfg=110
hi DiffDelete ctermbg=NONE ctermfg=217
hi SpellCap ctermbg=238 ctermfg=230
hi SpellBad ctermbg=238 ctermfg=217
hi Error ctermbg=NONE ctermfg=160
hi Identifier cterm=NONE
hi Character ctermfg=110
hi String ctermfg=110
hi Macro ctermfg=230
hi PreCondit ctermfg=230
hi PreProc ctermfg=230
hi Constant ctermfg=NONE
hi Identifier ctermfg=NONE
hi Type ctermfg=NONE
hi Underlined ctermfg=NONE
hi rubyFunction cterm=bold
hi rustFuncName cterm=bold
hi rustIdentifier cterm=bold
hi Special ctermfg=247
hi Statement ctermfg=247
hi StorageClass ctermfg=247
hi Structure ctermfg=247
hi Typedef ctermfg=247
hi rubyClass ctermfg=247
hi rubyControl ctermfg=247
hi rubyDefine ctermfg=247
hi rubyInclude ctermfg=247
hi rubyInterpolationDelimiter ctermfg=247
hi rubyModule ctermfg=247
hi! link htmlItalic Normal
hi! link rustFuncCall Normal
hi! link rustModPath Normal
hi! link vimEnvVar Normal
hi! link vimFgBgAttrib Normal
hi! link vimHiAttrib Normal
hi! link vimOption Normal
