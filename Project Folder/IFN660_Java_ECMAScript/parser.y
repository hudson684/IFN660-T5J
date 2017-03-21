%namespace IFN660_Java_ECMAScript
%union
{
    public int num;
    public string name;
}

%token <num> NUMBER
%token <name> IDENT
%token IF ELSE INT BOOL GE STATIC FINAL
%token Void Main
%token PUBLIC CLASS

%left '='
%nonassoc '<'
%left '+'

%%

Program : Statement
        ;

Statement 
		: IF '(' Expression ')' Statement ELSE Statement
        | '{' StatementList '}'
        | Expression ';'
        | Type IDENT ';'
        ;

Type 
		: INT
     	| BOOL
     	;

StatementList 
		: StatementList Statement
    	| /* empty */
        ;

Expression 
		: NUMBER
        | IDENT
        | Expression '=' Expression
        | Expression '+' Expression
        | Expression '<' Expression
        ;

Empty:
	 ;

// Group A Start
CompilationUnit 
		: TypeDeclarations /* need to add PackageDeclaration_opt and ImportDeclarations */
		;

TypeDeclarations 
		: TypeDeclarations TypeDeclaration
		| /* empty */
		;

TypeDeclaration 
		: ClassDeclaration /* need to add InterfaceDeclaration */
		;

ClassDeclaration 
		: NormalClassDeclaration /* need to add EnumDeclaration */
		;

NormalClassDeclaration 
		: ClassModifiers CLASS IDENT TypeParameters_opt SuperClass_opt Superinterfaces_opt ClassBody
		;

ClassModifiers 
		: ClassModifiers ClassModifier
		| /* empty */
		;

ClassModifier 
		: Annotation
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

ClassBody 
		: '{' ClassBodyDeclaration '}' /* not really. This will hook into GroupB's work. Just for testing */
		;
// Group A End

// PartB by Adon
ClassBodyDeclarations
		: ClassBodyDeclaration
		| /* Empty */
        ;

ClassBodyDeclaration
		: ClassMemberDeclaration
        ;

// Fixed by An
ClassMemberDeclaration
		:MethodDeclaration
		;
// Change ClassMemberDeclaration to MethodDeclaration -An	
MethodDeclaration
		: MethodModifiers MethodHeader MethodBody
        ;

MethodModifiers
		: MethodModifier
        | MethodModifier MethodModifiers
        ;

MethodModifier
		: Annotation
		| PUBLIC
        | STATIC
        ;

MethodHeader
		: Result MethodDeclarator Throws_opt
        ;

// End Fix
// End GroupB

//WORK BY JOSH HUDSON
Result 
		: Void
	   	;

Throws_opt
		: Empty
	  	;
	 
// Fixed spelling error	 
MethodDeclarator
		: IDENT '(' FormalParameterList_Opt ')' Dims_Opt
		;

Identifier
		: Main
		;

//PLACEHOLDER - Josh - Tri
FormalParameterList_Opt
		: FormalParameterList
		| /* empty */
		;

Dims_Opt 
		: Dims
		| /* Empty */
		;

// JOSHUA'S WORK END

//Work by Tri
FormalParameterList : FormalParameters 
					;

FormalParameters : FormalParameter FormalParameters
				 | /* empty */
				 ;

FormalParameter : VariableModifiers UnannType VariableDeclaratorId
				;

VariableModifiers : VariableModifier VariableModifiers
				  | /* empty */
				  ;

VariableModifier : /* empty */ /* TODO */
				 ;

//End work by Tri

// Work by Vivian
Dims
		: Annotations '['']'
		;

VariableDeclaratorId
		: IDENT Dims_Opt
		;
UnannType
		:UnannReferenceType
		;

UnannReferenceType
		: UnannArrayType
		;
// Vivian's work end
// Work by Khoa - Fixed by An
UnannArrayType
		: UnannTypeVariable Dims
		;		
UnannTypeVariable
		: IDENT
		;	

// Start work by An
MethodBody
		: Block 
		| ';'
		;
Annotations
		: Annotation
		| Empty
		;
Block 
		: '{' BlockStatements_Opt '}'
		;
BlockStatements_Opt
		: BlockStatements
		| Empty
		;
BlockStatements
		: BlockStatement BlockStatement_s
		;

BlockStatement_s
		: BlockStatement BlockStatement_s
		| Empty
		;

BlockStatement
		: LocalVariableDeclarationsAndStatement
		;
LocalVariableDeclarationsAndStatement
		: LocalVariableDeclaration ';'
		;
LocalVariableDeclaration
		: VariableModifers UnannType VariableDeclaratorList
		;
VariableModifers
		: VariableModifer VariableModifers
		| Empty
		;
VariableModifer
		: Annotation
		| FINAL
		;
VariableDeclaratorList
		: VariableDeclarator
		;
VariableDeclarator
		: VariableDeclaratorId VariableDeclarator_opt
		;
VariableDeclarator_opt
		: '=' VariableInitializer
		;
VariableDeclaratorId
		: Identifyer Dims_Opt
		;
VariableInitializer
		: Expression
		;

// End work by An

%%

public Parser(Scanner scanner) : base(scanner)
{
}
