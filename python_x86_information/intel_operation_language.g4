grammar intel_operation_language;

prog
	: expression* EOF
	;

expression
	: INT
	| ifExpression
	| forExpression
	| doWhileExpression
	| functionExpression
	| ternaryoperator
	| variable
	| operator
	| ( LeftParen expression+ RightParen )
	| definitionExpression
	;

definitionExpression
    : variable Assign expression+
    ;

/*
	(A > B ? C : D)
	: LeftParen EXPRESSION OPERATOR EXPRESSION Question EXPRESSION Colon EXPRESSION RightParen
*/
ternaryoperator
	: ( LeftParen comparison Question expression Colon expression RightParen )
	| ( LeftParen comparison RightParen Question expression Colon expression )
	| ( comparison Question expression Colon expression )
	;

/*
IF a == 1
    bla
ELSE
    bla2
FI
*/
ifExpression
    : (IF comparison expression+ ( ELSE expression+ )? FI )
    ;

/*
FOR definition to UpperBouhd
    expressions*
ENDFOR
*/
forExpression
    : FOR definitionExpression ( TO | TO2 ) expression forExpressionExpression+ ENDFOR
    ;

forExpressionExpression
    : expression
    ;

/*
    DO WHILE (a := 1)

    OD
*/
doWhileExpression
    : DO WHILE LeftParen (expression)+ RightParen doWhileExpressionExpression+ OD
    ;

doWhileExpressionExpression
    : expression
    ;

/*
    BLA()
    BLA(foo)
    BLA(foo, bar)
*/
functionExpression
    : ( NAME INT?)  LeftParen ( functionExpressionArgument )* RightParen
    ;

functionExpressionArgument
    :  expression Comma?
    ;


comparison
	: ( variable | INT ) operator ( variable | INT )
	;


/*
    foo.bar
*/
variable
	: NAME+ accessoperator? ( Dot variable )?
	;


/* Memory/Bit Accessors: (ONLY THE ACCESSORS, NOT `tmp`)
	tmp[31:0]
	tmp[0]
	tmp[out+32: 32]
	tmp[out+32: out+0]
*/
accessoperator
	: '[' accessoperatorname+ ( ':' accessoperatorname+ )?']'
	;

accessoperatorname
	: ( variable | INT )
	| ( Plus | Star )
	;
/*
accessoperatorname
	: NAME Plus (NAME | INT)
	| (NAME | INT)+
	;
*/

operator
	: Plus | Minus | Equal | Star | Div | Mod
	| Less | Greater | EqualEqual | (Less Equal) | (Greater Equal)
	| And | Or | Not
	| XOR | AND
	| AndAnd | MinusMinus
	;


LeftParen : '(';
RightParen : ')';
Question : '?';
Colon : ':';
Comma : ',';
Dot : '.';
Assign : ':=';
Equal : '=';
EqualEqual : '==';
Plus : '+';
PlusPlus : '++';
Minus : '-';
MinusMinus : '--';
Star : '*';
Div : '/';
Mod : '%';
And : '&';
Or : '|';
AndAnd : '&&';
OrOr : '||';
Caret : '^';
XOR : 'XOR';
AND : 'AND';
Not : '!';
Tilde : '~';
Less : '<';
LessEqual : '<=';
Greater : '>';
GreaterEqual : '>=';
LeftShift : '<<';
RightShift : '>>';
IF : 'IF';
FI : 'FI';
ELSE : 'ELSE';
FOR : 'FOR';
TO : 'to';
TO2 : 'TO';
ENDFOR : 'ENDFOR';
DO : 'DO';
WHILE : 'WHILE';
OD : 'OD';


NAME
    :   IdentifierNondigit
        (   IdentifierNondigit
        |   Digit
        )*
    ;

fragment
IdentifierNondigit
    :   Nondigit
    |   UniversalCharacterName
    //|   // other implementation-defined characters...
    ;

fragment
Nondigit
    :   [a-zA-Z_]
    ;

fragment
Digit
    :   [0-9]
    ;

fragment
UniversalCharacterName
    :   '\\u' HexQuad
    |   '\\U' HexQuad HexQuad
    ;

fragment
HexQuad
    :   HexadecimalDigit HexadecimalDigit HexadecimalDigit HexadecimalDigit
    ;

fragment
BinaryConstant
	:	'0' [bB] [0-1]+
	;

fragment
OctalConstant
    :   '0' OctalDigit*
    ;

fragment
HexadecimalConstant
    :   HexadecimalPrefix HexadecimalDigit+
    ;

fragment
HexadecimalPrefix
    :   '0' [xX]
    ;

fragment
OctalDigit
    :   [0-7]
    ;

fragment
HexadecimalDigit
    :   [0-9a-fA-F]
    ;

/*
NAME
	: [a-zA-Z]+
	;
*/

INT
	: ([0-9]+
	| HexadecimalConstant
	)
	;

LineComment
    :   '//' ~[\r\n]*
        -> skip
    ;

WS
	: [ \n\t\r]+
	    -> channel(HIDDEN)
	;
