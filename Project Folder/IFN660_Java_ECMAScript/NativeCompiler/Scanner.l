%{
#include "Expression.h"
#include "Statement.h"
#include "Parser.tab.h"

int lines = 0;
%}

%%

if			{ return IF; }
else		{ return ELSE; }
 
int			{ return INT; }
bool		{ return BOOL; }

[0-9]+		{ yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z]+	{ yylval.name = strdup(yytext);   return IDENT; }

"="			{ return '='; }
"+"			{ return '+'; }
"<"			{ return '<'; }
"("			{ return '('; }
")"			{ return ')'; }
"{"			{ return '{'; }
"}"			{ return '}'; }
";"			{ return ';'; }

[\n]		{ lines++;    }
[ \t\r]		/* ignore whitespace */ 

.			{ fprintf(stderr, "Unexpected character '%s'", yytext); }

%%

void yyerror(char* message)
{
    fprintf(stderr, "Error: line %d, %s\n", lines, message);
}