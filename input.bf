
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

: DROP ( a -- ) [-]< ;

: SWAP ( a b -- b a ) [->+<]<[->+<]>>[-<<+>>]< ;

: SWAPDROP ( a b -- b ) <[-]>[-<+>]< ;

: 1SWAP ( a -- 1 a ) [->+<]+> ;

: DUP ( a -- a a ) [->+>+<<]>>[-<<+>>]< ;

: ROT ( a b c -- c a b )  [->+<] <[->+<] <[->+<] >>> [-<<<+>>>] < ;

: 0ROT ( a b -- 0 a b )
		    ( a b )
	[->+<]  ( a 0< b )
	<[->+<] ( 0< a b )
	>>      ( 0 a b )
	;

: UNROT ( a b c -- b c a ) ROT ROT ;
: OVER ( a b -- a b a  ) <[->> +>+< <<] >>> [-<<<+>>>] < ;

: 2DUP ( a b -- a b a b )
	[->>+>+<<<] >>>
	[-<<<+>>>] <<<<
	[->>+>>+<<<<] >>>>
	[-<<<<+>>>>] <
;

( arithmetic words )

: INC ( a -- a+1 ) + ;

: DEC ( a -- a-1 ) - ;

: ADD ( a b -- a+b ) [-<+>]< ;

: SUB ( a b -- a-b ) [-<->]< ;

: MUL ( a b -- a*b ) < [-> [->+>+<<] >>[-<<+>>]<< <] >[-]>[-<<+>>]<< ;

: 2MUL ( a -- 2*a ) [->++<]>[-<+>]< ;

( logical words )

: NOT ( a -- !a ) >+< [>-<[-]] >[-<+>]< ;

: EQ ( a b -- a+b ) SUB NOT ;

( control flow words )

( The "IF...ENDIF" construct pops one value off the stack.
  The code inside the IF...ENDIF block is executed when this value is zero.

  The code inside the construct can do arbitrary stack manipulations, but
  IF...ENDIF assumes everything after cursor is null after the block code executes,
  as usual.

  The "IF...ELSE...ENDIF" behaves like "IF...ENDIF", but if the popped value
  is zero, it will execute the code in the "ELSE...ENDIF" block.
)
: IF [[-] < ;
: ELSE >>+<< >]< >> NOT [-<+>]<  IF ; 
: ENDIF > ]< ;

( "DO_..._WHILE" Executes the code inside the block, and pops a value off the
  stack when the control flow reaches WHILE, and if this value is not zero, it
  jumps back to DO.
)
: DO_ >>+[-<< ;
: _WHILE IF >>+<< ENDIF >> ] << ;

( complex words )
: POW ( b n -- b^n )
	       ( b n )
	1 SWAP ( b 1 n )
	DO_
                   ( b r n )
		     DEC   ( b r n-1 )
		     ROT   ( n-1 b r )
		OVER MUL   ( n-1 b r*b )
		     UNROT ( b r*b n-1 )
		     DUP   ( b r*b n-1 n-1 )
	_WHILE
	DROP     ( b r )
	SWAPDROP ( r )
;

: SATDEC DUP IF - ENDIF ;
: LT <[-> SATDEC <] >[-<+>]< ;


: DIV ( a b -- q r )
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
         ( n a b )
	DROP ( n a )
	     ( q r )
;

: 43 10 [->++++<] >[-<+>]<+++ ;

16 10 DIV ?2
2 4 POW ?
