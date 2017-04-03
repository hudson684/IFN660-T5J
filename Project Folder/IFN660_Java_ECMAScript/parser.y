%namespace IFN660_Java_ECMAScript
%union
{
    public long num;
	public float floatnum;
	public bool boolval;
	public char charval;
    public string name;
}

%token <num> NUMBER
%token <name> IDENTIFIER

// 3.9 Keywords
%token ABSTRACT   CONTINUE   FOR          NEW         SWITCH
%token ASSERT     DEFAULT    IF           PACKAGE     SYNCHRONIZED
%token BOOL	      DO         GOTO         PRIVATE     THIS
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

Statement : IF '(' Expression ')' Statement ELSE Statement
          | '{' StatementList '}'
          | Expression ';'
          | Type IDENTIFIER ';'
		  | StatementWithoutTrailingSubstatement
          ;

Type	: IntegerLiteral
		| BooleanLiteral
		;

StatementList 
		: StatementList Statement
        | /* empty */
        ;

Expression 
		: IntegerLiteral
        | IDENTIFIER
        | Expression '=' Expression
        | Expression '+' Expression
        | Expression '<' Expression
		| AssignmentExpression
		  
           ;
Empty	:
		;

// Group A Start
CompilationUnit 
		: PackageDeclaration_opt ImportDeclarations TypeDeclarations
		;

PackageDeclaration_opt
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
		: ClassModifiers ClassModifier
		| /* empty */
		;

ClassModifier 
		: Annotation
		| PUBLIC
		| PROTECTED 
		| PRIVATE 
		| ABSTRACT 
		| STATIC 
		| FINAL 
		| STRICTFP 
		;

Annotation
		: /* empty */
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

// PartB by Adon Mofified by Josh to remove MemberDeclarations as it is unessisary
ClassBodyDeclarations
		: ClassBodyDeclarations ClassBodyDeclaration
		| /* empty */
        ;

ClassBodyDeclaration
		: ClassMemberDeclaration
        ;

// Fixed by An
ClassMemberDeclaration
		: MethodDeclaration
		;

// Change ClassMemberDeclaration to MethodDeclaration -An	
MethodDeclaration
		: MethodModifiers MethodHeader MethodBody
        ;

MethodModifiers
        : MethodModifiers MethodModifier
		| /* Empty */
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
		: VOID
		| UnannType
	   	;

Throws_opt
		: Empty
	  	;

// Fixed spelling error	 
MethodDeclarator
		: IDENTIFIER '(' FormalParameterList_Opt ')' Dims_Opt
		;

/* Removed by Nathan
Identifier
		: Main
		;
*/
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
		| /*TODO*/
		;

FormalParameters 
		: FormalParameter FormalParameter_repeat 
		| /* empty *//*TODO*/
		;
FormalParameter_repeat
		: ',' FormalParameter_repeat FormalParameter
		| /* empty */
		;

FormalParameter 
		:  VariableModifiers UnannType VariableDeclaratorId
		;
VariableModifiers 
		: VariableModifiers VariableModifier
		| /* empty */
		;

VariableModifier 
		: Annotation
		| FINAL
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
		: UnannReferenceType
		| UnannPrimitiveType
		;

UnannPrimitiveType
		: NumbericType
		| BOOL
		;

NumbericType
		: IntegralType
		| FloatingPointType
		;

IntegralType
		: BYTE
		| SHORT
		| INT
		| LONG
		| CHAR
		;

FloatingPointType
		: FLOAT
		| DOUBLE
		;

UnannReferenceType
		: UnannArrayType
		| /*follow up */
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
		:  Block 
		| ';'
		;

Annotations
		: Annotation
		| /* Empty */
		;

Block 
		: '{' BlockStatements_Opt '}'
		;

BlockStatements_Opt
		: BlockStatements
		| /* Empty */
		;

BlockStatements
		: BlockStatement BlockStatement_s
		;

BlockStatement_s
		: BlockStatement_s BlockStatement
		| /* Empty */
		;

BlockStatement
		: LocalVariableDeclarationsAndStatement
		| Statement
		| /* follow up */
		;

LocalVariableDeclarationsAndStatement
		: LocalVariableDeclaration ';'
		;

LocalVariableDeclaration
		: UnannType VariableDeclaratorList
		| /* follow up */
		;

VariableDeclaratorList
		: VariableDeclarator
		| /* follow up */
		;

VariableDeclarator
		: VariableDeclaratorId
		| /* follow up */
		;

VariableDeclaratorId
		: IDENTIFIER Dims_Opt
		;

// Tristan
StatementWithoutTrailingSubstatement
		: ExpressionStatement 
		;

ExpressionStatement
		: StatementExpression ';'
		;

StatementExpression
		: Assignment
		;

// End Work by Tristan
//work by sneha

Assignment
		: LeftHandSide AssignmentOperator Expression
		;

LeftHandSide
		: ExpressionName
		;

ExpressionName
		: IDENTIFIER
		;

AssignmentOperator
		: '='
		;

AssignmentExpression
		: ArrayAccess
		;

ArrayAccess
		: PrimaryNoNewArray
		;

PrimaryNoNewArray
		: Literal
		;

Literal
		: IntegerLiteral
		;

// end of sneha Work

%%

public Parser(Scanner scanner) : base(scanner)
{
}
