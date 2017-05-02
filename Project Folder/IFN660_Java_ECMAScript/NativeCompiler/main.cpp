#include <stdio.h>
#include "Statement.h"
#include "Parser.tab.h"

//#define testScanner

int yylex();
int yyparse();
extern FILE *yyin;
extern Node *root;

void SemanticAnalysis(Node* root)
{
	root->ResolveNames(NULL);
	root->TypeCheck();
}

int main(int argc, char* argv[])
{
	yyin = fopen(argv[1], "r");

#ifdef testScanner
	int token = 1;
	while (token > 0)
	{
		token = yylex();
		switch (token)
		{
			case IDENT: printf("IDENT %s\n", yylval.name); break;
			case NUMBER: printf("NUMBER %d\n", yylval.num); break;
			case INT: printf("INT\n"); break;
			case BOOL: printf("BOOL\n"); break;
			case IF: printf("IF\n"); break;
			case ELSE: printf("ELSE\n"); break;
			case EOF: printf("EOF\n"); break;
			default: printf("'%c'\n", token);
		}
	}
#else
	yyparse();

	if (root != NULL)
	{
		//root->dump(0);
		SemanticAnalysis(root);
		root->dump(0);
	}
#endif
}
