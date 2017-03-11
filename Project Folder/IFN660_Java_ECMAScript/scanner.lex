%namespace IFN660_Java_ECMAScript

HexDigit									[0-9a-fA-F]
Digit 										[0-9_]
OctalDigit									[0-7]
TetraDigit									[0-3]
NonZeroDigit								[1-9]
Letter 										[$_a-zA-Z]

IntSuffix									[lL]
Digits										[0-9]+([0-9_]+)?[0-9]+)
DecinalNumeral								0|{NonZeroDigit}+({Digits}?|[\_]+{Digits}+)
HexNumeral									0[xX]({HexDigit}+([{HexDigit}|_]+)?{HexDigit}+)
OctalDigits									{OctalDigit}+((({octalDigit}|_)+)?){octalDigit}*
OctalNumeral								0([\_]+({OctalDigits}+|{OctalDigits})
BinaryNumeral								0[bB]([01]+|([01]+([01]|_)+)?[01]+)
IntergerLiteral								({DecimalNumeral}|{HexNumeral}|{OctalNumeral}|{BinaryNumeral}){IntSuffix}?

E											[eE][+-]?{digit}+
FloatSuffix									[fFdD]
Float1										(({Digit}+.{Digit}*|.{Digit}+)({E})?){FloatSuffix}?
Float2										{Digit}+{E}{FloatSuffix}?
Float3										{Digit}+{E}?{FloatSuffix}					
DecimalFloatingPointLiteral					({Float1}|{Float2}|{Float3})
HexFloatingPointLiteral						({hexNumeral}[\.]?|[0][x]{HexDigit}?[\.]{HexDigit}+)[pP][+-]?{Digit}+{FloatSuffix}?)
FloatingPoint								({DecimalFloatingPointLiteral}|{HexFloatingPointLiteral})

BooleanLiteral								"true"|"false"	

OctalEscape									\\(?:[1-7][0-7]{0,2}|[0-7]{2,3})
EscapeSequence								[\\]([r]|[n]|[b]|[f]|[t]|[\\]|[\']|[\"]|{OctalEscape})

Numberic									({IntergerLiteral}|{FloatingPoint})
Character									\'(.|EscapeSequence|[^\\'])*\'
String										\"(.|EscapeSequence|[^\\"])*\"
Null										"null"

Literals										({Numberic}|{Character}|{String}|{BooleanLiteral}|{Null})

Separator									[\(\)\{\}\[\]\;\,\.\@]
Delimiter									[\=\>\<\!\~\?\:\+\-\*\/\&\|\^\%]

%%
										/* 3.7 COMMENTS */
([/][*]([^*]|[\r\n]|([*]*([^*/]|[\r\n])))*[*]+[/])|("//".*)		{/* Comment */}

										/* 3.9 KEYWORDS */
abstract									{return (int)Tokens.ABSTRACT;}
assert										{return (int)Tokens.ASSERT;}
boolean										{return (int)Tokens.BOOLEAN;}
break										{return (int)Tokens.BREAK;}
byte										{return (int)Tokens.BYTE;}
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
float										{return (int)Tokens.FLOAT;}
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
										
Literals									{return (int)Tokens.LITERALS}

										/* 3.11 SEPARATORS */
										
Separator									{return yytext[0];}
"..."										{return (int)Tokens.ELLIPSIS;}	
"::"										{return (int)Tokens.DOUBLE_COLON;}	
										

										/* 3.12 OPERATOR */

{Delimiter}									{return yytext[0];}
"=="										{return (int)Tokens.EQUAL;}
">="										{return (int)Tokens.GREATER_OR_EQUAL;}
"<="										{return (int)Tokens.LESS_THAN_OR_EQUAL;}
"!="										{return (int)Tokens.NOT_EQUAL;}

"->"										{return (int)Tokens.ARROW;}
"&&"										{return (int)Tokens.LOGICAL_AND;}
"||"										{return (int)Tokens.LOGICAL_OR;}

"++"										{return (int)Tokens.INCREMENT;}
"--"										{return (int)Tokens.DECREMENT;}

"<<"										{return (int)Tokens.LEFT_SHIFT;}
">>"										{return (int)Tokens.SIGNED_RIGHT_SHIFT;}
">>>"										{return (int)Tokens.UNSIGNED_RIGHT_SHIFT;}

"+="										{return (int)Tokens.ADDITION_ASSIGNMENT;}
"-="										{return (int)Tokens.SUBTRACTION_ASSIGNMENT;}
"*="										{return (int)Tokens.MULTIPLICATION_ASSIGNMENT;}		
"/="										{return (int)Tokens.DIVISION_ASSIGNMENT;}
"%="										{return (int)Tokens.MODULUS_ASSIGNMENT;}
"&="										{return (int)Tokens.BITWISE_AND_ASSIGNMENT;}
"|="										{return (int)Tokens.BITWISE_OR_ASSIGNMENT;}
"^="										{return (int)Tokens.BITWISE_XOR_ASSIGNMENT;}
"<<="										{return (int)Tokens.LEFT_SHIFT_ASSIGNMENT;}
">>="										{return (int)Tokens.UNSIGNED_RIGHT_SHIFT_ASSIGNMENT;}
">>>="										{return (int)Tokens.SIGNED_RIGHT_SHIFT_ASSIGNMENT;}

/* 3.8 IDENTIFIERS */
{letter}({letter}|{digit})* 			{ yylval.name = yytext; return (int)Tokens.IDENT; }

{digit}+	    						{ yylval.num = int.Parse(yytext); return (int)Tokens.NUMBER; }

[ \r\n\t\f\b]                    			/* skip whitespace */

			

.                            			{ 
											throw new Exception(
												String.Format(
													"unexpected character '{0}'", yytext)); 
										}



%%
