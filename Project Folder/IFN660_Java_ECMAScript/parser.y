%namespace IFN660_Java_ECMAScript
%union
{
    public int num;
    public string name;
}

%token <num> NUMBER
%token <name> IDENT
%token IF ELSE INT BOOL GE
%token Void Main

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

Empty:
	 ;

//WORK BY JOSH HUDSON
Result : Void
	   ;

Throws: Empty
	  ;
	 
MethodDeclorator: Identifyer '(' FormalParameterList_Opt ')' Dims_Opt
				;

Identifyer: Main
		  ;

//PLACEHOLDER - Josh
FormalParameterList_Opt: Empty
					   ;

Dims_Opt : Empty
		 ;

// JOSHUA'S WORK END

%%

public Parser(Scanner scanner) : base(scanner)
{
}
