%namespace IFN660_Java_ECMAScript
%union
{
    public int num;
    public string name;
}

%token <num> NUMBER
%token <name> IDENT
%token IF ELSE INT BOOL
%token ARGS
%token MAIN

%left '='
%nonassoc '<'
%left '+'

%%

Program : Statement
        ;

Statement : IF '(' Expression ')' Statement ELSE Statement
          | '{' StatementList '}'
          | Expression ';'
          | Type IDENT ';'
          ;

Type : INT
     | BOOL
     ;

StatementList : StatementList Statement
              | /* empty */
              ;

Expression : NUMBER
           | IDENT
           | Expression '=' Expression
           | Expression '+' Expression
           | Expression '<' Expression
           ;

		  // Unanntype - Vivian
UnannType : UnannReferenceType
		  ;
		  // UnannReferenceType - Vivian
UnannReferenceType : /* empty */
					;

		  // VariableDeclaratorId - Vivian
VariableDeclaratorId : Identifier
					 | Dims
					 ;

		  // Identifier - Vivian
Identifier : ARGS
		   | String
		   | MAIN
		   ;

		   // String - Vivian
String : /* empty*/
       ;

		  // Dims - Vivian
Dims :  /* empty */
     ;

	 

%%

public Parser(Scanner scanner) : base(scanner)
{
}
