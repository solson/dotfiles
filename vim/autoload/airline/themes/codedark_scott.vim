" Vim Code Dark (airline theme)
" https://github.com/tomasiser/vim-code-dark

" With a different choice of background colors for Normal/Insert/Replace/Visual.
" - Scott Olson <scott@solson.me>

scriptencoding utf-8

let g:airline#themes#codedark_scott#palette = {}

" Terminal colors (base16):
let s:cterm00 = "00"
let s:cterm03 = "08"
let s:cterm05 = "07"
let s:cterm07 = "15"
let s:cterm08 = "01"
let s:cterm0A = "03"
let s:cterm0B = "02"
let s:cterm0C = "06"
let s:cterm0D = "04"
let s:cterm0E = "05"
if exists('base16colorspace') && base16colorspace == "256"
  let s:cterm01 = "18"
  let s:cterm02 = "19"
  let s:cterm04 = "20"
  let s:cterm06 = "21"
  let s:cterm09 = "16"
  let s:cterm0F = "17"
else
  let s:cterm01 = "00"
  let s:cterm02 = "08"
  let s:cterm04 = "07"
  let s:cterm06 = "07"
  let s:cterm09 = "06"
  let s:cterm0F = "03"
endif

if &t_Co >= 256
    let g:codedark_term256=1
elseif !exists("g:codedark_term256")
    let g:codedark_term256=0
endif

let s:cdFront = {'gui': '#FFFFFF', 'cterm':  (g:codedark_term256 ? '15' : s:cterm07)}
let s:cdFrontGray = {'gui': '#D4D4D4', 'cterm': (g:codedark_term256 ? '188' : s:cterm05)}
let s:cdBack = {'gui': '#1E1E1E', 'cterm': (g:codedark_term256 ? '234' : s:cterm00)}
let s:cdSelection = {'gui': '#264F78', 'cterm': (g:codedark_term256 ? '24' : s:cterm01)}

let s:cdGray = {'gui': '#808080', 'cterm': s:cterm04, 'cterm256': '08'}
let s:cdViolet = {'gui': '#646695', 'cterm': s:cterm04, 'cterm256': '60'}
let s:cdBlue = {'gui': '#569CD6', 'cterm': s:cterm0D, 'cterm256': '75'}
let s:cdDarkBlue = {'gui': '#223E55', 'cterm': s:cterm0D, 'cterm256': '73'}
let s:cdLightBlue = {'gui': '#9CDCFE', 'cterm': s:cterm0C, 'cterm256': '117'}
let s:cdGreen = {'gui': '#6A9955', 'cterm': s:cterm0B, 'cterm256': '65'}
let s:cdBlueGreen = {'gui': '#4EC9B0', 'cterm': s:cterm0F, 'cterm256': '43'}
let s:cdLightGreen = {'gui': '#B5CEA8', 'cterm': s:cterm09, 'cterm256': '151'}
let s:cdRed = {'gui': '#F44747', 'cterm': s:cterm08, 'cterm256': '203'}
let s:cdOrange = {'gui': '#CE9178', 'cterm': s:cterm0F, 'cterm256': '173'}
let s:cdLightRed = {'gui': '#D16969', 'cterm': s:cterm08, 'cterm256': '167'}
let s:cdYellowOrange = {'gui': '#D7BA7D', 'cterm': s:cterm0A, 'cterm256': '179'}
let s:cdYellow = {'gui': '#DCDCAA', 'cterm': s:cterm0A, 'cterm256': '187'}
let s:cdPink = {'gui': '#C586C0', 'cterm': s:cterm0E, 'cterm256': '176'}

let s:cdDarkDarkDark = {'gui': '#262626', 'cterm': (g:codedark_term256 ? '235' : s:cterm01)}
let s:cdDarkDark = {'gui': '#303030', 'cterm': (g:codedark_term256 ? '236' : s:cterm02)}
let s:cdDark = {'gui': '#3C3C3C', 'cterm': (g:codedark_term256 ? '237' : s:cterm03)}

let s:Warning = [ s:cdRed.gui, s:cdDarkDark.gui, s:cdRed.cterm, s:cdDarkDark.cterm, 'none']

" Normal

let s:N1 = [ s:cdFront.gui, s:cdBlue.gui, s:cdFront.cterm, s:cdBlue.cterm, 'none' ]
let s:N2 = [ s:cdFront.gui, s:cdDarkDark.gui, s:cdFront.cterm, s:cdDarkDark.cterm, 'none' ]
let s:N3 = [ s:cdFront.gui, s:cdDarkDarkDark.gui, s:cdFront.cterm, s:cdDarkDarkDark.cterm, 'none' ]
let s:NM = [ s:cdFront.gui, s:cdDarkDarkDark.gui, s:cdFront.cterm, s:cdDarkDarkDark.cterm, 'none']

let g:airline#themes#codedark_scott#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#codedark_scott#palette.normal_modified = { 'airline_c': s:NM }
let g:airline#themes#codedark_scott#palette.normal.airline_warning = s:Warning
let g:airline#themes#codedark_scott#palette.normal_modified.airline_warning = s:Warning

" Insert

let s:I1 = [ s:cdFront.gui, s:cdGreen.gui, s:cdFront.cterm, s:cdGreen.cterm, 'none' ]
let s:I2 = [ s:cdFront.gui, s:cdDarkDark.gui, s:cdFront.cterm, s:cdDarkDark.cterm, 'none' ]
let s:I3 = [ s:cdFront.gui, s:cdDarkDarkDark.gui, s:cdFront.cterm, s:cdDarkDarkDark.cterm, 'none' ]
let s:IM = [ s:cdFront.gui, s:cdDarkDarkDark.gui, s:cdFront.cterm, s:cdDarkDarkDark.cterm, 'none']

let g:airline#themes#codedark_scott#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#codedark_scott#palette.insert_modified = { 'airline_c': s:IM }
let g:airline#themes#codedark_scott#palette.insert.airline_warning = s:Warning
let g:airline#themes#codedark_scott#palette.insert_modified.airline_warning = s:Warning

" Replace

let s:R1 = [ s:cdFront.gui, s:cdRed.gui, s:cdFront.cterm, s:cdRed.cterm, 'none' ]
let s:R2 = [ s:cdFront.gui, s:cdDarkDark.gui, s:cdFront.cterm, s:cdDarkDark.cterm, 'none' ]
let s:R3 = [ s:cdFront.gui, s:cdDarkDarkDark.gui, s:cdFront.cterm, s:cdDarkDarkDark.cterm, 'none' ]
let s:RM = [ s:cdFront.gui, s:cdDarkDarkDark.gui, s:cdFront.cterm, s:cdDarkDarkDark.cterm, 'none']

let g:airline#themes#codedark_scott#palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)
let g:airline#themes#codedark_scott#palette.replace_modified = { 'airline_c': s:RM }
let g:airline#themes#codedark_scott#palette.replace.airline_warning = s:Warning
let g:airline#themes#codedark_scott#palette.replace_modified.airline_warning = s:Warning

" Visual

let s:V1 = [ s:cdFront.gui, s:cdPink.gui, s:cdFront.cterm, s:cdPink.cterm, 'none' ]
let s:V2 = [ s:cdFront.gui, s:cdDarkDark.gui, s:cdFront.cterm, s:cdDarkDark.cterm, 'none' ]
let s:V3 = [ s:cdFront.gui, s:cdDarkDarkDark.gui, s:cdFront.cterm, s:cdDarkDarkDark.cterm, 'none' ]
let s:VM = [ s:cdFront.gui, s:cdDarkDarkDark.gui, s:cdFront.cterm, s:cdDarkDarkDark.cterm, 'none']

let g:airline#themes#codedark_scott#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)
let g:airline#themes#codedark_scott#palette.visual_modified = { 'airline_c': s:VM }
let g:airline#themes#codedark_scott#palette.visual.airline_warning = s:Warning
let g:airline#themes#codedark_scott#palette.visual_modified.airline_warning = s:Warning

" Inactive

let s:IA1 = [ s:cdFrontGray.gui, s:cdDark.gui, s:cdFrontGray.cterm, s:cdDark.cterm, 'none' ]
let s:IA2 = [ s:cdFrontGray.gui, s:cdDarkDark.gui, s:cdFrontGray.cterm, s:cdDarkDark.cterm, 'none' ]
let s:IA3 = [ s:cdFrontGray.gui, s:cdDarkDarkDark.gui, s:cdFrontGray.cterm, s:cdDarkDarkDark.cterm, 'none' ]
let s:IAM = [ s:cdFrontGray.gui, s:cdDarkDarkDark.gui, s:cdFrontGray.cterm, s:cdDarkDarkDark.cterm, 'none' ]

let g:airline#themes#codedark_scott#palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
let g:airline#themes#codedark_scott#palette.inactive_modified = { 'airline_c': s:IAM }

" Accents

let g:airline#themes#codedark_scott#palette.accents = {
  \ 'gray': [ s:cdGray.gui, '', s:cdGray.cterm, '' ],
  \ 'violet': [ s:cdViolet.gui, '', s:cdViolet.cterm, '' ],
  \ 'blue': [ s:cdBlue.gui, '', s:cdBlue.cterm, '' ],
  \ 'dark_blue': [ s:cdDarkBlue.gui, '', s:cdDarkBlue.cterm, '' ],
  \ 'light_blue': [ s:cdLightBlue.gui, '', s:cdLightBlue.cterm, '' ],
  \ 'green': [ s:cdGreen.gui, '', s:cdGreen.cterm, '' ],
  \ 'blue_green': [ s:cdBlueGreen.gui, '', s:cdBlueGreen.cterm, '' ],
  \ 'light_green': [ s:cdLightGreen.gui, '', s:cdLightGreen.cterm, '' ],
  \ 'orange': [ s:cdOrange.gui, '', s:cdOrange.cterm, '' ],
  \ 'red': [ s:cdRed.gui, '', s:cdRed.cterm, '' ],
  \ 'light_red': [ s:cdLightRed.gui, '', s:cdLightRed.cterm, '' ],
  \ 'yellow_orange': [ s:cdYellowOrange.gui, '', s:cdYellowOrange.cterm, '' ],
  \ 'yellow': [ s:cdYellow.gui, '', s:cdYellow.cterm, '' ],
  \ 'pink': [ s:cdPink.gui, '', s:cdPink.cterm, '' ],
  \ }

