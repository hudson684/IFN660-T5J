%namespace IFN660_Java_ECMAScript

HexDigit									[0-9a-fA-F]
Digit 										[0-9] // Nathan removed "_"
OctalDigit									[0-7]
ZeroToThree									[0-3]
NonZeroDigit								[1-9]
BinaryDigit									[0-1]
Letter 										[$_a-zA-Z]

LF											\n
CR											\r
SP											" "
HT											\t
FF											\f

/* 3.3 Unicode Escapes -  Joshua Hudson &  Vivian Lee */
RawInputCharacter							\w
UnicodeMaker								u+
UnicodeEscape								\\{UnicodeMaker}{HexDigit}{4}
UnicodeInputCharacter						{UnicodeEscape}|{RawInputCharacter}

/* 3.4  Line Terminators - Joshua Hudson &  Vivian Lee */
LineTerminator								{CR}{LF}?|{LF}
InputCharacter								{UnicodeInputCharacter}|^\r|^\n]

/* 3.6 White Space */
WhiteSpace									{SP}|{HT}|{FF}|{LineTerminator}

/* 3.7 Comments */
NotStar										{InputCharacter}|[^*]
NotStarNotSlash								([^*/]|{LineTerminator})
CommentTaiStar								(\**{NotStarNotSlash})
CommentTail									(\*{CommentTaiStar}|{NotStar})*
TraditionalComment							/\*{CommentTail}\*+\/						
EndOfLineComment 							"//".*
Comment										{TraditionalComment}|{EndOfLineComment}

/* 3.8 Identifiers */
JavaLetter									[$_a-zA-Z]
JavaLetterOrDigit							{JavaLetter}|[0-9]
IdentifierChars								{JavaLetter}{JavaLetterOrDigit}*
Identifier									{IdentifierChars}

/* 3.9 Keywords */
Keyword										abstract|assert|boolean|break|byte|case|catch|char|class|const|continue|default|do|double|else|enum|extends|final|finally|float|for|if|goto|implements|import|instanceof|int|interface|long|native|new|package|private|protected|public|return|short|static|strictfp|super|switch|synchronized|this|throw|throws|transient|try|void|volatile|while

/* 3.10.1 Integer Literals */
/* DecimalNumeral */
Underscores									\_+
DigitOrUnderscore							[0-9_]
DigitsAndUnderscores						{DigitOrUnderscore}+
Digits										{Digit}|{Digit}{DigitsAndUnderscores}?{Digit}
DecimalNumeral								0|{NonZeroDigit}{Digits}?|{NonZeroDigit}{Underscores}{Digits}

/* HexNumeral */
HexDigitOrUnderscore						{HexDigit}|\_	
HexDigitsAndUnderscores						{HexDigitOrUnderscore}+	
HexDigits									{HexDigit}|{HexDigit}{HexDigitsAndUnderscores}?{HexDigit}
HexNumeral									0[xX]{HexDigits}

/* OctalNumeral */
OctalDigitOrUnderscore						{OctalDigit}|\_		
OctalDigitsAndUnderscores					{OctalDigitOrUnderscore}+
OctalDigits									{OctalDigit}|{OctalDigit}{OctalDigitsAndUnderscores}?{OctalDigit}
OctalNumeral								0{OctalDigits}|{Underscores}{OctalDigits}

/* BinaryNumeral */
BinaryDigitOrUnderscore						{BinaryDigit}|\_
BinaryDigitsAndUnderscores					{BinaryDigitOrUnderscore}+
BinaryDigits								{BinaryDigit}|({BinaryDigit}{BinaryDigitsAndUnderscores}{BinaryDigit})
BinaryNumeral								0[bB]{BinaryDigits}

IntegerTypeSuffix							[lL]
DecimalIntegerLiteral						{DecimalNumeral}{IntegerTypeSuffix}?
HexIntegerLiteral							{HexNumeral}{IntegerTypeSuffix}?
OctalIntegerLiteral							{OctalNumeral}{IntegerTypeSuffix}?
BinaryIntegerLiteral						{BinaryNumeral}{IntegerTypeSuffix}?
IntergerLiteral								{DecimalIntegerLiteral}|{HexIntegerLiteral}|{OctalIntegerLiteral}|{BinaryIntegerLiteral}

/* 3.10.2 Floating-Point Literals */
/* DecimalFloatingPointLiteral */
FloatTypeSuffix								[fFdD]
Sign										[+-]
SignedInteger								{Sign}?{Digits}
ExponentIndicator							[eE]
ExponentPart								{ExponentIndicator}{SignedInteger}
DecimalFloatingPointLiteral					({Digits}\.{Digits}?|\.{Digits}){ExponentPart}?{FloatTypeSuffix}?|{Digits}{ExponentPart}{FloatTypeSuffix}?|{Digits}{ExponentPart}?{FloatTypeSuffix}

/* HexadecimalFloatingPointLiteral */
BinaryExponentIndicator						[pP]
BinaryExponent								{BinaryExponentIndicator}{SignedInteger}
HexSignificand								{HexNumeral}\.?|0[xX]{HexDigits}?\.{HexDigits}
HexadecimalFloatingPointLiteral				{HexSignificand}{BinaryExponent}{FloatTypeSuffix}?

FloatingPointLiteral						{DecimalFloatingPointLiteral}|{HexadecimalFloatingPointLiteral}

/* 3.10.3 Boolean Literals */
BooleanLiteral								true|false

/* 3.10.6 */
OctalEscape									\\({OctalDigit}|{OctalDigit}{OctalDigit}|{ZeroToThree}{OctalDigit}{OctalDigit})
EscapeSequence								{OctalEscape}|\\[rnbft\\\'\"]

/* 3.10.4 Character Literals */
SingleCharacter								{InputCharacter}|[^\\']
CharacterLiteral							\'{SingleCharacter}\'|\'{EscapeSequence}\'

/* 3.10.5 String Literals */
StringCharacter								{InputCharacter}|[^\\"]|{EscapeSequence}
StringLiteral								\"{StringCharacter}*\"

/* 3.10.7 The Null Literal */
NullLiteral									"null"

/* 3.10 Literals */
Literal										({IntergerLiteral}|{FloatingPointLiteral}|{CharacterLiteral}|{StringLiteral}|{BooleanLiteral}|{NullLiteral})

/* 3.11 Separators */
Separator									[\(\)\{\}\[\]\;\,\.\@]

/* 3.12 Operators */
Delimiter									[\=\>\<\!\~\?\:\+\-\*\/\&\|\^\%]
%%

										/* 3.3 Unicode Escapes */
{UnicodeInputCharacter}						{yylval.name = yytext;return (int)Tokens.UnicodeInputCharacter;}
										/* 3.4 Line Terminators */
{LineTerminator}							/* Line Terminator */
										/* 3.6 WhiteSpace */
{WhiteSpace}								/* White space */
										/* 3.7 Comment */
{Comment}									/* Comment */
										/* 3.9 KEYWORDS An */


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
//{Literal}										{return (int)Tokens.LITERAL;}

/* 3.10.1 - Integer Literals - Nathan and Sneha */
// Decimals - Nathan
{DecimalIntegerLiteral}							{	string inString;
													int outInt;
													long outLong;
													inString = yytext;
													inString = inString.ToUpper().Replace("_","");
													if (inString.EndsWith("L"))
													{
														inString = inString.TrimEnd('L');
														outLong = Convert.ToInt64(inString);
														yylval.num = outLong; 
													}
													else
													{
														outInt = Convert.ToInt32(inString);
														yylval.num = outInt;
													}
													return (int)Tokens.IntegerLiteral; 
												}
// Hexadecimals - Nathan
{HexIntegerLiteral}								{	inString = yytext;
													inString = inString.ToUpper().Replace("_","").TrimStart('0','X');
													if (inString.EndsWith("L"))
													{
														inString = inString.TrimEnd('L');
														outLong = Convert.ToInt64(inString, 16);
														yylval.num = outLong; 
													}
													else
													{
														outInt = Convert.ToInt32(inString, 16);
														yylval.num = outInt;
													}
													return (int)Tokens.IntegerLiteral;
												 }
// Octals - Sneha
{OctalIntegerLiteral}							{	inString = yytext;
													inString = inString.ToUpper().Replace("_","");
													if(inString.EndsWith("L"))
													{
														inString = inString.TrimEnd('L');
														outLong = Convert.ToInt64(inString,8);
														yylval.num = outLong;
													}else{
														outInt = Convert.ToInt32(inString,8);
														yylval.num = outInt;
													}
													return (int)Tokens.IntegerLiteral;
												}
// Binarys - Sneha
{BinaryIntegerLiteral}							{	inString = yytext;
													inString = inString.ToUpper().Replace("_","").TrimStart('0','B');
													if (inString.EndsWith("L"))
													{
														inString = inString.TrimEnd('L');
														outLong = Convert.ToInt64(inString, 2);
														yylval.num = outLong; 
													}
													else
													{
														outInt = Convert.ToInt32(inString, 2);
														yylval.num = outInt;
													}
													return (int)Tokens.IntegerLiteral; 
												}

/* 3.10.2 FloatingPoint Literal - Adon*/
{FloatingPointLiteral}						{yylval.name = yytext;return (int)Tokens.FloatingPointLiteral;}

/* 3.10.3 Boolean Literal - Vivan*/
{BooleanLiteral}							{return (int)Tokens.BooleanLiteral;}

/* 3.10.4 Character Literal - Tri*/
{CharacterLiteral}							{yylval.name = yytext; return (int)Tokens.CharacterLiteral;}

/* 3.10.5 String Literal - Tri*/
{StringLiteral}								{yylval.name = yytext; return (int)Tokens.StringLiteral;}

/* 3.10.6 Escape sequences for Character and String Literals - Tri*/
{EscapeSequence}							{yylval.name = yytext; return (int)Tokens.EscapeSequence;}

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

/* 3.8 IDENTIFIERS */
{Identifier} 			{ yylval.name = yytext; return (int)Tokens.IDENT; }

.                            			{ 
											throw new Exception(
												String.Format(
													"unexpected character '{0}'", yytext)); 
										}
										
%%
