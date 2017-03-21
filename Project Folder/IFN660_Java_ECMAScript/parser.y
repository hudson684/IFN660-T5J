%namespace IFN660_Java_ECMAScript
%union
{
    public int num;
    public string name;
}

%token <num> NUMBER
%token <name> IDENTIFIER
%token IF ELSE INT BOOL GE STATIC FINAL
%token Void Main
%token PUBLIC CLASS

%left '='
%nonassoc '<'
%left '+'

%%

Program
		: Statement
		;

Statement 
		: IF '(' Expression ')' Statement ELSE Statement
		| '{' StatementList '}'
		| Expression ';'
		| Type IDENTIFIER ';'
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
        | IDENTIFIER
        | Expression '=' Expression
        | Expression '+' Expression
        | Expression '<' Expression
        ;

Empty:
	 ;

// Group A Start
CompilationUnit 
		: PackageDeclaration_opt ImportDeclarations TypeDeclarations
		;

PackageDeclaration_opt\
		: /* empty */
		| /* follow up */
		;
		
ImportDeclarations
		: /*empty*/
		| /* follow up */
		;

TypeDeclarations 
		: TypeDeclaration TypeDeclarations
		| /* empty */
		| /* follow up */
		;

TypeDeclaration 
		: ClassDeclaration /* need to add InterfaceDeclaration */
		;

ClassDeclaration 
		: NormalClassDeclaration /* need to add EnumDeclaration */
		;

NormalClassDeclaration 
		: ClassModifiers CLASS IDENTIFIER TypeParameters_opt SuperClass_opt Superinterfaces_opt ClassBody
		;

ClassModifiers 
		: ClassModifier ClassModifiers
		| /* empty */
		;

ClassModifier 
		: Annotation
		| PUBLIC
		; /* follow up*/

Annotation
		: /* empty */
		| /* follow up*/
		;

//GROUP C TRACKING
TypeParameters_opt : /* empty */
		;

SuperClass_opt : /* empty */
		;

Superinterfaces_opt : /* empty */
		;

ClassBody 
		: '{' ClassBodyDeclarations '}'
		;
// Group A End

// PartB by Adon
ClassBodyDeclarations
		: ClassBodyDeclaration
        ;

ClassBodyDeclaration
		: ClassMemberDeclarations
        ;

ClassMemberDeclarations 
		: ClassMemberDeclaration
		;

// Fixed by An
ClassMemberDeclaration
		:MethodDeclaration
		;
// Change ClassMemberDeclaration to MethodDeclaration -An	
MethodDeclaration
		: MethodModifiers MethodHeaders MethodBody
        ;

MethodHeaders
		: MethodHeader
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
		: IDENTIFIER '(' FormalParameterList_Opt ')' Dims_Opt
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
FormalParameterList 
		: FormalParameters 
		;

FormalParameters 
		: FormalParameter FormalParameters
		| /* empty */
		;

FormalParameter 
		: VariableModifiers UnannType VariableDeclaratorId
		;

VariableModifiers 
		: VariableModifier VariableModifiers
		| /* empty */
		;

VariableModifier 
		: /* empty */ /* TODO */
		;

//End work by Tri

// Work by Vivian
Dims
		: Annotations '['']'
		;

VariableDeclaratorId
		: IDENTIFIER Dims_Opt
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
		: IDENTIFIER
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
