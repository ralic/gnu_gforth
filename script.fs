\ Copyright (C) 2001,2003 Free Software Foundation, Inc.

\ This file is part of Gforth.

\ Gforth is free software; you can redistribute it and/or
\ modify it under the terms of the GNU General Public License
\ as published by the Free Software Foundation; either version 2
\ of the License, or (at your option) any later version.

\ This program is distributed in the hope that it will be useful,
\ but WITHOUT ANY WARRANTY; without even the implied warranty of
\ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
\ GNU General Public License for more details.

\ You should have received a copy of the GNU General Public License
\ along with this program; if not, write to the Free Software
\ Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111, USA.

\ scripting extensions

: sh-eval ( addr u -- )
    \G evaluate string + rest of command line
    2dup 2>r >in @ >r negate
    source >in @ 1- /string + c@ bl <> + >in +! drop sh
    $? IF  r> >in ! 2r> defers interpreter-notfound
    ELSE  rdrop 2rdrop  THEN ;
' sh-eval IS interpreter-notfound

2Variable sh$  0. sh$ 2!
: sh-get ( addr u -- addr' u' )
    \G open command addr u, and read in the result
    sh$ free-mem-var
    r/o open-pipe throw dup >r slurp-fid
    r> close-pipe throw to $? 2dup sh$ 2! ;

:noname '` parse sh-get ;
:noname '` parse postpone SLiteral postpone sh-get ;
interpret/compile: s`