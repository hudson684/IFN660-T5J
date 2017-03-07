%namespace IFN660_Java_ECMAScript

digit [0-9]
letter [a-zA-Z]

%%

while                        { return (int)Tokens.WHILE; }

{letter}({letter}|{digit})* { yylval.name = yytext; return (int)Tokens.IDENT; }

{digit}+	    { yylval.num = int.Parse(yytext); return (int)Tokens.NUMBER; }


,                            { return ','; }

>=                           { return (int)Tokens.GE; }

>                            { return '>'; }

[ \r\n\t]                    /* skip whitespace */

.                            { 
                                 throw new Exception(
                                     String.Format(
                                         "unexpected character '{0}'", yytext)); 
                             }

%%
