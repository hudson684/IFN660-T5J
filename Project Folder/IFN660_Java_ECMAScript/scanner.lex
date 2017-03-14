%namespace IFN660_Java_ECMAScript
// Nathan - Senha - An
HexDigit									[0-9a-fA-F]
Digit 										[0-9_]
OctalDigit									[0-7]
ZeroToThree									[0-3]
NonZeroDigit								[1-9]
BinaryDigit									[0-1]
Letter 										[$_a-zA-Z]

// Nathan - Sneha - An
IntSuffix									[lL]
Digits										[0-9]+([0-9_]+)?[0-9]+
DecimalNumeral								0|{NonZeroDigit}+({Digits}?|[\_]+{Digits}+)
HexNumeral									0[xX]({HexDigit}+([{HexDigit}|_]+)?{HexDigit}+)
OctalDigits									{OctalDigit}+((({OctalDigit}|_)+)?){OctalDigit}*
OctalNumeral								0([\_]+({OctalDigits}+|{OctalDigits}))
BinaryNumeral								0[bB]([01]+|([01]+([01]|_)+)?[01]+)
IntergerLiteral								({DecimalNumeral}|{HexNumeral}|{OctalNumeral}|{BinaryNumeral}){IntSuffix}?

// An - Sneha -fixed bug
E											[eE][+-]?{Digit}+
FloatSuffix									[fFdD]
Float1										(({Digit}+.{Digit}*|.{Digit}+)({E})?){FloatSuffix}?
Float2										{Digit}+{E}{FloatSuffix}?
Float3										{Digit}+{E}?{FloatSuffix}					
DecimalFloatingPointLiteral					({Float1}|{Float2}|{Float3})
HexFloatingPointLiteral						({HexNumeral}[\.]?|[0][x]{HexDigit}?[\.]{HexDigit}+)[pP][+-]?{Digit}+{FloatSuffix}?
FloatingPoint								({DecimalFloatingPointLiteral}|{HexFloatingPointLiteral})
BooleanLiteral								"true"|"false"	

// Tri
OctalEscape									(\\)({OctalDigit}|{OctalDigit}{OctalDigit}|{ZeroToThree}{OctalDigit}{OctalDigit})
EscapeSequence								{OctalEscape}|(\\)([r]|[n]|[b]|[f]|[t]|[\\]|[\']|[\"])

//3.3 Deffinition - Joshua & Vivian
UnicodeEscape								(\\[u]{HexDigit}{4})

//Tri
CharacterLiteral							\'({EscapeSequence}|[^\\'])\'								
StringLiteral								\"({EscapeSequence}|[^\\"])*\"

// An
Numberic									({IntergerLiteral}|{FloatingPoint})
Character									\'(.|EscapeSequence|[^\\'])*\'
String										\"(.|EscapeSequence|[^\\"])*\"
//Changed to NullLiteral to fit Oracle Documentation - Josh
NullLiteral									"null"
Literals									({Numberic}|{Character}|{String}|{BooleanLiteral}|{NullLiteral})

// An
Separator									[\(\)\{\}\[\]\;\,\.\@]
Delimiter									[\=\>\<\!\~\?\:\+\-\*\/\&\|\^\%]

// Sneha
BinaryDigits								{BinaryDigit}((({BinaryDigit}|_)+)?){BinaryDigit}	



%%

										/* 3.3 Unicode Escapes -  Joshua Hudson &  Vivian Lee */
\\  /* IGNORE */
\" /* IGNORE */
\*u{HexDigit}{4}									{return (int)Tokens.UNICODE_INPUT_CHAR;}
{UnicodeEscape}										{return (int)Tokens.UNICODE_ESCAPE;}
u{HexDigit}{4}										{return (int)Tokens.UNICODE_RAW_INPUT;}
{HexDigit}											{return (int)Tokens.HEXDIGIT;}
u+													{return (int)Tokens.UNICODE_MARKER;}

										/* 3.4  Line Terminators - Joshua Hudson &  Vivian Lee */
[\n|\r|\r\n]							/* skip whitespace */
//catches someone typing in /n in string form ect - Ask Wayne - Josh
//[\\n|\\r|\\r\\n]						{return (int)Tokens.LINE_TERMINATOR; }


										/* 3.6 Whitespace*/
[ \r\n\t\f]                  						/* skip whitespace */

										/* 3.7 Comments - Nathan & Sneha */
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/		/* skip multiline comments */
\/\/[^\n]*                						/* skip the line comment  */

										/* 3.9 KEYWORDS An */
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

										/* 3.10 LITERALS An */
										
// Literals									{return (int)Tokens.LITERALS;}

										/* 3.10.1 - Integer Literals */
// Decimals -Nathan
(({NonZeroDigit}({Digit}|"_")*{Digit}+)|{Digit})[lL]?  				{ yylval.name = yytext; return (int)Tokens.DecimalIntegerLiteral; }

// Hexadecimals - Nathan
0[xX](({HexDigit}({HexDigit}|"_")*{HexDigit}+)|{HexDigit})[lL]?  	{ yylval.name = yytext; return (int)Tokens.HexIntegerLiteral; }

//OctalNumerals - Sneha
0({OctalDigits}|[\_]+{OctalDigits})[lL]?  							{yylval.name = yytext; return (int)Tokens.OctalIntegerLiteral; }

//Binary numerals - Sneha
0[bB]{BinaryDigits}[lL]?											{yylval.name = yytext; return (int)Tokens.BinaryIntegerLiteral; }

										/* 3.10.2 FloatingPoint Literal - Adon*/
{DecimalFloatingPointLiteral}			{yylval.name = yytext; return (int)Tokens.DecimalFloatingPointLiteral;}
{HexFloatingPointLiteral}			{yylval.name = yytext; return (int)Tokens.HexFloatingPointLiteral;}

										/* 3.10.3 Boolean Literal - Vivan*/
{BooleanLiteral}						{yylval.name = yytext; return (int)Tokens.BooleanLiteral;}

										/* 3.10.4 Character Literal - Tri*/
{CharacterLiteral}						{yylval.name = yytext; return (int)Tokens.CHARACTER_LITERAL;}

										/* 3.10.5 String Literal - Tri*/
{StringLiteral}							{yylval.name = yytext; return (int)Tokens.STRING_LITERAL;}

										/* 3.10.6 Escape sequences for Character and String Literals - Tri*/
{OctalEscape}							{yylval.name = yytext; return (int)Tokens.OCTAL_ESCAPE;}
{EscapeSequence}						{yylval.name = yytext; return (int)Tokens.ESCAPE_SEQUENCE;}

										/* 3.10.7 Null Literal - Joshua*/
{NullLiteral}							{return (int)Tokens.NullLiteral;}

										/* 3.11 SEPARATORS  - An */	
{Separator}									{return yytext[0];}
"..."										{return (int)Tokens.ELLIPSIS;}	
"::"										{return (int)Tokens.DOUBLE_COLON;}	
										

										/* 3.12 OPERATOR  - An */

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
{Letter}({Letter}|{Digit})* 			{ yylval.name = yytext; return (int)Tokens.IDENT; }

{Digit}+	    						{ yylval.num = int.Parse(yytext); return (int)Tokens.NUMBER; }
			

.                            			{ 
											throw new Exception(
												String.Format(
													"unexpected character '{0}'", yytext)); 
										}
										
%%
