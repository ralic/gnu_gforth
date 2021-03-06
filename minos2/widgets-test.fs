\ simple tests for widgets code

\ Copyright (C) 2014,2016 Free Software Foundation, Inc.

\ This file is part of Gforth.

\ Gforth is free software; you can redistribute it and/or
\ modify it under the terms of the GNU General Public License
\ as published by the Free Software Foundation, either version 3
\ of the License, or (at your option) any later version.

\ This program is distributed in the hope that it will be useful,
\ but WITHOUT ANY WARRANTY; without even the implied warranty of
\ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
\ GNU General Public License for more details.

\ You should have received a copy of the GNU General Public License
\ along with this program. If not, see http://www.gnu.org/licenses/.

require widgets.fs

also minos

glue*2 $FFFFFFDF 32e }}frame dup .button2 value f1
glue*2 $FF7FFFFF 32e }}frame dup .button3 value f2
glue*1 $FFFF7FFF 16e }}frame dup .button1 value f3
glue*1 $FF7F7FFF 32e }}frame dup .button1 value f4
glue*1 $7FFF7FFF 8e  }}frame dup .button1 value f5
glue*2 $7FFFFFFF 16e }}frame dup .button2 value f6
text new value t1
text new value t2
text new value t3
{{ {{
{{ f3 t2 }}z dup value z2
{{ {{ f1 t1 }}z dup value z1 f2 t3 }}h dup value h1
{{ f4 f5 }}h dup value h2
}}v dup value h3
f6 }}h Value htop

also freetype-gl
48e FConstant fontsize#
atlas fontsize#
[IFDEF] android
    "/system/fonts/DroidSans.ttf"
[ELSE]
    "/usr/share/fonts/truetype/LiberationSans-Regular.ttf"
    2dup file-status nip [IF]
	2drop "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf"
    [THEN]
[THEN]
2dup file-status throw drop
texture_font_new_from_file Value font1

atlas fontsize#
[IFDEF] android  "/system/fonts/DroidSansFallback.ttf"
    2dup file-status nip [IF]
	2drop "/system/fonts/NotoSansSC-Regular.otf" \ for Android 6
	2dup file-status nip [IF]
	    2drop "/system/fonts/NotoSansCJK-Regular.ttc" \ for Android 7
	[THEN]
    [THEN]
[ELSE] "/usr/share/fonts/truetype/gkai00mp.ttf"
    2dup file-status nip [IF]
	2drop "/usr/share/fonts/truetype/arphic-gkai00mp/gkai00mp.ttf"
    [THEN]
[THEN]
2dup file-status throw drop
texture_font_new_from_file Value font2
previous

: !t1 ( -- ) t1 >o
    "Dös isch a Tägscht!" font1 text!  32e to border
    $884400FF to text-color o> ;

: !t2 ( -- ) t2 >o
    "这是一个文本：在德语说" font2 text!  32e to border
    $004488BF to text-color o> ;

: !t3 ( -- ) t3 >o
    "..." font1 text!  32e to border
    $00FF88FF to text-color o> ;

: htop-resize ( -- )
    !size 0e 1e dh* 1e dw* 1e dh* 0e resize ;
: !widgets ( -- ) !t1 !t2 !t3 htop .htop-resize ;

: widgets-test ( -- ) htop .widget-draw ;

also [IFDEF] android android [THEN]

: widgets-demo ( -- )  [IFDEF] hidekb  hidekb [THEN]
    1 level# +!  !widgets widgets-test  BEGIN  >looper
	?config-changer need-sync @ IF
	    htop .htop-resize  widgets-test  need-sync off  THEN
    level# @ 0= UNTIL  need-sync on  need-show on ;

previous

script? [IF] widgets-demo bye [THEN]