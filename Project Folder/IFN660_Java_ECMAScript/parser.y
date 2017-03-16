%namespace IFN660_Java_ECMAScript
%union
{
    public int num;
    public string name;
}

%token <num> NUMBER
%token <name> IDENT
%token IF ELSE INT BOOL

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

		  // VariableDeclaratorId - Vivian
VariableDeclaratorId : Identifier
					 | Dims
					 ;

		  // Identifier - Vivian
Identifier : "args"
		   | String
		   | "main"
		   ;

		  // Dims - Vivian
Dims :  /* empty */
     ;

%%

public Parser(Scanner scanner) : base(scanner)
{
}
