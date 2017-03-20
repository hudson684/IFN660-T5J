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
%token PUBLIC CLASS

%left '='
%nonassoc '<'
%left '+'

%%
// Group A Start
CompilationUnit : TypeDeclarations /* need to add PackageDeclaration_opt and ImportDeclarations */
		;

TypeDeclarations : TypeDeclarations TypeDeclaration
		| /* empty */
		;

TypeDeclaration : ClassDeclaration /* need to add InterfaceDeclaration */
		;

ClassDeclaration : NormalClassDeclaration /* need to add EnumDeclaration */
		;

NormalClassDeclaration : ClassModifiers CLASS IDENT TypeParameters_opt SuperClass_opt Superinterfaces_opt ClassBody
		;

ClassModifiers : ClassModifiers ClassModifier
		| /* empty */
		;

ClassModifier : Annotation
		| PUBLIC
		; /* more need to be added here */

Annotation : /* empty */
		;

TypeParameters_opt : /* empty */
		;

SuperClass_opt : /* empty */
		;

Superinterfaces_opt : /* empty */
		;

ClassBody : Statement /* not really. This will hook into GroupB's work. Just for testing */
		;
// Group A End

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
