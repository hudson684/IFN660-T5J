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
abstract									{return ABSTRACT;}
assert										{return ASSERT;}
boolean										{return LEFT_PAREN;}
break										{return BREAK;}
byte										{return LEFT_PAREN;}
case										{return CASE;}
catch										{return CATCH;}
char										{return LEFT_PAREN;}
class										{return CLASS;}
const										{return CONST;}
continue									{return CONTINUE;}
default										{return DEFAULT;}
do											{return DO;}
double										{return LEFT_PAREN;}
else										{return ELSE;}
enum										{return ENUM;}
extends										{return EXTENDS;}
final										{return FINAL;}
finally										{return FINALLY;}
float										{return LEFT_PAREN;}
for											{return FOR;}
if											{return IF;}
goto										{return GOTO;}
implements									{return IMPLEMENTS;}
import										{return IMPORT;}
instanceof									{return INSTANCE_OF;}
int											{return LEFT_PAREN;}
interface									{return INTERFACE;}
long										{return LEFT_PAREN;}
native										{return NATIVE;}
new											{return NEW;}
package										{return PACKAGE;}
private										{return PRIVATE;}
protected									{return PROTECTED;}
public										{return PUBLIC;}
return										{return RETURN;}
short										{return LEFT_PAREN;}
static										{return STATIC;}
strictfp									{return STRICTFP;}
super										{return SUPER;}
switch										{return SWITCH;}
synchronized								{return SYNCHRONIZED;}
this										{return THIS;}
throw										{return THROW;}
throws										{return THROWS;}
transient									{return TRANSIENT;}
try											{return TRY;}
void										{return VOID;}
volatile									{return VOLATILE;}
while										{return WHILE;}
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
