%namespace IFN660_Java_ECMAScript

digit [0-9]
nonZeroDigit [1-9]
hexDigit [a-fA-F0-9]
letter [a-zA-Z]

%%

// 3.6 Whitespace
[ \r\n\t\f]                  /* skip whitespace */

// 3.7 Comments
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/		/* skip multiline comments */

\/\/[^\n]*                /* skip the line comment  */

// 3.10.1 - Integer Literals
// Decimals
(({nonZeroDigit}({digit}|"_")*{digit}+)|{digit})[lL]*  { yylval.name = yytext; return (int)Tokens.NUMBER; }
// Hexadecimals
0[xX](({hexDigit}({hexDigit}|"_")*{hexDigit}+)|{hexDigit})[lL]*  { yylval.name = yytext; return (int)Tokens.NUMBER; }

if                           { return (int)Tokens.IF; }
else                         { return (int)Tokens.ELSE; }
int                          { return (int)Tokens.INT; }
bool                         { return (int)Tokens.BOOL; }
while                        { return (int)Tokens.WHILE; }

{letter}({letter}|{digit})* { yylval.name = yytext; return (int)Tokens.IDENT; }
//{digit}+	    { yylval.num = int.Parse(yytext); return (int)Tokens.NUMBER; }

"="                            { return '='; }
"+"                            { return '+'; }
"<"                            { return '<'; }
"("                            { return '('; }
")"                            { return ')'; }
"{"                            { return '{'; }
"}"                            { return '}'; }
";"                            { return ';'; }
","                            { return ','; }
">="                           { return (int)Tokens.GE; }
">"                            { return '>'; }




.                            { 
                                 throw new Exception(
                                     String.Format(
                                         "unexpected character '{0}'", yytext)); 
                             }

%%
