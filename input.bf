
( debug words )
: ?3 << ? > ? > ? ;
: ?2 < ? > ? ;
: ASK ? ;

( numeric literal words )
:  0 >                   ;
:  1 > +                 ;
:  2 > ++                ;
:  3 > +++               ;
:  4 > ++++              ;
:  5 > +++++             ;
:  6 > ++++++            ;
:  7 > +++++++           ;
:  8 > ++++++++          ;
:  9 > +++++++++         ;
: 10 > ++++++++++        ;
: 11 > +++++++++++       ;
: 12 > ++++++++++++      ;
: 13 > +++++++++++++     ;
: 14 > ++++++++++++++    ;
: 15 > +++++++++++++++   ;
: 16 > ++++++++++++++++  ;
: 255 > - ;


( stack manipulation words )
: DROP [-]< ;
: SWAP [->+<]<[->+<]>>[-<<+>>]< ;
: SWAPDROP <[-]>[-<+>]< ;
: 1SWAP [->+<]+> ;
: DUP [->+>+<<]>>[-<<+>>]< ;

: ROT  [->+<] <[->+<] <[->+<] >>> [-<<<+>>>] < ;

( a b -- 0 a b )
: 0ROT
		    ( a b )
	[->+<]  ( a 0< b )
	<[->+<] ( 0< a b )
	>>      ( 0 a b )
	;

: UNROT ROT ROT ;
: OVER <[->> +>+< <<] >>> [-<<<+>>>] < ;

: 2DUP
	[->>+>+<<<] >>>
	[-<<<+>>>] <<<<
	[->>+>>+<<<<] >>>>
	[-<<<<+>>>>] <
;

( arithmetic words )

: INC + ;
: DEC - ;

( example: 2 3 ADD => 5 )
: ADD [-<+>]< ;

( example: 5 3 SUB => 2 )
: SUB [-<->]< ;

( example: 2 3 MUL => 6 )
: MUL < [-> [->+>+<<] >>[-<<+>>]<< <] >[-]>[-<<+>>]<< ;

( example: 5 2MUL => 10 )
: 2MUL [->++<]>[-<+>]< ;

( logical words )
: NOT >+< [>-<[-]] >[-<+>]< ;
: EQ SUB NOT ;

: IF [[-] < ;
: ELSE >>+<< >]< >> NOT [-<+>]<  IF ; 
: ENDIF > ]< ;
: DO_ >>+[-<< ;
: _WHILE IF >>+<< ENDIF >> ] << ;

( complex words )
: POW
	1SWAP 
	DO_
		DEC
		ROT
		OVER MUL
		UNROT
		DUP
	_WHILE
	DROP
	SWAPDROP
;

: SATDEC DUP IF - ENDIF ;
: LT <[-> SATDEC <] >[-<+>]< ;


: DIV
	      ( a b )
	0ROT  ( 0 a b ) 

	DO_
			  ( n a b )	
		2DUP  ( n a b a b )
		LT    ( n a b a<b )
		NOT   ( n a b a>=b )
		IF    ( n a b )
			DUP       ( n a   b b )
			[-<<->>]< ( n a-b b )
			<<+>>     ( n+1 a-b b )
			1         ( n+1 a-b b 1 )
		ELSE
			0 ( n a b 0 )
		ENDIF
		( n a b k )
	_WHILE
	DROP
;

: 43 10 [->++++<] >[-<+>]<+++ ;

16 10 DIV ?2
