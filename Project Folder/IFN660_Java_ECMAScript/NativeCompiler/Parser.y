%{
#include <stdio.h>
#include "Statement.h"

int yylex();
void yyerror(char*);
extern "C" int yywrap();

Node *root;
%}

%union
{
    Expression *expr;
	Statement *stmt;
	Type *type;
	vector<Statement*> *stmts;
	int num;
	char* name;
}

%token <num> NUMBER
%token <name> IDENT
%token IF ELSE INT BOOL

%type <expr> Expression
%type <stmt> Statement
%type <type> Type
%type <stmts> StatementList

%left '='
%nonassoc '<'
%left '+'

%%

Program : Statement											{ root = $1; }
        ;

Statement : IF '(' Expression ')' Statement ELSE Statement	{ $$ = new IfStatement($3, $5, $7); }
          | '{' StatementList '}'							{ $$ = new CompoundStatement($2);   }
		  | Expression ';'									{ $$ = new ExpressionStatement($1); }
		  | Type IDENT ';'									{ $$ = new VariableDeclaration($1,$2); }
		  ;

Type : INT													{ $$ = new IntType(); }
     | BOOL													{ $$ = new BoolType(); }
	 ;

StatementList : StatementList Statement				    	{ $$ = $1; $$->push_back($2);    }
              | /* empty */									{ $$ = new vector<Statement*>(); }
			  ;

Expression : NUMBER											{ $$ = new NumberExpression($1);         }
           | IDENT											{ $$ = new IdentifierExpression($1);     }
		   | Expression '=' Expression						{ $$ = new AssignmentExpression($1, $3); }
		   | Expression '+' Expression						{ $$ = new BinaryExpression($1,'+',$3);  }
		   | Expression '<' Expression						{ $$ = new BinaryExpression($1,'<',$3);  }
		   ;

%%

int yywrap()
{
    return 1;
}

