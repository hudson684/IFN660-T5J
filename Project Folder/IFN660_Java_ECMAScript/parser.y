<<<<<<< HEAD
%namespace IFN660_Java_ECMAScript

%using System.Collections;
%using IFN660_Java_ECMAScript.AST;

%{
public static Statement root;
%}

%union
{
    public ILiteral num;
	public ILiteral floatnum;
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
	public List<Expression> exprlst;
	public VariableDeclarator vardec;
	public List<VariableDeclarator> vardeclst;
}

// Types
%type <expr> Literal, StatementExpression, Assignment, LeftHandSide, ExpressionName, LocalVariableDeclaration
%type <expr> TypeParameters_opt, Superclass_opt, Superinterfaces_opt
%type <expr> AssignmentExpression, PrimaryNoNewArray
%type <expr> Expression, LambdaExpression, LambdaExpression, LambdaBody
%type <expr> ConditionalExpression, ConditionalOrExpression, ConditionalAndExpression
%type <expr> InclusiveOrExpression, ExclusiveOrExpression, AndExpression, EqualityExpression
%type <expr> RelationalExpression, ShiftExpression, AdditiveExpression, MultiplicativeExpression
%type <expr> UnaryExpression, PostfixExpression, Primary //Josh
%type <expr> PreIncrementExpression,  PreDecrementExpression, UnaryExpressionNotPlusMinus, ConstantExpression //Josh
%type <expr> CastExpression, PostIncrementExpression, PostDecrementExpression //Josh
%type <expr> MethodInvocation, FormalParameter, VariableInitialiser

%type <exprlst> ArgumentList, ArgumentList_opt
%type <exprlst> FormalParameters, FormalParameterList, FormalParameterList_Opt 

%type <stmt> Statement, CompilationUnit, TypeDeclaration, ClassDeclaration, NormalClassDeclaration, ClassBodyDeclaration
%type <stmt> ExpressionStatement, StatementWithoutTrailingSubstatement, LocalVariableDeclarationStatement
%type <stmt> BlockStatement, Throws_opt, ClassMemberDeclaration, MethodDeclaration
%type <stmt> PackageDeclaration_opt, Block, MethodBody
%type <stmt> StatementNoShortIf, IfThenElseStatementNoShortIf
%type <stmt> IfThenStatement, IfThenElseStatement, WhileStatement 
%type <stmt> TryStatement, Catches, Catches_opt, CatchClause, Finally
%type <stmt> PackageDeclaration_opt, Block, MethodBody
%type <stmt> StatementNoShortIf
%type <stmt> DoStatement, ThrowStatement, SynchronizedStatement
%type <stmt> SwitchStatement, SwitchBlockStatementGroup, SwitchLabel
%type <stmt> AssertStatement
%type <stmt> LabeledStatement, BreakStatement, ContinueStatement, ReturnStatement
%type <stmt> ImportDeclaration
%type <stmt> ForUpdate, BasicForStatement, BasicForStatementNoShortIf, ForStatement, ForStatementNoShortIf
%type <stmt> EnhancedForStatementNoShortIf, EnhancedForStatement, ForInit

%type <stmts> TypeDeclarations, ClassBody, ClassBodyDeclarations, BlockStatements, BlockStatements_Opt
%type <stmts> ImportDeclarations, SwitchLabels, SwitchBlockStatementGroups, SwitchBlock

%type <type> Result, FloatingPointType, IntegralType, NumericType
%type <type> UnannType, UnannPrimitiveType, UnannReferenceType, UnannArrayType, UnannTypeVariable, ReferenceType, PrimitiveType

%type <modf> ClassModifier, MethodModifier, VariableModifier

%type <modfs> ClassModifiers, MethodModifiers, VariableModifiers

%type <name> VariableDeclaratorId, PackageOrTypeName, MethodName

%type <arrlst> MethodHeader, MethodDeclarator

%type <vardec> VariableDeclarator
%type <vardeclst> VariableDeclaratorList

%type <name> Identifier_opt
%type <expr> Expression_opt
%type <name> TypeName

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
		
//add import declaration-Vivian
ImportDeclarations
		: ImportDeclaration												{ $$ = new List<Statement> {$1};} //Vivian	
		| ImportDeclarations ImportDeclaration						    { $$ = $1; $$.Add($2);} //Vivian
		|						
		;

ImportDeclaration
		: IMPORT TypeName ';'											{  $$ = new ImportDeclaration($2); } //Vivian
		| IMPORT TypeName '.' '*' ';' 									{  $$ = new ImportDeclaration($2); } //Vivian
		| IMPORT STATIC TypeName '.' IDENTIFIER ';'						{  $$ = new ImportDeclaration($3,$5); } //Vivian
		| IMPORT STATIC TypeName '.' '*' ';'                            {  $$ = new ImportDeclaration($3); } //Vivian
		;

TypeName
		:IDENTIFIER
		|TypeName '.' IDENTIFIER
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
		: MethodModifiers MethodHeader MethodBody				{ $$ = new MethodDeclaration( (string)((ArrayList)$2[1])[0], $1, $3, (AST.Type)$2[0], (List<Expression>)((ArrayList)$2[1])[1]); } // Vivian - updated by Nathan
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
		: FormalParameter 										{ $$ = new List<Expression> { $1 }; } // Nathan 
		| FormalParameters ',' FormalParameter					{ $$ = $1; $$.Add($3); } // Nathan
		;

FormalParameter 
		:  VariableModifiers UnannType VariableDeclaratorId		{ $$ = new FormalParam($2, $3); } // Nathan - doesn't allow VariableModifiers at the moment
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
		| UnannTypeVariable										{ $$ = $1; } // Nathan
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
		: BlockStatement										{ $$ = new List<Statement> { $1 };} // Joshua
		| BlockStatements BlockStatement						{ $$ = $1; $$.Add($2); } // Joshua
		;

BlockStatement
		: LocalVariableDeclarationStatement						{ $$ = $1; } // Vivian
		| Statement												{ $$ = $1; } // Vivian
		;

LocalVariableDeclarationStatement
		: LocalVariableDeclaration ';'							{ $$ = new VariableDeclarationStatement($1); } // Vivian - updated by Nathan
		;

LocalVariableDeclaration
		: UnannType VariableDeclaratorList						{ $$ = new VariableDeclarationList($1, $2); } // Vivian
		//: VariableModifiers UnannType VariableDeclaratorList	{ $$ = new VariableDeclarationList($1, $2); } // Vivian - too hard at the moment - Nathan
		;

// Too hard at the moment - Nathan
VariableDeclaratorList
		: VariableDeclarator									{ $$ = new List<VariableDeclarator> { $1 }; } // Nathan
		| VariableDeclaratorList ',' VariableDeclarator			{ $$ = $1; $$.Add($3); } // Nathan
		;

VariableDeclarator
		: VariableDeclaratorId									{ $$ = new VariableDeclarator($1, null); } // Nathan
		| VariableDeclaratorId '=' VariableInitialiser			{ $$ = new VariableDeclarator($1, $3); } // Nathan
		;

VariableInitialiser
		: Expression											{ $$ = $1; } // Nathan
		;

VariableDeclaratorId
		: IDENTIFIER Dims_Opt									{ $$ = $1; } // Nathan - array types not yet supported
		;
// Nathan
Statement
		: StatementWithoutTrailingSubstatement					{ $$ = $1; } // Nathan
		| IfThenStatement										{$$ = $1; } // Adon
		| IfThenElseStatement									{$$ = $1; } // Adon
		| WhileStatement										{ $$ = $1; } // Nathan
		| LabeledStatement										 { $$ = $1;} //Vivian
		| ForStatement											{$$ = $1;}
		;
		
StatementNoShortIf
		: StatementWithoutTrailingSubstatement					{$$ = $1; } // Adon
		| IfThenElseStatementNoShortIf							{$$ = $1; } // Adon
		| ForStatementNoShortIf									{$$ = $1;}
		;

// Tristan
StatementWithoutTrailingSubstatement
		: ExpressionStatement 									{ $$ = $1; } // Nathan - done by Khoa
		| Block													{ $$ = $1; } // Nathan
		| BreakStatement										{ $$ = $1;} //Vivian
		| DoStatement											{ $$ = $1; } //Tri
		| ContinueStatement										{ $$ = $1;} //Vivian
		| ReturnStatement										{ $$ = $1;} //Vivian
		| ThrowStatement										{ $$ = $1;} // KoJo
		| SynchronizedStatement									{ $$ = $1;} // KoJo
		| SwitchStatement										{ $$ = $1;} //Tri
		| AssertStatement										{ $$ = $1;} //Tri
		| TryStatement											{ $$ = $1;} //Adon
		;

AssertStatement
		: ASSERT Expression ';'									{ $$ = new AssertStatement($2);} //Tri
		| ASSERT Expression ':' Expression ';'					{ $$ = new AssertStatement($2, $4);} //Tri
		;

SwitchStatement
		: SWITCH '(' Expression ')'	SwitchBlock					{ $$ = new SwitchStatement($3, $5); } //Kojo
		;

SwitchBlock
		: '{' SwitchBlockStatementGroups '}'						{ $$ = $2; } //Kojo
		;

SwitchBlockStatementGroups
		: SwitchBlockStatementGroup									{ $$ = new List<Statement> {$1}; }  //KoJo
		| SwitchBlockStatementGroups SwitchBlockStatementGroup		{ $$ = $1; $$.Add($2); }  //KoJo
		;

SwitchBlockStatementGroup
		: SwitchLabels BlockStatements							{ $$ = new SwitchBlockGroup($1, $2); } //Kojo
		;

SwitchLabels
		: SwitchLabel												{ $$ = new List<Statement> {$1};} //KoJo
		| SwitchLabels SwitchLabel									{ $$ = $1; $$.Add($2); }   // KoJo
		;

SwitchLabel
		: CASE ConstantExpression ':'							{ $$ = new SwitchLabelStatement($2) ;} // KoJo
		| DEFAULT ':'											{ $$ = new SwitchLabelStatement(); } // KoJo
		;


DoStatement
		: DO Statement WHILE '(' Expression ')'	';'				{ $$ = new DoStatement($2, $5); } // Tri
		;
ForStatement
		: BasicForStatement										{$$ = $1;}
		| EnhancedForStatement									{$$ = $1;}
		;

ForStatementNoShortIf
		: BasicForStatementNoShortIf							{$$ = $1;}
		| EnhancedForStatementNoShortIf							{$$ = $1;}
		;

BasicForStatement
		: FOR '(' ForInit ';' Expression ';' ForUpdate ')' Statement							//{$$ = new ForStatement($3,$5,$7,$9);}
		;

BasicForStatementNoShortIf
		: FOR '(' ForInit ';' Expression ';' ForUpdate ')' StatementNoShortIf					//{$$ = new ForStatement($3,$5,$7,$9);}
		;

ForInit
		: 
		//| StatementExpressionList											{$$ = $1;}					
		//| LocalVariableDeclaration											{$$ = $1;}			
		;

ForUpdate
		: 
		| StatementExpressionList
		;

StatementExpressionList
		: StatementExpression												//{$$ = new List<Statement>(){new ExpressionStatement($1)};}
		| StatementExpressionList ',' StatementExpression					//{$$ = $1; $$.Add(new ExpressionStatement($3));}
		;

EnhancedForStatement
		: FOR '(' VariableModifiers UnannType VariableDeclaratorId ':' Expression ')' Statement   {$$= new EnhancedForStatement($3,$4,$5,$7,$9);}
		;

EnhancedForStatementNoShortIf
		: FOR '(' VariableModifiers UnannType VariableDeclaratorId ':' Expression ')' StatementNoShortIf
		;				 
ThrowStatement
		: THROW Expression ';'									{ $$ = new ThrowStatement($2); } //KoJo
		;

SynchronizedStatement
		: SYNCHRONIZED '(' Expression ')' Block					{ $$ = new SynchronizedStatement($3, $5); }  //KoJo
		;

ExpressionStatement
		: StatementExpression ';'								{ $$ = new ExpressionStatement($1); } // Khoa
		;

StatementExpression
		: Assignment											{ $$ = $1; } // Khoa - updated by Nathan
		| MethodInvocation										{ $$ = $1; } // Nathan
		| PreIncrementExpression								{ $$ = $1; }  //sneha
		| PreDecrementExpression								{ $$ = $1; }  //sneha
		| PostIncrementExpression								{ $$ = $1; }	
		| PostDecrementExpression								{ $$ = $1; }
		;

// Start method handling - Nathan
MethodInvocation
		: MethodName '(' ArgumentList_opt ')'					{ $$ = new MethodInvocation($1, $3); } // Nathan
		| PackageOrTypeName '.' IDENTIFIER '(' ArgumentList_opt ')'		{ $$ = new MethodInvocation( $1 + '.' + $3, $5); } // Nathan
		;

PackageOrTypeName
		: IDENTIFIER											{ $$ = $1; } // Nathan
		| PackageOrTypeName '.' IDENTIFIER						{ $$ = $1 + '.' + $3; } // Nathan
		;

MethodName
		: IDENTIFIER											{ $$ = $1; } // Nathan
		;

ArgumentList_opt
		: ArgumentList											{ $$ = $1; } // Nathan
		| /* empty */											{ } // Nathan
		;

ArgumentList
		: ArgumentList ',' Expression							{ $$ = $1; $$.Add($3); } // Nathan
		| Expression											{ $$ = new List<Expression> {$1}; } // Nathan
		;
// end method handling

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
																		//		see paser_try.y to check the nessary paser rules for a full try statement
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

//Add Labeledstatement-Vivian
LabeledStatement
		: IDENTIFIER ':' Statement								{ $$ = new LabeledStatement($1,$3);} //Vivian
		;

//Add breakstatement-Vivian
BreakStatement
		: BREAK Identifier_opt ';'									{ if($2 == null){$$ = new BreakStatement();} else {$$ = new BreakStatement($2);} } //Vivian
		;

//Add for breakstatement-Vivian		
Identifier_opt
		: IDENTIFIER															
		| 
		;

//Add continuestatement-Vivian
ContinueStatement
		: CONTINUE Identifier_opt ';'									{ if($2 == null){$$ = new ContinueStatement();} else {$$ = new ContinueStatement($2);} } //Vivian
		;

//Add returnstatement-Vivian
ReturnStatement
		: RETURN Expression_opt ';'									{ if($2 == null){$$ = new ReturnStatement();} else {$$ = new ReturnStatement($2);} } //Vivian
		;

//Add for returnstatement-Vivian
Expression_opt
		: Expression												{ $$ = $1; }// Vivian			
		| 
		;

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
		| MethodInvocation										{ $$ = $1; } // Nathan
		;

Literal
		: IntegerLiteral										{ $$ = (Expression) $1;}//new IntegerLiteralExpression($1); } // Nathan
		| FloatingPointLiteral									{$$ = (Expression)$1;}//{ $$ = new FloatingPointLiteralExpression($1); } // Adon
		| BooleanLiteral										{ $$ = new BooleanLiteralExpression($1); } // Adon
		| CharacterLiteral										{ $$ = new CharacterLiteralExpression($1); } // Adon
		| StringLiteral											{ $$ = new StringLiteralExpression($1); } //Tri
		| NullLiteral											{ $$ = new NullLiteralExpression(); } //Tri
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
		: UnaryExpression												{ $$ = $1; } //Khoa
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
		: '(' PrimitiveType ')' UnaryExpression										{ $$ = new CastExpression($2, $4); } //Khoa
		//| '(' ReferenceType AdditionalBounds ')' UnaryExpressionNotPlusMinus
		//| '(' ReferenceType AdditionalBounds ')' LambdaExpression
		;

AdditionalBounds
		: AdditionalBounds AdditionalBound
		|
		;

AdditionalBound
		: '&' //InterfaceType
		;

ConstantExpression
		: Expression {$$ = $1;} // Josh
		;

%%

public Parser(Scanner scanner) : base(scanner)
{
}
=======
%namespace IFN660_Java_ECMAScript

%using System.Collections;
%using IFN660_Java_ECMAScript.AST;

%{
public static Statement root;
%}

%union
{
    public ILiteral num;
	public ILiteral floatnum;
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
	public List<Expression> exprlst;
	public VariableDeclarator vardec;
	public List<VariableDeclarator> vardeclst;
}

// Types
%type <expr> Literal, StatementExpression, Assignment, LeftHandSide, ExpressionName, LocalVariableDeclaration
%type <expr> TypeParameters_opt, Superclass_opt, Superinterfaces_opt
%type <expr> AssignmentExpression, PrimaryNoNewArray
%type <expr> Expression, LambdaExpression, LambdaExpression, LambdaBody
%type <expr> ConditionalExpression, ConditionalOrExpression, ConditionalAndExpression
%type <expr> InclusiveOrExpression, ExclusiveOrExpression, AndExpression, EqualityExpression
%type <expr> RelationalExpression, ShiftExpression, AdditiveExpression, MultiplicativeExpression
%type <expr> UnaryExpression, PostfixExpression, Primary //Josh
%type <expr> PreIncrementExpression,  PreDecrementExpression, UnaryExpressionNotPlusMinus, ConstantExpression //Josh
%type <expr> CastExpression, PostIncrementExpression, PostDecrementExpression //Josh
%type <expr> MethodInvocation, FormalParameter, VariableInitialiser

%type <exprlst> ArgumentList, ArgumentList_opt
%type <exprlst> FormalParameters, FormalParameterList, FormalParameterList_Opt 

%type <stmt> Statement, CompilationUnit, TypeDeclaration, ClassDeclaration, NormalClassDeclaration, ClassBodyDeclaration
%type <stmt> ExpressionStatement, StatementWithoutTrailingSubstatement, LocalVariableDeclarationStatement
%type <stmt> BlockStatement, Throws_opt, ClassMemberDeclaration, MethodDeclaration
%type <stmt> PackageDeclaration_opt, Block, MethodBody
%type <stmt> StatementNoShortIf, IfThenElseStatementNoShortIf
%type <stmt> IfThenStatement, IfThenElseStatement, WhileStatement 
%type <stmt> TryStatement, Catches, Catches_opt, CatchClause, Finally
%type <stmt> PackageDeclaration_opt, Block, MethodBody
%type <stmt> StatementNoShortIf
%type <stmt> DoStatement, ThrowStatement, SynchronizedStatement
%type <stmt> SwitchStatement, SwitchBlockStatementGroup, SwitchLabel
%type <stmt> AssertStatement
%type <stmt> LabeledStatement, BreakStatement, ContinueStatement, ReturnStatement
%type <stmt> ImportDeclaration


%type <stmts> TypeDeclarations, ClassBody, ClassBodyDeclarations, BlockStatements, BlockStatements_Opt
%type <stmts> ImportDeclarations, SwitchLabels, SwitchBlockStatementGroups, SwitchBlock

%type <type> Result, FloatingPointType, IntegralType, NumericType
%type <type> UnannType, UnannPrimitiveType, UnannReferenceType, UnannArrayType, UnannTypeVariable, ReferenceType, PrimitiveType

%type <modf> ClassModifier, MethodModifier, VariableModifier

%type <modfs> ClassModifiers, MethodModifiers, VariableModifiers

%type <name> VariableDeclaratorId, PackageOrTypeName, MethodName

%type <arrlst> MethodHeader, MethodDeclarator

%type <vardec> VariableDeclarator
%type <vardeclst> VariableDeclaratorList

%type <name> Identifier_opt
%type <expr> Expression_opt
%type <name> TypeName

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
		
//add import declaration-Vivian
ImportDeclarations
		: ImportDeclaration												{ $$ = new List<Statement> {$1};} //Vivian	
		| ImportDeclarations ImportDeclaration						    { $$ = $1; $$.Add($2);} //Vivian
		|						
		;

ImportDeclaration
		: IMPORT TypeName ';'											{  $$ = new ImportDeclaration($2); } //Vivian
		| IMPORT TypeName '.' '*' ';' 									{  $$ = new ImportDeclaration($2); } //Vivian
		| IMPORT STATIC TypeName '.' IDENTIFIER ';'						{  $$ = new ImportDeclaration($3,$5); } //Vivian
		| IMPORT STATIC TypeName '.' '*' ';'                            {  $$ = new ImportDeclaration($3); } //Vivian
		;

TypeName
		:IDENTIFIER
		|TypeName '.' IDENTIFIER
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
		: MethodModifiers MethodHeader MethodBody				{ $$ = new MethodDeclaration( (string)((ArrayList)$2[1])[0], $1, $3, (AST.Type)$2[0], (List<Expression>)((ArrayList)$2[1])[1]); } // Vivian - updated by Nathan
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
		: FormalParameter 										{ $$ = new List<Expression> { $1 }; } // Nathan 
		| FormalParameters ',' FormalParameter					{ $$ = $1; $$.Add($3); } // Nathan
		;

FormalParameter 
		:  VariableModifiers UnannType VariableDeclaratorId		{ $$ = new FormalParam($2, $3); } // Nathan - doesn't allow VariableModifiers at the moment
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
		:  NumericType  //Annotations infront					{ $$ = $1; } // Khoa
		|  BOOLEAN      //Annotations infront					{ $$ = new NamedType("BOOLEAN"); } // KHoa
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
		| UnannTypeVariable										{ $$ = $1; } // Nathan
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
		: BlockStatement										{ $$ = new List<Statement> { $1 };} // Joshua
		| BlockStatements BlockStatement						{ $$ = $1; $$.Add($2); } // Joshua
		;

BlockStatement
		: LocalVariableDeclarationStatement						{ $$ = $1; } // Vivian
		| Statement												{ $$ = $1; } // Vivian
		;

LocalVariableDeclarationStatement
		: LocalVariableDeclaration ';'							{ $$ = new VariableDeclarationStatement($1); } // Vivian - updated by Nathan
		;

LocalVariableDeclaration
		: UnannType VariableDeclaratorList						{ $$ = new VariableDeclarationList($1, $2); } // Vivian
		//: VariableModifiers UnannType VariableDeclaratorList	{ $$ = new VariableDeclarationList($1, $2); } // Vivian - too hard at the moment - Nathan
		;

// Too hard at the moment - Nathan
VariableDeclaratorList
		: VariableDeclarator									{ $$ = new List<VariableDeclarator> { $1 }; } // Nathan
		| VariableDeclaratorList ',' VariableDeclarator			{ $$ = $1; $$.Add($3); } // Nathan
		;

VariableDeclarator
		: VariableDeclaratorId									{ $$ = new VariableDeclarator($1, null); } // Nathan
		| VariableDeclaratorId '=' VariableInitialiser			{ $$ = new VariableDeclarator($1, $3); } // Nathan
		;

VariableInitialiser
		: Expression											{ $$ = $1; } // Nathan
		;

VariableDeclaratorId
		: IDENTIFIER Dims_Opt									{ $$ = $1; } // Nathan - array types not yet supported
		;
// Nathan
Statement
		: StatementWithoutTrailingSubstatement					{ $$ = $1; } // Nathan
		| IfThenStatement										{$$ = $1; } // Adon
		| IfThenElseStatement									{$$ = $1; } // Adon
		| WhileStatement										{ $$ = $1; } // Nathan
		| LabeledStatement										 { $$ = $1;} //Vivian
		;
		
StatementNoShortIf
		: StatementWithoutTrailingSubstatement					{$$ = $1; } // Adon
		| IfThenElseStatementNoShortIf							{$$ = $1; } // Adon
		;

// Tristan
StatementWithoutTrailingSubstatement
		: ExpressionStatement 									{ $$ = $1; } // Nathan - done by Khoa
		| Block													{ $$ = $1; } // Nathan
		| BreakStatement										{ $$ = $1;} //Vivian
		| DoStatement											{ $$ = $1; } //Tri
		| ContinueStatement										{ $$ = $1;} //Vivian
		| ReturnStatement										{ $$ = $1;} //Vivian
		| ThrowStatement										{ $$ = $1;} // KoJo
		| SynchronizedStatement									{ $$ = $1;} // KoJo
		| SwitchStatement										{ $$ = $1;} //Tri
		| AssertStatement										{ $$ = $1;} //Tri
		| TryStatement											{ $$ = $1;} //Adon
		;

AssertStatement
		: ASSERT Expression ';'									{ $$ = new AssertStatement($2);} //Tri
		| ASSERT Expression ':' Expression ';'					{ $$ = new AssertStatement($2, $4);} //Tri
		;

SwitchStatement
		: SWITCH '(' Expression ')'	SwitchBlock					{ $$ = new SwitchStatement($3, $5); } //Kojo
		;

SwitchBlock
		: '{' SwitchBlockStatementGroups '}'						{ $$ = $2; } //Kojo
		;

SwitchBlockStatementGroups
		: SwitchBlockStatementGroup									{ $$ = new List<Statement> {$1}; }  //KoJo
		| SwitchBlockStatementGroups SwitchBlockStatementGroup		{ $$ = $1; $$.Add($2); }  //KoJo
		;

SwitchBlockStatementGroup
		: SwitchLabels BlockStatements							{ $$ = new SwitchBlockGroup($1, $2); } //Kojo
		;

SwitchLabels
		: SwitchLabel												{ $$ = new List<Statement> {$1};} //KoJo
		| SwitchLabels SwitchLabel									{ $$ = $1; $$.Add($2); }   // KoJo
		;

SwitchLabel
		: CASE ConstantExpression ':'							{ $$ = new SwitchLabelStatement($2) ;} // KoJo
		| DEFAULT ':'											{ $$ = new SwitchLabelStatement(); } // KoJo
		;


DoStatement
		: DO Statement WHILE '(' Expression ')'	';'				{ $$ = new DoStatement($2, $5); } // Tri
		;
		 
ThrowStatement
		: THROW Expression ';'									{ $$ = new ThrowStatement($2); } //KoJo
		;

SynchronizedStatement
		: SYNCHRONIZED '(' Expression ')' Block					{ $$ = new SynchronizedStatement($3, $5); }  //KoJo
		;

ExpressionStatement
		: StatementExpression ';'								{ $$ = new ExpressionStatement($1); } // Khoa
		;

StatementExpression
		: Assignment											{ $$ = $1; } // Khoa - updated by Nathan
		| MethodInvocation										{ $$ = $1; } // Nathan
		| PreIncrementExpression								{ $$ = $1; }  //sneha
		| PreDecrementExpression								{ $$ = $1; }  //sneha
		| PostIncrementExpression								{ $$ = $1; }	
		| PostDecrementExpression								{ $$ = $1; }
		;

// Start method handling - Nathan
MethodInvocation
		: MethodName '(' ArgumentList_opt ')'					{ $$ = new MethodInvocation($1, $3); } // Nathan
		| PackageOrTypeName '.' IDENTIFIER '(' ArgumentList_opt ')'		{ $$ = new MethodInvocation( $1 + '.' + $3, $5); } // Nathan
		;

PackageOrTypeName
		: IDENTIFIER											{ $$ = $1; } // Nathan
		| PackageOrTypeName '.' IDENTIFIER						{ $$ = $1 + '.' + $3; } // Nathan
		;

MethodName
		: IDENTIFIER											{ $$ = $1; } // Nathan
		;

ArgumentList_opt
		: ArgumentList											{ $$ = $1; } // Nathan
		| /* empty */											{ } // Nathan
		;

ArgumentList
		: ArgumentList ',' Expression							{ $$ = $1; $$.Add($3); } // Nathan
		| Expression											{ $$ = new List<Expression> {$1}; } // Nathan
		;
// end method handling

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
																		//		see paser_try.y to check the nessary paser rules for a full try statement
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

//Add Labeledstatement-Vivian
LabeledStatement
		: IDENTIFIER ':' Statement								{ $$ = new LabeledStatement($1,$3);} //Vivian
		;

//Add breakstatement-Vivian
BreakStatement
		: BREAK Identifier_opt ';'									{ if($2 == null){$$ = new BreakStatement();} else {$$ = new BreakStatement($2);} } //Vivian
		;

//Add for breakstatement-Vivian		
Identifier_opt
		: IDENTIFIER															
		| 
		;

//Add continuestatement-Vivian
ContinueStatement
		: CONTINUE Identifier_opt ';'									{ if($2 == null){$$ = new ContinueStatement();} else {$$ = new ContinueStatement($2);} } //Vivian
		;

//Add returnstatement-Vivian
ReturnStatement
		: RETURN Expression_opt ';'									{ if($2 == null){$$ = new ReturnStatement();} else {$$ = new ReturnStatement($2);} } //Vivian
		;

//Add for returnstatement-Vivian
Expression_opt
		: Expression												{ $$ = $1; }// Vivian			
		| 
		;

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
		| MethodInvocation										{ $$ = $1; } // Nathan
		;

Literal
		: IntegerLiteral										{ $$ = (Expression) $1;}//new IntegerLiteralExpression($1); } // Nathan
		| FloatingPointLiteral									{$$ = (Expression)$1;}//{ $$ = new FloatingPointLiteralExpression($1); } // Adon
		| BooleanLiteral										{ $$ = new BooleanLiteralExpression($1); } // Adon
		| CharacterLiteral										{ $$ = new CharacterLiteralExpression($1); } // Adon
		| StringLiteral											{ $$ = new StringLiteralExpression($1); } //Tri
		| NullLiteral											{ $$ = new NullLiteralExpression(); } //Tri
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
		: UnaryExpression												{ $$ = $1; } //Khoa
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
		: '(' PrimitiveType ')' UnaryExpression										{ $$ = new CastExpression($2, $4); } //Khoa
		//| '(' ReferenceType AdditionalBounds ')' UnaryExpressionNotPlusMinus
		//| '(' ReferenceType AdditionalBounds ')' LambdaExpression
		;
		//Khoa. ReferenceType was chosen to be out of scope for this assignment. Commented out

AdditionalBounds
		: AdditionalBounds AdditionalBound
		|
		;

AdditionalBound
		: '&' //InterfaceType
		;

ConstantExpression
		: Expression {$$ = $1;} // Josh
		;

%%

public Parser(Scanner scanner) : base(scanner)
{
}

>>>>>>> master
