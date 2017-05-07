%namespace IFN660_Java_ECMAScript

%{
int lines = 0;
%}

/* Literal definitions */
// Nathan - Senha - An
HexDigit									[0-9a-fA-F]
Digit 										[0-9] // Nathan removed "_"
OctalDigit									[0-7]
ZeroToThree									[0-3]
NonZeroDigit								[1-9]
BinaryDigit									[0-1]
Letter 										[$_a-zA-Z]

// Nathan - Sneha - An - Adon - Nathan-updated to match Java spec
IntegerTypeSuffix							[lL]
Underscores									\_+
Digits										{Digit}|{Digit}([0-9_]*){Digit}
DecimalNumeral								0|{NonZeroDigit}{Digits}?|{NonZeroDigit}{Underscores}{Digits}
HexDigitOrUnderscore						{HexDigit}|_
HexDigitsAndUnderscores						{HexDigitOrUnderscore}+
HexDigits									{HexDigit}|{HexDigit}{HexDigitsAndUnderscores}?{HexDigit}
HexNumeral									0[xX]{HexDigits}
OctalDigits									{OctalDigit}|{OctalDigit}([0-7_]*){OctalDigit}
OctalNumeral								0{Underscores}?{OctalDigits}
BinaryDigits								{BinaryDigit}|{BinaryDigit}([01_]*){BinaryDigit} 
BinaryNumeral								0[bB]{BinaryDigits}
IntegerLiteral								({DecimalNumeral}|{HexNumeral}|{OctalNumeral}|{BinaryNumeral}){IntegerTypeSuffix}?

// An - Sneha - Adon-fixed bug - Nathan-updated to match Java spec
FloatTypeSuffix								[fFdD]
SignedInteger								[\+\-]?{Digits}
ExponentIndicator							[eE]
ExponentPart								{ExponentIndicator}{SignedInteger}
Float1										{Digits}\.{Digits}?{ExponentPart}?{FloatTypeSuffix}?
Float2										\.{Digits}{ExponentPart}?{FloatTypeSuffix}?
Float3										{Digits}{ExponentPart}{FloatTypeSuffix}?
Float4										{Digits}{ExponentPart}?{FloatTypeSuffix}					
DecimalFloatingPointLiteral					({Float1}|{Float2}|{Float3}|{Float4})
BinaryExponentIndicator						[pP]
BinaryExponent								{BinaryExponentIndicator}{SignedInteger}
HexSignificand								({HexNumeral}\.?)|(0[xX]{HexDigits}?\.{HexDigits})
HexFloatingPointLiteral						{HexSignificand}{BinaryExponent}{FloatTypeSuffix}?
FloatingPointLiteral						{DecimalFloatingPointLiteral}|{HexFloatingPointLiteral}
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
Numberic									({IntegerLiteral}|{FloatingPointLiteral})
Character									\'(.|EscapeSequence|[^\\'])*\'
String										\"(.|EscapeSequence|[^\\"])*\"
//Changed to NullLiteral to fit Oracle Documentation - Josh
NullLiteral									"null"
Literals									({Numberic}|{Character}|{String}|{BooleanLiteral}|{NullLiteral})

// An
Separator									[\(\)\{\}\[\]\;\,\.\@]
Delimiter									[\=\>\<\!\~\?\:\+\-\*\/\&\|\^\%]

%%
[\n]		{ lines++;    }
/* 3.4  Line Terminators - Joshua Hudson &  Vivian Lee */
\n|\r|\n\r								/* skip whitespace */
//catches someone typing in /n in string form ect - Ask Wayne - Josh
//[\\n|\\r|\\r\\n]						{return (int)Tokens.LINE_TERMINATOR; }

/* 3.7 Comments - Nathan & Sneha */
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/		/* skip multiline comments */
\/\/[^\n]*                						/* skip the line comment  */

/* 3.9 KEYWORDS An */
abstract									{return (int)Tokens.ABSTRACT;}
assert										{return (int)Tokens.ASSERT;}
bool										{return (int)Tokens.BOOLEAN;}
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
instanceof									{return (int)Tokens.INSTANCEOF;}
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

/* 3.10.1 - Integer Literals - Nathan and Sneha */
// Decimals -Nathan
{IntegerLiteral}							{ yylval.name = yytext; return (int)Tokens.IntegerLiteral; }

/* 3.10.2 FloatingPoint Literal - Adon*/
{FloatingPointLiteral}						{yylval.name = yytext; return (int)Tokens.FloatingPointLiteral;}

/* 3.10.3 Boolean Literal - Vivan*/
{BooleanLiteral}							{yylval.name = yytext; return (int)Tokens.BooleanLiteral;}

/* 3.10.4 Character Literal - Tri*/
{CharacterLiteral}							{yylval.name = yytext; return (int)Tokens.CharacterLiteral;}

/* 3.10.5 String Literal - Tri*/
{StringLiteral}								{yylval.name = yytext; return (int)Tokens.StringLiteral;}

/* 3.10.6 Escape sequences for Character and String Literals - Tri*/
//{OctalEscape}								{yylval.name = yytext; return (int)Tokens.OCTAL_ESCAPE;}
//{EscapeSequence}							{yylval.name = yytext; return (int)Tokens.ESCAPE_SEQUENCE;}

/* 3.10.7 Null Literal - Joshua*/
{NullLiteral}								{return (int)Tokens.NullLiteral;}

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


{Letter}({Letter}|{Digit})* { yylval.name = yytext; return (int)Tokens.IDENTIFIER; }
{Digit}+	    { yylval.num = int.Parse(yytext); return (int)Tokens.NUMBER; }




.                            { 
                                 throw new Exception(
                                     String.Format(
                                         "unexpected character '{0}'", yytext)); 
                             }

%%
public override void yyerror( string format, params object[] args )
{
    System.Console.Error.WriteLine("Error: line {0}, {1}", lines,
        String.Format(format, args));
}