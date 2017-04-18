%namespace IFN660_Java_ECMAScript

%using System.Collections.Generic;
%using IFN660_Java_ECMAScript.AST;

%{
public static CompilationUnitDeclaration root;
%}

%union
{
    public long num;
	public double floatnum;
	public bool boolval;
	public char charval;
    public string name;
	public Statement stmt;
	public Expression expr;
	public AST.Type type;
	public CompilationUnitDeclaration cmpu;
	public List<Statement> stmts;
}

%token <num> NUMBER
%token <name> IDENTIFIER
%type <expr> Expression
%type <expr> Literal
%type <stmt> Statement
%type <stmt> TypeDeclaration
%type <type> Type
%type <stmts> StatementList
%type <stmts> TypeDeclarations
%type <cmpu> CompilationUnit

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
%token <num> IntegerLiteral
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

Program : CompilationUnit										{root = $1;}
        ;

Statement : IF '(' Expression ')' Statement ELSE Statement		{ $$ = new IfStatement($3, $5, $7); } // Nathan
          | '{' StatementList '}'								
          | Expression ';'										{ $$ = new ExpressionStatement($1); } // Nathan
          | Type IDENTIFIER ';'									{ $$ = new VariableDeclaration($1,$2);}
		  | StatementWithoutTrailingSubstatement				 // Nathan
          ;

Type	: IntegerLiteral										{ $$ = new IntType();}
		| BooleanLiteral										{ $$ = new BoolType(); }
		;

StatementList 
		: StatementList Statement								{ $$ = $1; $$.Add($2);} // needs work - Nathan
        | /* empty */											{ $$ = new List<Statement>();}
        ;

Expression 
		: IntegerLiteral										{ $$ = new IntegerLiteralExpression($1); }
        | IDENTIFIER											{ $$ = new VariableExpression($1); } // this might not be right	
        | Expression '=' Expression								{ $$ = new AssignmentExpression($1,$3); }
        | Expression '+' Expression								{ $$ = new BinaryExpression($1,'+',$3); } // check this
        | Expression '<' Expression								{ $$ = new BinaryExpression($1,'<',$3); } //Josh - check this
		| AssignmentExpression									// Josh
		  
           ;
Empty	:
		;

// Group A Start
CompilationUnit 
		: PackageDeclaration_opt ImportDeclarations TypeDeclarations	 // Josh   { $$ = new CompilationUnitDeclaration($1,$2,$3);  }
		;

PackageDeclaration_opt
		: /* empty */											
		;
		
ImportDeclarations
		: /*empty*/												
		;

TypeDeclarations 
		: TypeDeclarations TypeDeclaration						{ $$ = $1; $$.Add($2); } // needs work - Josh
		| /* empty */											{ $$ = new List<Statement>();}											
		;

TypeDeclaration 
		: ClassDeclaration /* need to add InterfaceDeclaration */ { $$ = $1; } // Vivian
		;

ClassDeclaration 
		: NormalClassDeclaration /* need to add EnumDeclaration */ { $$ = $1; } // Vivian
		;

NormalClassDeclaration 
		: ClassModifiers CLASS IDENTIFIER TypeParameters_opt SuperClass_opt Superinterfaces_opt ClassBody {  $$ = new NormalClassDeclaration($1,$2,$3,$4,$5,$6); } // Vivian
		;

ClassModifiers 
		: ClassModifiers ClassModifier							{ $$ = $1,$2; } // Vivian
		| /* empty */											{ $$ = null } // Vivian
		;

ClassModifier 
		: Annotation											{ $$ = $1; } // Adon
		| PUBLIC												{ $$ = $1; } // Adon
		| PROTECTED 											{ $$ = $1; } // Adon
		| PRIVATE 												{ $$ = $1; } // Adon
		| ABSTRACT 												{ $$ = $1; } // Adon
		| STATIC 												{ $$ = $1; } // Adon
		| FINAL 												{ $$ = $1; } // Adon
		| STRICTFP 												{ $$ = $1; } // Adon
		;

Annotation
		: /* empty */											{ $$ = null } // Tristan
		;

//GROUP C TRACKING
TypeParameters_opt : /* empty */								{ $$ = null } // Tristan
		;

SuperClass_opt : /* empty */									{ $$ = null } // Tristan
		;

Superinterfaces_opt : /* empty */								{ $$ = null } // Tristan
		;

ClassBody 
		: '{' ClassBodyDeclarations '}'							{ $$ = new ClassDeclaration($2)} // Tristan
		;

// Group A End

// PartB by Adon Mofified by Josh to remove MemberDeclarations as it is unessisary
ClassBodyDeclarations
		: ClassBodyDeclarations ClassBodyDeclaration			{ $$ =  $$ = $1; $$.Add($2); } // Tristan
		| /* empty */											{ $$ = null } // Tristan
        ;

ClassBodyDeclaration
		: ClassMemberDeclaration								{ $$ = $1} // Tristan
        ;

// Fixed by An
ClassMemberDeclaration
		: MethodDeclaration										{ $$ = $1; } // Vivian
		;

// Change ClassMemberDeclaration to MethodDeclaration -An	
MethodDeclaration
		: MethodModifiers MethodHeader MethodBody				{ $$ = new MethodDeclaration($1,$2,$3);} // Vivian
        ;

MethodModifiers
        : MethodModifiers MethodModifier						{ $$ = $1,$2; } // Vivian
		| /* Empty */											{ $$ = null; } // Vivian
        ;

MethodModifier
		: Annotation											{ $$ = $1; } // Vivian 
		| PUBLIC												{ $$ = $1; } // Vivian
        | STATIC												{ $$ = $1;} // vivian
        ;

MethodHeader
		: Result MethodDeclarator Throws_opt					{$$ = new ArrayList($1, $2, $3);} // Khoa
        ;

// End Fix
// End GroupB

//WORK BY JOSH HUDSON
Result 
		: VOID													{$$ = $1} // Khoa
		| UnannType												{$$ = $1} // Khoa
	   	;

Throws_opt
		: Empty													{$$ = new List<Statement>();} // Khoa
	  	;

// Fixed spelling error	 
MethodDeclarator
		: IDENTIFIER '(' FormalParameterList_Opt ')' Dims_Opt	{$$ =  new ArrayList($1, $3, $5)} // Khoa
		;

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
		;

FormalParameters 
		: FormalParameter 										//{ $$ = $2; } /* TODO - only works if there is a single parameter */ // Nathan 
		| FormalParameters ',' FormalParameter					// Nathan // Recheck this one
		;

///	Do we need this? - Nathan	
//FormalParameter_repeat
//		: ',' FormalParameter_repeat FormalParameter			{ $$ = null; } /* TODO */ // Nathan
//		| /* empty */											 // Nathan
//		;


FormalParameter 
		:  VariableModifiers UnannType VariableDeclaratorId		 // Nathan
		;
VariableModifiers 
		: VariableModifiers VariableModifier					 /* TODO */  // Nathan
		| /* empty */											 // Nathan
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
		: IDENTIFIER Dims_Opt									
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
		| INT													{ $$ = $1;} // Vivian
		| LONG													{ $$ = $1; } // Vivian
		| CHAR													{ $$ = $1; } // Vivian
		;

FloatingPointType
		: FLOAT													{ $$ = $1; } // Vivian
		| DOUBLE												{ $$ = $1; } // Vivian
		;

UnannReferenceType
		: UnannArrayType										{ $$ = $1; } // Vivian
		;

// Vivian's work end
// Work by Khoa - Fixed by An
UnannArrayType
		: UnannTypeVariable Dims								{ $$ = $1; } // Adon: Not sure but Dims returns Annotation in the end and Annotation returns thing so we put $$ = $1 here
		;	
			
UnannTypeVariable
		: IDENTIFIER											{ $$ = $1; } // Adon
		;	

// Start work by An
MethodBody
		:  Block 												{ $$= $1; }  // Adon
		| ';'													{ $$= null;} // Adon
		;

Annotations
		: Annotations Annotation								{ $$ = new Anotations($2); } // Adon
		| /* Empty */											{ $$ = null; } // Adon
		;

Block 
		: '{' BlockStatements_Opt '}'							{ } // Tristan
		;

BlockStatements_Opt
		: BlockStatements										{ } // Tristan
		| /* Empty */											{ } // Tristan
		;

BlockStatements
		: BlockStatement 
		| BlockStatements BlockStatement				{ } // Tristan
		;

BlockStatement
		: LocalVariableDeclarationsAndStatement					{ $$ = $1; } // Vivian
		| Statement												{ $$ = $1; } // Vivian
		;

LocalVariableDeclarationsAndStatement
		: LocalVariableDeclaration ';'							{ $$ = new LocalVariableDeclarationsAndStatement($1); } // Vivian
		;

LocalVariableDeclaration
		: UnannType VariableDeclaratorList						{ $$ = new LocalVariableDeclaration($1,$2); } // Vivian
		;

VariableDeclaratorList
		: VariableDeclarator									{ } // An
		| VariableDeclaratorList VariableDeclarator				{ } // An
		;

VariableDeclarator
		: VariableDeclaratorId									{ } // An
		;

VariableDeclaratorId
		: IDENTIFIER Dims_Opt									{ } // An
		;

// Tristan
StatementWithoutTrailingSubstatement
		: ExpressionStatement 									{ } // An
		;

ExpressionStatement
		: StatementExpression ';'								{ $$ = new ExpressionStatement($1) } // Khoa
		;

StatementExpression
		: Assignment											{ $$ = new StatementExpression($1)} // Khoa
		;

// End Work by Tristan
//work by sneha

Assignment
		: LeftHandSide AssignmentOperator Expression			{ $$ = new AssignmentExpression($1, $3) } // Khoa
		;

LeftHandSide
		: ExpressionName										{ $$ = $1} // Khoa
		;

ExpressionName
		: IDENTIFIER											{ $$ = $1 } // Khoa
		;

AssignmentOperator
		: '='													 // Khoa
		;

AssignmentExpression
		: ArrayAccess											{ $$ = $1; } // Nathan
		;

ArrayAccess
		: PrimaryNoNewArray										{ $$ = $1; } // Nathan
		;

PrimaryNoNewArray
		: Literal												{  } // Nathan
		;

Literal
		: IntegerLiteral										{ $$ = new IntegerLiteralExpression($1); } // Nathan
		;

// end of sneha Work

%%

public Parser(Scanner scanner) : base(scanner)
{
}