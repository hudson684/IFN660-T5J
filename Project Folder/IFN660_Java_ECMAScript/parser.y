%namespace IFN660_Java_ECMAScript.AST
%union
{
    public long num;
	public double floatnum;
	public bool boolval;
	public char charval;
    public string name;
	Statement s;
	Expression e;
	Node n;
}

%token <num> NUMBER
%token <name> IDENTIFIER

// 3.9 Keywords
%token ABSTRACT   CONTINUE   FOR          NEW         SWITCH
%token ASSERT     DEFAULT    IF           PACKAGE     SYNCHRONIZED
%token BOOLEAN	  DO         GOTO         PRIVATE     THIS
%token BREAK      DOUBLE     IMPLEMENTS   PROTECTED   THROW
%token BYTE       ELSE       IMPORT       PUBLIC      THROWS
%token CASE       ENUM       INSTANCEOF   RETURN      TRANSIENT
%token CATCH      EXTENDS    INT          SHORT       TRY
%token CHAR       FINAL      INTERFACE    STATIC      VOID
%token CLASS      FINALLY    LONG         STRICTFP    VOLATILE
%token CONST      FLOAT      NATIVE       SUPER       WHILE

// 3.10 Literals
%token <intnum> IntegerLiteral
%token <floatnum> FloatingPointLiteral
%token <boolval> BooleanLiteral
%token <charval> CharacterLiteral
%token <name> StringLiteral
%token NullLiteral

// 3.11 Separators
%token '(' ')' '{' '}' '[' ']' 
%token ';' ',' '.' '@'
%token ELLIPSIS DOUBLE_COLON

// 3.12 Operators
%token '=' '>' '<' '!' '~' '?' ':' 
%token '+' '-' '*' '/' '&' '|' '^' '%'
%token EQUAL GREATER_OR_EQUAL LESS_THAN_OR_EQUAL NOT_EQUAL
%token ARROW LOGICAL_AND LOGICAL_OR INCREMENT DECREMENT
%token LEFT_SHIFT SIGNED_RIGHT_SHIFT UNSIGNED_RIGHT_SHIFT
%token ADDITION_ASSIGNMENT SUBTRACTION_ASSIGNMENT
%token MULTIPLICATION_ASSIGNMENT DIVISION_ASSIGNMENT MODULUS_ASSIGNMENT
%token BITWISE_AND_ASSIGNMENT BITWISE_OR_ASSIGNMENT BITWISE_XOR_ASSIGNMENT
%token LEFT_SHIFT_ASSIGNMENT UNSIGNED_RIGHT_SHIFT_ASSIGNMENT SIGNED_RIGHT_SHIFT_ASSIGNMENT

%left '='
%nonassoc '<'
%left '+'

%%

Program : CompilationUnit										
        ;

Statement : IF '(' Expression ')' Statement ELSE Statement		{ $$ = new IfStatement($3, $5, $7); } // Nathan
          | '{' StatementList '}'								{ $$ = $2; } // how does this work? Won't StatementList be any array or list type - Nathan
          | Expression ';'										{ $$ = new ExpressionStatement($1); } // Nathan
          | Type IDENTIFIER ';'									
		  | StatementWithoutTrailingSubstatement				{ $$ = $1; } // Nathan
          ;

Type	: IntegerLiteral										{ $$ = $1;}
		| BooleanLiteral										{ $$ = $1; }
		;

StatementList 
		: StatementList Statement								{ $$ = $2;} // needs work - Nathan
        | /* empty */											{ $$ = null;}
        ;

Expression 
		: IntegerLiteral										{ $$ = $1; }
        | IDENTIFIER											{ $$ = $1; } // this might not be right	
        | Expression '=' Expression								{ $$ = new AssignmentExpression($1,$3); }
        | Expression '+' Expression								{ $$ = new BinaryExpression($1,$2,$3); } // check this
        | Expression '<' Expression								{ $$ = new BinaryExpression($1,$2,$3); } //Josh - check this
		| AssignmentExpression									{ $$ = $1; } // Josh
		  
           ;
Empty	:
		;

// Group A Start
CompilationUnit 
		: PackageDeclaration_opt ImportDeclarations TypeDeclarations	{ $$ = new CompiationUnitDeclaration($1,$2,$3); $$.DumpValue(0); } // Josh
		;

PackageDeclaration_opt
		: /* empty */											{ $$ = null; }
		| /* follow up */
		;
		
ImportDeclarations
		: /*empty*/												{ $$ = null; }
		| /* follow up */
		;

TypeDeclarations 
		: TypeDeclaration TypeDeclarations						{ $$ = $1; } // needs work - Josh
		| /* empty */											{ $$ = null; }
		| /* follow up */
		;
TypeDeclaration 
		: ClassDeclaration /* need to add InterfaceDeclaration */ {  } // Vivian
		;

ClassDeclaration 
		: NormalClassDeclaration /* need to add EnumDeclaration */ {  } // Vivian
		;

NormalClassDeclaration 
		: ClassModifiers CLASS IDENTIFIER TypeParameters_opt SuperClass_opt Superinterfaces_opt ClassBody {  } // Vivian
		;

ClassModifiers 
		: ClassModifiers ClassModifier							{  } // Vivian
		| /* empty */											{  } // Vivian
		;

ClassModifier 
		: Annotation											{  } // Adon
		| PUBLIC												{  } // Adon
		| PROTECTED 											{  } // Adon
		| PRIVATE 												{  } // Adon
		| ABSTRACT 												{  } // Adon
		| STATIC 												{  } // Adon
		| FINAL 												{  } // Adon
		| STRICTFP 												{  } // Adon
		;

Annotation
		: /* empty */											{ } // Tristan
		;

//GROUP C TRACKING
TypeParameters_opt : /* empty */								{ } // Tristan
		;

SuperClass_opt : /* empty */									{ } // Tristan
		;

Superinterfaces_opt : /* empty */								{ } // Tristan
		;

ClassBody 
		: '{' ClassBodyDeclarations '}'							{ } // Tristan
		;

// Group A End

// PartB by Adon Mofified by Josh to remove MemberDeclarations as it is unessisary
ClassBodyDeclarations
		: ClassBodyDeclarations ClassBodyDeclaration			{ } // Tristan
		| /* empty */											{ } // Tristan
        ;

ClassBodyDeclaration
		: ClassMemberDeclaration								{ } // Tristan
        ;

// Fixed by An
ClassMemberDeclaration
		: MethodDeclaration										{ } // Sneha
		;

// Change ClassMemberDeclaration to MethodDeclaration -An	
MethodDeclaration
		: MethodModifiers MethodHeader MethodBody				{ } // Sneha
        ;

MethodModifiers
        : MethodModifiers MethodModifier						{ } // Sneha
		| /* Empty */											{ } // Sneha
        ;

MethodModifier
		: Annotation											{ } // Sneha
		| PUBLIC												{ } // Sneha
        | STATIC												{ } // Sneha
        ;

MethodHeader
		: Result MethodDeclarator Throws_opt					{ } // Khoa
        ;

// End Fix
// End GroupB

//WORK BY JOSH HUDSON
Result 
		: VOID													{ } // Khoa
		| UnannType												{ } // Khoa
	   	;

Throws_opt
		: Empty													{ } // Khoa
	  	;

// Fixed spelling error	 
MethodDeclarator
		: IDENTIFIER '(' FormalParameterList_Opt ')' Dims_Opt	{ } // Khoa
		;

/* Removed by Nathan
Identifier
		: Main													{ } // Khoa
		;
*/
//PLACEHOLDER - Josh - Tri
FormalParameterList_Opt
		: FormalParameterList									{ } // An
		| /* empty */											{ } // An
		;

Dims_Opt 
		: Dims													{ } // An
		| /* Empty */											{ } // An
		;
// JOSHUA'S WORK END

//Work by Tri
FormalParameterList 
		: FormalParameters 										{ } // An
		| /*TODO*/												{ } // An
		;

FormalParameters 
		: FormalParameters FormalParameter 						{ $$ = $2; } /* TODO - only works if there is a single parameter */ // Nathan
		| /* empty *//*TODO*/									{ $$ = null; } // Nathan
		;

///	Do we need this? - Nathan	
//FormalParameter_repeat
//		: ',' FormalParameter_repeat FormalParameter			{ $$ = null; } /* TODO */ // Nathan
//		| /* empty */											{ $$ = null; } // Nathan
//		;


FormalParameter 
		:  VariableModifiers UnannType VariableDeclaratorId		{ $$ = new VariableDeclarationStatement($2, $3); } // Nathan
		;
VariableModifiers 
		: VariableModifiers VariableModifier					{ $$ = null; } /* TODO */  // Nathan
		| /* empty */											{ $$ = null; } // Nathan
		;

VariableModifier 
		: Annotation											{ $$ = $1; } // Tri
		| FINAL													{ $$ = $1; } // Tri
		;

//End work by Tri
// Work by Vivian
Dims
		: Annotations '['']'									{ $$ = $1; } // Needs work - Tri
		;

VariableDeclaratorId
		: IDENTIFIER Dims_Opt									{ $$ = $1; } // Needs work - Tri
		;

UnannType
		: UnannReferenceType									{ $$ = $1; } // Tri
		| UnannPrimitiveType									{ $$ = $1; } // Tri
		;

UnannPrimitiveType

		: NumbericType											{ $$ = $1; } // Josh
		| BOOLEAN												{ $$ = $1; } // Josh
		;

NumbericType
		: IntegralType											{ $$ = $1; } // Josh
		| FloatingPointType										{ $$ = $1; } // Josh
		;

IntegralType
		: BYTE													{ $$ = $1;  } // Josh
		| SHORT													{ $$ = $1;  } // Josh
		| INT													{ } // Vivian
		| LONG													{ } // Vivian
		| CHAR													{ } // Vivian
		;

FloatingPointType
		: FLOAT													{ } // Vivian
		| DOUBLE												{ } // Vivian
		;

UnannReferenceType
		: UnannArrayType										{ } // Vivian
		| /*follow up */										{ } // Vivian
		;

// Vivian's work end
// Work by Khoa - Fixed by An
UnannArrayType
		: UnannTypeVariable Dims								{ } // Adon
		;	
			
UnannTypeVariable
		: IDENTIFIER											{ } // Adon
		;	

// Start work by An
MethodBody
		:  Block 												{ } // Adon
		| ';'													{ } // Adon
		;

Annotations
		: Annotation											{ } // Adon
		| /* Empty */											{ } // Adon
		;

Block 
		: '{' BlockStatements_Opt '}'							{ } // Tristan
		;

BlockStatements_Opt
		: BlockStatements										{ } // Tristan
		| /* Empty */											{ } // Tristan
		;

BlockStatements
		: BlockStatement BlockStatement_s						{ } // Tristan
		;

BlockStatement_s
		: BlockStatement_s BlockStatement						{ } // Tristan
		| /* Empty */											{ } // Tristan
		;

BlockStatement
		: LocalVariableDeclarationsAndStatement					{ } // Sneha
		| Statement												{ } // Sneha
		| /* follow up */										{ } // Sneha
		;

LocalVariableDeclarationsAndStatement
		: LocalVariableDeclaration ';'							{ } // Sneha
		;

LocalVariableDeclaration
		: UnannType VariableDeclaratorList						{ } // Sneha
		| /* follow up */										{ } // Sneha
		;

VariableDeclaratorList
		: VariableDeclarator									{ } // An
		| /* follow up */										{ } // An
		;

VariableDeclarator
		: VariableDeclaratorId									{ } // An
		| /* follow up */										{ } // An
		;

VariableDeclaratorId
		: IDENTIFIER Dims_Opt									{ } // An
		;

// Tristan
StatementWithoutTrailingSubstatement
		: ExpressionStatement 									{ } // An
		;

ExpressionStatement
		: StatementExpression ';'								{ } // Khoa
		;

StatementExpression
		: Assignment											{ } // Khoa
		;

// End Work by Tristan
//work by sneha

Assignment
		: LeftHandSide AssignmentOperator Expression			{ } // Khoa
		;

LeftHandSide
		: ExpressionName										{ } // Khoa
		;

ExpressionName
		: IDENTIFIER											{ } // Khoa
		;

AssignmentOperator
		: '='													{ } // Khoa
		;

AssignmentExpression
		: ArrayAccess											{ $$ = $1; } // Nathan
		;

ArrayAccess
		: PrimaryNoNewArray										{ $$ = $1; } // Nathan
		;

PrimaryNoNewArray
		: Literal												{ $$ = $1; } // Nathan
		;

Literal
		: IntegerLiteral										{ $$ = new IntegerLiteralExpression($1); } // Nathan
		;

// end of sneha Work

%%

public Parser(Scanner scanner) : base(scanner)
{
}