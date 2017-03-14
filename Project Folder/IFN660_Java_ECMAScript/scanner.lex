﻿%namespace IFN660_Java_ECMAScript

%{
int lines = 0;
%}

digit [0-9]
letter [a-zA-Z]

%%

if                           { return (int)Tokens.IF; }
else                         { return (int)Tokens.ELSE; }
int                          { return (int)Tokens.INT; }
bool                         { return (int)Tokens.BOOL; }

{letter}({letter}|{digit})* { yylval.name = yytext; return (int)Tokens.IDENT; }
{digit}+	    { yylval.num = int.Parse(yytext); return (int)Tokens.NUMBER; }

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



[\n]		{ lines++;    }
[ \t\r]      /* ignore other whitespace */

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

