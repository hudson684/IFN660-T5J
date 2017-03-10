﻿%namespace IFN660_Java_ECMAScript

digit 										[0-9_]
letter 										[$_a-zA-Z]
E											[eE][+-]?{digit}+
LT											(LF|CR)LF?
nonZeroDigit								[1-9]
digits										[0-9]+|(([0-9]+[0-9_]+)?[0-9]+)
decimalNumeral								0|({nonZeroDigit}+{digit}+)|({nonZeroDigit}+_+{digits}+)
hexDigit									[0-9a-fA-F]
hexNumeral									0x({hexDigit}+([{hexDigit}|_]+)?{hexDigit}+)
octalDigit									[0-7]
octalNumeral								(0|0[_]+)({octalDigit}+|(({octalDigit}+(({octalDigit}|_)+)?){octalDigit}+))
binaryDigit									[01]
binaryNumeral								0[bB]({binaryDigit}+|({binaryDigit}+({binaryDigit}|_)+)?{binaryDigit}+)
FS											[fFdD]
IS											[lL]

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
/* Interger Literals */
({decimalNumeral}|{hexNumeral}|{octalNumeral}|{binaryNumeral})[lL]?	{return (int)Tokens.INTERGER_LITERALS;}

/* Floating-Point Literals 
(({D}+.{D}*|.{D}+)({E})?)|({D}+{E})({FS}?)|{D}+({E})?{FS})|((hexNumeral.?|[0][x]{H}?.{H}+)[pP][+-]?{D}+{FS}?)				{return FLOATING_POINT_LITERALS;}*/

/* Boolean Literals */
"true"|"false"								{return (int)Tokens.BOOLEAN_LITERALS;}

/* Character Literals 
\'(\\.|[^\\'{LF}])*\'						{return (int)Tokens.LITERAL_CHARACTER;}*/

/* String Literal 
\"(.|[^\\"])*\"								{return (int)Tokens.LITERAL_STRING;}*/

/* Escape Sequences 
\"[btnfr"'\]|[u000-u00ff]|[[1-3]?octalDigit?octalDigit+]"	{return LITERALS_ESCAPE;} */

/* Null Literal */
null										{return (int)Tokens.NULL_LITERAL;}

										/* 3.11 SEPARATORS */
										
"("											{return '(';}	
")"											{return ')';}	
"{"											{return '{';}	
"}"											{return '}';}	
"["											{return '[';}	
"]"											{return ']';}	
";"											{return ';';}	
","											{return ',';}	
"."											{return '.';}	
"..."										{return (int)Tokens.ELLIPSIS;}	
"@"											{return '@';}	
"::"										{return (int)Tokens.DOUBLE_COLON;}	
										

										/* 3.12 OPERATOR */
										
"="											{return '=';}
">"											{return '>';}
"<"											{return '<';}

"=="										{return (int)Tokens.EQUAL;}
">="										{return (int)Tokens.GREATER_OR_EQUAL;}
"<="										{return (int)Tokens.LESS_THAN_OR_EQUAL;}
"!="										{return (int)Tokens.NOT_EQUAL;}

"?"											{return '?';}
":"											{return ':';}
"->"										{return (int)Tokens.ARROW;}

"&&"										{return (int)Tokens.LOGICAL_AND;}
"||"										{return (int)Tokens.LOGICAL_OR;}
"!"											{return (int)Tokens.LOGICAL_NOT;}

"++"										{return (int)Tokens.INCREMENT;}
"--"										{return (int)Tokens.DECREMENT;}

"+"											{return '+';}
"-"											{return '-';}
"*"											{return '*';}
"/"											{return '/';}
"%"											{return '%';}

"&"											{return '&';}
"|"											{return '|';}
"^"											{return '^';}
"~"											{return '~';}

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

[ \r\n\tSPHTFF]                    			/* skip whitespace */

\\(?:[1-7][0-7]{0,2}|[0-7]{2,3})			/* Comment */

.                            			{ 
											throw new Exception(
												String.Format(
													"unexpected character '{0}'", yytext)); 
										}



%%
