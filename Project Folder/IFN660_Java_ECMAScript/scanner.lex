%namespace IFN660_Java_ECMAScript

digit 															[0-9_]
letter 															[$_a-zA-Z]
nonZeroDigit													[1-9]
digits															[0-9]+|([0-9]+[0-9_]+?[0-9]+)
decimalNumeral													0|(nonZeroDigit+digit?)|(nonZeroDigit+_+digits+)
hexDigit														[0-9a-fA-F]
hexNumeral														0x(hexDigit+|hexDigit+([hexDigit|_]+)?hexDigit+)
octalDigit														[0-7]
octalNumeral													(0|0[_]+)(octalDigit+|((octalDigit+((octalDigit|_)+)?)octalDigit+))
binaryDigit														[01]
binaryNumeral													0[bB](binaryDigit+|(binaryDigit+(binaryDigit|_)+?binaryDigit+))
%%

										/* 3.7 COMMENTS */
([/][*]([^*]|[\r\n]|([*]*([^*/]|[\r\n])))*[*]+[/])|("//".*)		{/* Comment */}

										/* 3.8 IDENTIFIERS */
{letter}({letter}|{digit})* 			{ yylval.name = yytext; return (int)Tokens.IDENT; }

{digit}+	    						{ yylval.num = int.Parse(yytext); return (int)Tokens.NUMBER; }

										/* 3.9 KEYWORDS */
abstract									{return (int)Tokens.ABSTRACT;}
assert										{return (int)Tokens.ASSERT;}
boolean										{return (int)Tokens.LEFT_PAREN;}
break										{return (int)Tokens.BREAK;}
byte										{return (int)Tokens.LEFT_PAREN;}
case										{return (int)Tokens.CASE;}
catch										{return (int)Tokens.CATCH;}
char										{return (int)Tokens.CHAR;}
class										{return (int)Tokens.CLASS;}
const										{return (int)Tokens.CONST;}
continue									{return (int)Tokens.CONTINUE;}
default										{return (int)Tokens.DEFAULT;}
do											{return (int)Tokens.DO;}
double										{return (int)Tokens.DOUBLE;}
else										{return (int)Tokens.ELSE;}
enum										{return (int)Tokens.ENUM;}
extends										{return (int)Tokens.EXTENDS;}
final										{return (int)Tokens.FINAL;}
finally										{return (int)Tokens.FINALLY;}
float										{return (int)Tokens.LEFT_PAREN;}
for											{return (int)Tokens.FOR;}
if											{return (int)Tokens.IF;}
goto										{return (int)Tokens.GOTO;}
implements									{return (int)Tokens.IMPLEMENTS;}
import										{return (int)Tokens.IMPORT;}
instanceof									{return (int)Tokens.INSTANCE_OF;}
int											{return (int)Tokens.INT;}
interface									{return (int)Tokens.INTERFACE;}
long										{return (int)Tokens.LONG;}
native										{return (int)Tokens.NATIVE;}
new											{return (int)Tokens.NEW;}
package										{return (int)Tokens.PACKAGE;}
private										{return (int)Tokens.PRIVATE;}
protected									{return (int)Tokens.PROTECTED;}
public										{return (int)Tokens.PUBLIC;}
return										{return (int)Tokens.RETURN;}
short										{return (int)Tokens.SHORT;}
static										{return (int)Tokens.STATIC;}
strictfp									{return (int)Tokens.STRICTFP;}
super										{return (int)Tokens.SUPER;}
switch										{return (int)Tokens.SWITCH;}
synchronized								{return (int)Tokens.SYNCHRONIZED;}
this										{return (int)Tokens.THIS;}
throw										{return (int)Tokens.THROW;}
throws										{return (int)Tokens.THROWS;}
transient									{return (int)Tokens.TRANSIENT;}
try											{return (int)Tokens.TRY;}
void										{return (int)Tokens.VOID;}
volatile									{return (int)Tokens.VOLATILE;}
while										{return (int)Tokens.WHILE;}
										/* 3.10 LITERALS */
/* Interger Literals */
decimalNumeral|hexNumeral|octalNumeral|binaryNumeral[lL]	{return INTERGER_LITERALS}
/* Floating-Point Literals */
(((([0-9]+.[0-9]*|.[0.9]+)([eE][+-]?[0-9]+)?)
|[0-9]+[eE][+-]?[0-9]+)([fFdD]?)|
[0-9]+([eE][+-]?[0-9]+)?[fFdD])
|((hexNumeral.?|[0][x]hexDigit?.hexDigit+)[pP][+-]?[0-9]+[fFdD]?)				{return FLOATING_POINT_LITERALS}
/* Boolean Literals */
true									{return LITERAL_TRUE}
false									{return LITERAL_FALSE}
/* String Literal */
\"(.|[^\\"])*\"							{return LITERAL_STRING}
/* Null Literal */
null									{return LITERAL_NULL}

										/* 3.11 SEPARATORS */
										
(										{return LEFT_PAREN;}	
)										{return RIGHT_PAREN;}	
{										{return LEFT_BRACE;}	
}										{return RIGHT_BRACE;}	
[										{return ASSIGNMENT;}	
]										{return RIGHT_BRACKET;}	
;										{return SEMICOLON;}	
,										{return COLON;}	
.										{return DOT;}	
...										{return ELLIPSIS;}	
@										{return AT;}	
::										{return DOUBLE_COLON;}	
										

										/* 3.12 OPERATOR */
										
=										{return ASSIGNMENT;}
>										{return GREATER_THAN;}
<										{return LESS_THAN;}

==										{return EQUAL;}
>=										{return GREATER_OR_EQUAL;}
<=										{return LESS_THAN_OR_EQUAL;}
!=										{return NOT_EQUAL;}

?										{return QUESTION_MARK;}
:										{return COLON;}
->										{return ARROW_TOKEN;}

&&										{return LOGICAL_AND;}
||										{return LOGICAL_OR;}
!										{return LOGICAL_NOT;}

++										{return INCREMENT;}
--										{return DECREMENT;}

+										{return ADDITION;}
-										{return SUBTRACTION;}
*										{return MULTIPLICATION;}
/										{return DIVISION;}
%										{return MODULO;}

&										{return BITWISE_AND;}
|										{return BITWISE_OR;}
^										{return BITWISE_XOR;}
~										{return BITWISE_COMPLIMENT;}

<<										{return LEFT_SHIFT;}
>>										{return SIGNED_RIGHT_SHIFT;}
>>>										{return UNSIGNED_RIGHT_SHIFT;}

+=										{return ADDITION_ASSIGNMENT;}
-=										{return SUBTRACTION_ASSIGNMENT;}
*=										{return MULTIPLICATION_ASSIGNMENT;}		
/=										{return DIVISION_ASSIGNMENT;}
%=										{return MODULUS_ASSIGNMENT;}
&=										{return BITWISE_AND_ASSIGNMENT;}
|=										{return BITWISE_OR_ASSIGNMENT;}
^=										{return BITWISE_XOR_ASSIGNMENT;}
<<=										{return LEFT_SHIFT_ASSIGNMENT;}
>>=										{return UNSIGNED_RIGHT_SHIFT_ASSIGNMENT;}
>>>=									{return SIGNED_RIGHT_SHIFT_ASSIGNMENT;}

[ \r\n\tSPHTFF]                    			/* skip whitespace */

.                            			{ 
											throw new Exception(
												String.Format(
													"unexpected character '{0}'", yytext)); 
										}



%%
