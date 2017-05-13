%namespace IFN660_Java_ECMAScript

%using System.Collections;
%using IFN660_Java_ECMAScript.AST;

%{
public static Statement root;
%}

%union
{
    public long num;
	public double floatnum;
	public bool boolval;
	public char charval;
    public string name;
	public Statement stmt;
	public List<Statement> stmts;
	public Expression expr;
	public AST.Type type;
	public Modifier modf;
	public List<Modifier> modfs;
	public ArrayList arrlst;
	public List<string> strlst;
}

// Types
%type <expr> Literal, StatementExpression, Assignment, LeftHandSide, ExpressionName
%type <expr> TypeParameters_opt, Superclass_opt, Superinterfaces_opt
%type <expr> AssignmentExpression, PrimaryNoNewArray
%type <expr> Expression, LambdaExpression, LambdaExpression, LambdaBody
%type <expr> ConditionalExpression, ConditionalOrExpression, ConditionalAndExpression
%type <expr> InclusiveOrExpression, ExclusiveOrExpression, AndExpression, EqualityExpression
%type <expr> RelationalExpression, ShiftExpression, AdditiveExpression, MultiplicativeExpression
%type <expr> UnaryExpression, PostfixExpression, Primary //Josh
%type <expr> PreIncrementExpression,  PreDecrementExpression, UnaryExpressionNotPlusMinus //Josh
%type <expr> CastExpression, PostIncrementExpression, PostDecrementExpression //Josh

%type <stmt> Statement, CompilationUnit, TypeDeclaration, ClassDeclaration, NormalClassDeclaration, ClassBodyDeclaration
%type <stmt> ExpressionStatement, StatementWithoutTrailingSubstatement, LocalVariableDeclaration, LocalVariableDeclarationStatement
%type <stmt> BlockStatement, Throws_opt, ClassMemberDeclaration, MethodDeclaration, FormalParameter
%type <stmt> PackageDeclaration_opt, Block, MethodBody
%type <stmt> StatementNoShortIf, IfThenElseStatementNoShortIf
%type <stmt> IfThenStatement, IfThenElseStatement, WhileStatement 
%type <stmt> TryStatement, Catches, Catches_opt, CatchClause, Finally

%type <stmts> TypeDeclarations, ClassBody, ClassBodyDeclarations, BlockStatements, BlockStatements_Opt
%type <stmts> FormalParameters, FormalParameterList, FormalParameterList_Opt 
%type <stmts> ImportDeclarations

%type <type> Result, FloatingPointType, IntegralType, NumericType
%type <type> UnannType, UnannPrimitiveType, UnannReferenceType, UnannArrayType, UnannTypeVariable, ReferenceType

%type <modf> ClassModifier, MethodModifier, VariableModifier

%type <modfs> ClassModifiers, MethodModifiers, VariableModifiers

%type <name> VariableDeclaratorId, VariableDeclarator

%type <arrlst> MethodHeader, MethodDeclarator

%type <strlst> VariableDeclaratorList

// Tokens
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

Empty	:
		;

// Group A Start
CompilationUnit 
		: PackageDeclaration_opt ImportDeclarations TypeDeclarations	{ $$ = new CompilationUnitDeclaration($1,$2,$3);  } // Josh
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
		: ClassModifiers CLASS IDENTIFIER TypeParameters_opt Superclass_opt Superinterfaces_opt ClassBody {  $$ = new ClassDeclaration($3,$1,$7); } // Vivian
		;

ClassModifiers 
		: ClassModifiers ClassModifier							{ $$ = $1; $$.Add($2); } // Vivian - Updated by Nathan
		| /* empty */											{ $$ = new List<Modifier>(); } // Vivian - Updated by Nathan
		;

ClassModifier 
		: PUBLIC												{ $$ = Modifier.PUBLIC; } // Adon
		| PROTECTED 											{ $$ = Modifier.PROTECTED; } // Adon
		| PRIVATE 												{ $$ = Modifier.PRIVATE; } // Adon
		| ABSTRACT 												{ $$ = Modifier.ABSTRACT; } // Adon
		| STATIC 												{ $$ = Modifier.STATIC; } // Adon
		| FINAL 												{ $$ = Modifier.FINAL; } // Adon
		| STRICTFP 												{ $$ = Modifier.STRICTFP; } // Adon
		; //: Annotation										{ $$ = $1; } // Adon - removed by Nathan - too hard at the moment


//GROUP C TRACKING
TypeParameters_opt : /* empty */								{ $$ = null; } // Tristan
		;

Superclass_opt : /* empty */									{ $$ = null; } // Tristan
		;

Superinterfaces_opt : /* empty */								{ $$ = null; } // Tristan
		;

ClassBody 
		: '{' ClassBodyDeclarations '}'							{ $$ = $2; } // Tristan
		;

// Group A End

// PartB by Adon Mofified by Josh to remove MemberDeclarations as it is unessisary
ClassBodyDeclarations
		: ClassBodyDeclarations ClassBodyDeclaration			{ $$ = $1; $$.Add($2); } // Tristan
		| /* empty */											{ $$ = new List<Statement>(); } // Tristan - updated by Nathan
        ;

ClassBodyDeclaration
		: ClassMemberDeclaration								{ $$ = $1; } // Tristan - done by Khoa
        ;

// Fixed by An
ClassMemberDeclaration
		: MethodDeclaration										{ $$ = $1; } // Vivian
		;

// Change ClassMemberDeclaration to MethodDeclaration -An	
MethodDeclaration
		: MethodModifiers MethodHeader MethodBody				{ $$ = new MethodDeclaration( (string)((ArrayList)$2[1])[0], $1, $3, (AST.Type)$2[0], (List<Statement>)((ArrayList)$2[1])[1]); } // Vivian - updated by Nathan
        ;

MethodModifiers
        : MethodModifiers MethodModifier						{ $$ = $1; $$.Add($2); } // Vivian
		| /* Empty */											{ $$ = new List<Modifier>(); } // Vivian
        ;

MethodModifier 
		: PUBLIC												{ $$ = Modifier.PUBLIC; } // Vivian
        | STATIC												{ $$ = Modifier.STATIC; } // vivian
        ; //: Annotation										{ $$ = $1; } // Vivian - removed by Nathan - too hard at the moment

MethodHeader
		: Result MethodDeclarator Throws_opt					{$$ = new ArrayList() { $1, $2, $3 } ; } // Khoa
        ;

// End Fix
// End GroupB

//WORK BY JOSH HUDSON
Result 
		: VOID													{$$ = new NamedType("VOID"); } // Khoa
		| UnannType												{$$ = $1; } // Khoa
	   	;

Throws_opt
		: Empty													{$$ = null; } // Khoa - updated by Nathan
	  	;

// Fixed spelling error	 
MethodDeclarator
		: IDENTIFIER '(' FormalParameterList_Opt ')' Dims_Opt	{$$ =  new ArrayList() { $1, $3, $5 };} // Khoa
		;

//PLACEHOLDER - Josh - Tri
FormalParameterList_Opt
		: FormalParameterList									{ $$ = $1; } // Nathan
		| /* empty */											{ $$ = null; } // Nathan
		;

// JOSHUA'S WORK END

//Work by Tri
FormalParameterList 
		: FormalParameters 										{ $$ = $1; } // Nathan
		;

FormalParameters 
		: FormalParameter 										{ $$ = new List<Statement> { $1 }; } // Nathan 
		| FormalParameters ',' FormalParameter					{ $$ = $1; $$.Add($3); } // Nathan
		;

FormalParameter 
		:  VariableModifiers UnannType VariableDeclaratorId		{ $$ = new VariableDeclaration($2, $3); } // Nathan - doesn't allow VariableModifiers at the moment
		;
VariableModifiers 
		: VariableModifiers VariableModifier					{ $$ = $1; $$.Add($2); } // Nathan
		| /* empty */											{ $$ = new List<Modifier>(); }// Nathan
		;

VariableModifier 
		: FINAL													{ $$ = Modifier.FINAL; } // Tri - updated by Nathan
		; //: Annotation										{ $$ = $1; } // Tri - removed by Nathan - too hard at the moment

//End work by Tri
// Work by Vivian
Dims_Opt 
		: Dims													{ $$ = $1; } // An - updated by Adon
		| /* Empty */											{ } // An - not implemented yet
		;

Dims
		: '['']'									
		//Annotations '['']'									{ $$ = $1; } // Needs work - Tri - removed by Nathan - too hard at the moment
		;

UnannType
		: UnannReferenceType									{ $$ = $1; } // Tri
		| UnannPrimitiveType									{ $$ = $1; } // Tri
		;

UnannPrimitiveType
		: NumericType											{ $$ = $1; } // Josh
		| BOOLEAN												{ $$ = new NamedType("BOOLEAN"); } // Josh
		;


PrimitiveType
		:  NumericType  //Annotations infront 
		|  BOOLEAN      //Annotations infront
		;

ReferenceType
		: TypeVariable
        //| ClassOrInterfaceType
		//| //ArrayType							// Cause reduce/reduce conflict
		;

TypeVariable
		:  IDENTIFIER //Annotations
		;

NumericType
		: IntegralType											{ $$ = $1; } // Josh
		| FloatingPointType										{ $$ = $1; } // Josh
		;

IntegralType
		: BYTE													{ $$ = new NamedType("BYTE");  } // Josh - updated by Nathan
		| SHORT													{ $$ = new NamedType("SHORT");  } // Josh - updated by Nathan
		| INT													{ $$ = new NamedType("INT");} // Vivian - updated by Nathan
		| LONG													{ $$ = new NamedType("LONG"); } // Vivian - updated by Nathan
		| CHAR													{ $$ = new NamedType("CHAR"); } // Vivian - updated by Nathan
		;

FloatingPointType
		: FLOAT													{ $$ = new NamedType("FLOAT"); } // Vivian - updated by Nathan
		| DOUBLE												{ $$ = new NamedType("DOUBLE"); } // Vivian - updated by Nathan
		;

UnannReferenceType
		: UnannArrayType										{ $$ = $1; } // Vivian
		;

// Vivian's work end
// Work by Khoa - Fixed by An
UnannArrayType
		: UnannTypeVariable Dims								{ $$ = new ArrayType($1); } // Adon: Not sure but Dims returns Annotation in the end and Annotation returns thing so we put $$ = $1 here
		;	
			
UnannTypeVariable
		: IDENTIFIER											{ $$ = new NamedType($1); } // Adon
		;	

// Start work by An
MethodBody
		:  Block 												{ $$= $1; }  // Adon
		| ';'													{ $$= null;} // Adon
		;

// Removed by Nathan - too hard at the moment
//Annotations
//		: Annotations Annotation								{ $$ = new Annotations($2); } // Adon
//		| /* Empty */											{ $$ = null; } // Adon
//		;

Block 
		: '{' BlockStatements_Opt '}'							{ $$ = new BlockStatement($2); } // Tristan
		;

BlockStatements_Opt
		: BlockStatements										{ $$ = $1; } // Tristan - done by Khoa
		| /* Empty */											{ $$ = null; } // Tristan - done by Khoa
		;

BlockStatements
		: BlockStatement										{ $$ = new List<Statement> { $1 }; } // Tristan - done by Khoa
		| BlockStatements BlockStatement						{ $$ = $1; $$.Add($2); } // Tristan - done by Khoa
		;

BlockStatement
		: LocalVariableDeclarationStatement						{ $$ = $1; } // Vivian
		| Statement												{ $$ = $1; } // Vivian
		;

LocalVariableDeclarationStatement
		: LocalVariableDeclaration ';'							{ $$ = $1; } // Vivian - updated by Nathan
		;

LocalVariableDeclaration
		: UnannType VariableDeclaratorList						{ $$ = new VariableDeclarationList($1, $2); } // Vivian
		//: VariableModifiers UnannType VariableDeclaratorList	{ $$ = new VariableDeclarationList($1, $2); } // Vivian - too hard at the moment - Nathan
		;

// Too hard at the moment - Nathan
VariableDeclaratorList
		: VariableDeclarator									{ $$ = new List<string> { $1 }; } // Nathan
		| VariableDeclaratorList ',' VariableDeclarator			{ $$ = $1; $$.Add($3); } // Nathan
		;

VariableDeclarator
		: VariableDeclaratorId									{ $$ = $1; } // Nathan
		;

VariableDeclaratorId
		: IDENTIFIER Dims_Opt									{ $$ = $1; } // Nathan
		;
// Nathan
Statement
		: StatementWithoutTrailingSubstatement					{ $$ = $1; } // Nathan
		| IfThenStatement										{ $$ = $1; } // Adon
		| IfThenElseStatement									{ $$ = $1; } // Adon
		| WhileStatement										{ $$ = $1; } // Nathan
		| TryStatement											{ $$ = $1; } // Adon
		;
		
StatementNoShortIf
		: StatementWithoutTrailingSubstatement					{$$ = $1; } // Adon
		| IfThenElseStatementNoShortIf							{$$ = $1; } // Adon
		;

// Tristan
StatementWithoutTrailingSubstatement
		: ExpressionStatement 									{ $$ = $1; } // Nathan - done by Khoa
		| Block													{ $$ = $1; } // Nathan
		;

ExpressionStatement
		: StatementExpression ';'								{ $$ = new ExpressionStatement($1); } // Khoa
		;

StatementExpression
		: Assignment											{ $$ = $1; } // Khoa - updated by Nathan
		;

IfThenStatement
		: IF '(' Expression ')' Statement						{ $$ = new IfStatement($3, $5,null); } // Adon
		//: IF '(' Expression ')' BlockStatements						{ $$ = new IfStatement($3, $5,null); } // Adon
		;

IfThenElseStatement
		: IF '(' Expression ')' StatementNoShortIf ELSE Statement				{ $$ = new IfStatement($3, $5, $7); } // Adon
		;

IfThenElseStatementNoShortIf
		: IF '(' Expression ')' StatementNoShortIf ELSE StatementNoShortIf		{ $$ = new IfStatement($3, $5, $7); } //Adon
		;

WhileStatement
		: WHILE '(' Expression ')' Statement					{ $$ = new WhileStatement($3, $5); } // Nathan
		;

TryStatement
		: TRY Block Catches										{ $$ = new TryStatement($2, $3, null); } //Adon
		| TRY Block Catches_opt Finally							{ $$ = new TryStatement($2, $3, $4); } //Adon
		//| TryWithResourcesStatement
		;

Catches_opt
		: Catches												{ $$ =  $1; } //Adon
		| /* empty */											{ } //Adon
		;

Catches
		: CatchClause											{ $$ =  $1; } //Adon
//		| Catches CatchClause									{ } //Adon
		;

CatchClause
		//: CATCH '(' CatchFromalParameter ')' Block				{ } //Adon - too hard to be implemented right now, use the following simplified version instead
																		//		see paser_try.y to check the nessary paser rules for a ful try statement
		: CATCH '(' ')' Block										{ $$ = $4; } //Adon
		;

//CatchFromalParameter
//		: VariableModifiers CatchType VariableDeclaratorId		{ } //Adon
//		;

//CatchType
//		: UnannClassType										{ } //Adon
//		| CatchType '|' CatchType								{ } //Adon
//		;

//Finally_opt
//		: Finally												{ $$ = $1; } //Adon
//		|
//		;

Finally
		: FINALLY Block											{ $$ = $2; } //Adon
		;

//TryWithResourcesStatement
//		: TRY ResourceSpecification Block Catches_opt Finally_opt
//		;

// End Work by Tristan
//work by sneha

Assignment
		: LeftHandSide AssignmentOperator Expression			{ $$ = new AssignmentExpression($1, $3); } // Khoa
		;

LeftHandSide
		: ExpressionName										{ $$ = $1; } // Khoa
		;

ExpressionName
		: IDENTIFIER											{ $$ = new VariableExpression($1);  } // Khoa - updated by Nathan
		;

AssignmentOperator
		: '='													 // Khoa
		;

AssignmentExpression
		: Assignment											{ $$ = $1; } // Nathan
		| ConditionalExpression									{ $$ = $1; } // Nathan
		;

Primary
		: PrimaryNoNewArray										{ $$ = $1; } // Nathan
		;

PrimaryNoNewArray
		: Literal												{ $$ = $1; } // Nathan
		;

Literal
		: IntegerLiteral										{ $$ = new IntegerLiteralExpression($1); } // Nathan
		| FloatingPointLiteral									{ $$ = new FloatingPointLiteralExpression($1); } // Adon
		| BooleanLiteral										{ $$ = new BooleanLiteralExpression($1); } // Adon
		| CharacterLiteral										{ $$ = new CharacterLiteralExpression($1); } // Adon
		;
// end of sneha Work

// Nathan
Expression
		: LambdaExpression										{ $$ = $1; } // Nathan
		| AssignmentExpression									{ $$ = $1; } // Nathan
		;

LambdaExpression
		: LambdaParameters ARROW LambdaBody						{ } // not implemented yet - Nathan
		;

LambdaParameters
		: /* empty */											{ } // not implemented yet - Nathan
		;

LambdaBody
		: /* empty */											{ } // not implemented yet
		;

ConditionalExpression
		: ConditionalOrExpression												{ $$ = $1; } // Nathan
		//| ConditionalOrExpression '?' Expression ':' ConditionalExpression	{ $$ = new TernaryExpression($1, $3, $5); } // not implemented yet - Nathan
		//| ConditionalOrExpression '?' Expression ':' LambdaExpression			{ $$ = new TernaryExpression($1, $3, $5); } // not implemented yet - Nathan
		;

ConditionalOrExpression
		: ConditionalAndExpression										{ $$ = $1; } // Nathan
		| ConditionalOrExpression LOGICAL_OR ConditionalAndExpression	{ $$ = new BinaryExpression($1, "||", $3); } // Nathan
		;

ConditionalAndExpression
		: InclusiveOrExpression											{ $$ = $1; } // Nathan
		| ConditionalAndExpression LOGICAL_AND InclusiveOrExpression	{ $$ = new BinaryExpression($1, "&&", $3); } // Nathan
		;

InclusiveOrExpression
		: ExclusiveOrExpression											{ $$ = $1; } //Nathan
		| InclusiveOrExpression '|' ExclusiveOrExpression				{ $$ = new BinaryExpression($1, "|", $3); }
		;

ExclusiveOrExpression
		: AndExpression													{ $$ = $1; } //Nathan
		| ExclusiveOrExpression '^' AndExpression						{ $$ = new BinaryExpression($1, "^", $3); }
		;

AndExpression
		: EqualityExpression											{ $$ = $1; } //Nathan
		| AndExpression '&' EqualityExpression							{ $$ = new BinaryExpression($1, "&", $3); }
		;

EqualityExpression
		: RelationalExpression											{ $$ = $1; } //Nathan
		| EqualityExpression EQUAL RelationalExpression					{ $$ = new BinaryExpression($1, "==", $3); }
		| EqualityExpression NOT_EQUAL RelationalExpression				{ $$ = new BinaryExpression($1, "!=", $3); }	
		;		

RelationalExpression
		: ShiftExpression												{ $$ = $1; } //Nathan
		| RelationalExpression '<' ShiftExpression						{ $$ = new BinaryExpression($1, "<", $3); }
		| RelationalExpression '>' ShiftExpression						{ $$ = new BinaryExpression($1, ">", $3); }
		| RelationalExpression LESS_THAN_OR_EQUAL ShiftExpression		{ $$ = new BinaryExpression($1, "<=", $3); }
		| RelationalExpression GREATER_OR_EQUAL ShiftExpression			{ $$ = new BinaryExpression($1, ">=", $3); }
		| RelationalExpression INSTANCEOF ReferenceType					{ $$ = new InstanceOfExpression($1, $3); }
		;

ShiftExpression
		: AdditiveExpression											{ $$ = $1; } //Nathan
		| ShiftExpression LEFT_SHIFT AdditiveExpression					{ $$ = new BinaryExpression($1, "<<", $3); }
		| ShiftExpression SIGNED_RIGHT_SHIFT AdditiveExpression			{ $$ = new BinaryExpression($1, ">>", $3); }
		| ShiftExpression UNSIGNED_RIGHT_SHIFT AdditiveExpression		{ $$ = new BinaryExpression($1, ">>>", $3); }
		;

AdditiveExpression
		: MultiplicativeExpression									{ $$ = $1; } //Nathan
		| AdditiveExpression '+' MultiplicativeExpression			{ $$ = new BinaryExpression($1, "+", $3); } //Nathan
		| AdditiveExpression '-' MultiplicativeExpression			{ $$ = new BinaryExpression($1, "-", $3); } //Nathan
		;

MultiplicativeExpression
		: UnaryExpression
		| MultiplicativeExpression '*' UnaryExpression					{ $$ = new BinaryExpression($1, "*", $3); }
		| MultiplicativeExpression '/' UnaryExpression					{ $$ = new BinaryExpression($1, "/", $3); }
		| MultiplicativeExpression '%' UnaryExpression					{ $$ = new BinaryExpression($1, "%", $3); }
		;
		
UnaryExpression
		:  PreIncrementExpression									{ $$ = $1; } // Khoa
		| PreDecrementExpression									{ $$ = $1; } // Khoa
		| '+' UnaryExpression										{ $$ = new PreUnaryExpression("+", $2); } // Khoa & Josh
		| '-' UnaryExpression										{ $$ = new PreUnaryExpression("-", $2); } // Khoa & Josh
		| UnaryExpressionNotPlusMinus								{ $$ = $1; } // Khoa
		//PostfixExpression											{ $$ = $1; }   // Nathan; fixed by Khoa 
        // Reduce/reduce conflict here
        // Since we can access PostfixExpression via UnaryExpressionNotPlusMinus
        // Then just remove it to solve conflict - AN
        ;

PreIncrementExpression
		: INCREMENT UnaryExpression									{ $$ = new PreUnaryExpression("++", $2); }  // Khoa & Josh
		;

PreDecrementExpression
		: DECREMENT UnaryExpression									{ $$ = new PreUnaryExpression("--", $2); } // Khoa & Josh
		;

UnaryExpressionNotPlusMinus
		: PostfixExpression											{ $$ = $1;} // Khoa
		| '~' UnaryExpression										{ $$ = new PreUnaryExpression("~", $2); } // Khoa & Josh
		| '!' UnaryExpression										{ $$ = new PreUnaryExpression("!", $2); } // Khoa & Josh
		| CastExpression											{ $$ = $1;} // Khoa
		;

PostfixExpression
		: Primary													{ $$ = $1; } //Nathan
		| ExpressionName											{ $$ = $1; } //Nathan
		| PostIncrementExpression									{ $$ = $1; } //Josh
		| PostDecrementExpression									{ $$ = $1; } //Josh
		;

PostIncrementExpression
		: PostfixExpression INCREMENT									{ $$ = new PostUnaryExpression($1, "++"); } // Khoa & Josh
		;

PostDecrementExpression
		: PostfixExpression DECREMENT									{ $$ = new PostUnaryExpression($1, "--"); } // Khoa & Josh
		;

CastExpression
		: '(' PrimitiveType ')' UnaryExpression
		| '(' ReferenceType AdditionalBounds ')' UnaryExpressionNotPlusMinus
		| '(' ReferenceType AdditionalBounds ')' LambdaExpression
		;

AdditionalBounds
		: AdditionalBounds AdditionalBound
		|
		;

AdditionalBound
		: '&' //InterfaceType
		;

ConstantExpression
		: Expression
		;

%%

public Parser(Scanner scanner) : base(scanner)
{
}