%namespace IFN660_Java_ECMAScript

%using System.Collections;
%using IFN660_Java_ECMAScript.AST;

%{
public static Statement root;
%}


%union
{
    public long num;
	public float floatnum;
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
%type <expr> UnaryExpression, PostfixExpression, Primary

%type <stmt> Statement, CompilationUnit, TypeDeclaration, ClassDeclaration, NormalClassDeclaration, ClassBodyDeclaration
%type <stmt> ExpressionStatement, StatementWithoutTrailingSubstatement, LocalVariableDeclaration, LocalVariableDeclarationStatement
%type <stmt> BlockStatement, Throws_opt, ClassMemberDeclaration, MethodDeclaration, FormalParameter
%type <stmt> PackageDeclaration_opt

%type <stmts> TypeDeclarations, ClassBody, ClassBodyDeclarations, BlockStatements, BlockStatements_Opt, Block
%type <stmts> MethodBody, FormalParameters, FormalParameterList, FormalParameterList_Opt 
%type <stmts> ImportDeclarations

%type <type> Result, FloatingPointType, IntegralType, NumbericType
%type <type> UnannType, UnannPrimitiveType, UnannReferenceType, UnannArrayType, UnannTypeVariable

%type <modf> ClassModifier, MethodModifier, VariableModifier, TypeParameterModifier, PackageModifier, FieldModifier, ConstructorModifier, EnumConstantModifier, InterfaceMethodModifier, AnnotationTypeElementModifer

%type <modfs> ClassModifiers, MethodModifiers, VariableModifiers, TypeParameterModifiers, PackageModifiers, FieldModifiers, ConstructorModifier, EnumConstantModifiers, InterfaceMethodModifiers, AnnotationTypeElementModifers

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

Program : CompilationUnit										{root = $1;}
		//| Type										
        ;


// Types, Values and Variable 
Type	: PrimitiveType										
		| ReferenceType										
		;

PrimitiveType
		: Annotations NumbericType
		| Annotations BOOLEAN
		;

NumbericType
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


ReferenceType
		: ClassOrInterfaceType
		| TypeVariable
		| ArrayType							// Cause reduce/reduce conflict
		;

ClassOrInterfaceType
		: ClassType
		| InterfaceType
		;

ClassType
		: Annotations IDENTIFIER TypeArguments_opt
		| ClassOrInterfaceType '.' Annotations IDENTIFIER TypeArguments_opt
		;

InterfaceType
		: ClassType
		;

TypeVariable
		: Annotations IDENTIFIER
		;

ArrayType
		: PrimitiveType Dims
		| ClassOrInterfaceType Dims
		| TypeVariable Dims
		;

Dims
		: Annotations '['']'									//{ $$ = $1; } // Needs work - Tri - removed by Nathan - too hard at the moment - need further development
		| Dims Annotations '['']'								//in AST branch, it is displayes as '['']'
		;

Dims_Opt 
		: /* Empty */											{ } // An - not implemented yet
		| Dims													{ $$ = $1; } // An - updated by Adon
		;

TypeParameter
		: TypeParameterModifiers IDENTIFIER TypeBound_opt
		;

TypeParameterModifiers
		: TypeParameterModifiers TypeParameterModifier			{ $$ = $1; $$.Add($2); } // Khoa
		|
		;

TypeParameterModifier
		: Annotation
		;

TypeBound_opt
		: TypeBound
		|
		;

TypeBound
		: EXTENDS TypeVariable
		| EXTENDS ClassOrInterfaceType AdditionalBounds
		;

AdditionalBounds
		: AdditionalBounds AdditionalBound
		|
		;

AdditionalBound
		: '&' InterfaceType
		;

TypeArguments_opt
		: 
		| TypeArguments
		;

TypeArguments
		: '<' TypeArgumentList '>'				// Reduce/Reduce confict here
		;

TypeArgumentList
		: TypeArgument
		| TypeArgumentList ',' TypeArgument
		;

TypeArgument
		: ReferenceType
		| Wildcard
		;

Wildcard
		: Annotations '?' WildcardBounds_opt
		;

WildcardBounds_opt
		: 
		| WildcardBounds
		;

WildcardBounds
		: EXTENDS ReferenceType
		| SUPER ReferenceType
		;

/*******************************************************************************************
********************************* Names **************************************
*******************************************************************************************/
TypeName
		: IDENTIFIER
		| PackageOrTypeName '.' IDENTIFIER
		;

PackageOrTypeName
		: IDENTIFIER
		| PackageOrTypeName '.' IDENTIFIER
		;

ExpressionName
		: IDENTIFIER											{ $$ = new VariableExpression($1);  } // Khoa - updated by Nathan
		| AmbigousName '.' IDENTIFIER
		;

MethodName
		: IDENTIFIER
		;

PackageName
		: IDENTIFIER
		| PackageName '.' IDENTIFIER
		;

AmbigousName
		: IDENTIFIER
		| AmbigousName '.' IDENTIFIER
		;

/*******************************************************************************************
********************************* Packages **************************************
*******************************************************************************************/
CompilationUnit 
		: PackageDeclaration_opt ImportDeclarations TypeDeclarations	{ $$ = new CompilationUnitDeclaration($1,$2,$3);  } // Josh
		;


PackageDeclaration_opt
		: PackageDeclaration											
		| 
		;

PackageDeclaration
		: PackageModifiers PACKAGE IDENTIFIER ';'
		| PackageDeclaration '.' IDENTIFIER ';'
		;

PackageModifiers
		: PackageModifiers PackageModifier					{ $$ = $1; $$.Add($2); } // Khoa
		|
		;

PackageModifier
		: Annotation
		;

ImportDeclarations
		: ImportDeclarations ImportDeclaration				{ $$ = $1; $$.Add($2); } // Khoa
		|
		;

ImportDeclaration
		: SingleTypeImportDeclaration						{ $$ = $1; } // Khoa
		| TypeImportOnDemandDeclaration						{ $$ = $1; } // Khoa
		| SingleStaticImportDeclaration						{ $$ = $1; } // Khoa
		| StaticImportOnDemandDeclaration					{ $$ = $1; } // Khoa
		;

SingleTypeImportDeclaration
		: IMPORT TypeName ';'
		;

TypeImportOnDemandDeclaration
		: IMPORT PackageOrTypeName '.' '*' ';'
		;

SingleStaticImportDeclaration
		: IMPORT STATIC TypeName '.' IDENTIFIER ';'
		;

StaticImportOnDemandDeclaration
		: IMPORT STATIC TypeName '.' '*' ';'
		;

TypeDeclarations 
		: TypeDeclarations TypeDeclaration						{ $$ = $1; $$.Add($2); } // needs work - Josh
		| /* empty */											{ $$ = new List<Statement>();}											
		;

TypeDeclaration 
		: ClassDeclaration /* need to add InterfaceDeclaration */ { $$ = $1; } // Vivian
		| InterfaceDeclaration 
		| ';'
		;

/*******************************************************************************************
********************************* Classes **************************************
*******************************************************************************************/
ClassDeclaration 
		: NormalClassDeclaration /* need to add EnumDeclaration */ { $$ = $1; } // Vivian
		| EnumDeclaration
		;

NormalClassDeclaration 
		: ClassModifiers CLASS IDENTIFIER TypeParameters_opt Superclass_opt Superinterfaces_opt ClassBody {  $$ = new ClassDeclaration($3,$1,$7); } // Vivian
		;

ClassModifiers 
		: ClassModifiers ClassModifier							{ $$ = $1; $$.Add($2); } // Vivian - Updated by Nathan
		| /* empty */											{ $$ = new List<Modifier>(); } // Vivian - Updated by Nathan
		;

ClassModifier 
		: Annotation											//{ $$ = $1; } // Adon - removed by Nathan - too hard at the moment - require further development
		| PUBLIC												{ $$ = Modifier.PUBLIC; } // Adon
		| PROTECTED 											{ $$ = Modifier.PROTECTED; } // Adon
		| PRIVATE 												{ $$ = Modifier.PRIVATE; } // Adon
		| ABSTRACT 												{ $$ = Modifier.ABSTRACT; } // Adon
		| STATIC 												{ $$ = Modifier.STATIC; } // Adon
		| FINAL 												{ $$ = Modifier.FINAL; } // Adon
		| STRICTFP 												{ $$ = Modifier.STRICTFP; } // Adon
		;

TypeParameters_opt 
		: /* empty */											{ $$ = null; } // Tristan
		| TypeParameters										{ $$ = $1; } // Khoa
		;

TypeParameters
		: '<' TypeParameterList '>'								{ $$ = $1; } // Khoa
		;

TypeParameterList
		: TypeParameter											{ $$ = $1; } // Khoa
		| TypeParameterList ',' TypeParameter					{ $$ = $1; $$.Add($3); } // Khoa
		;

SuperClass_opt								
		: SuperClass
		| /* empty */											{ $$ = null; } // Tristan
		;

SuperClass
		: EXTENDS ClassType
		;

Superinterfaces_opt
		: Superinterfaces
		| /* empty */											{ $$ = null; } // Tristan
		;

Superinterfaces
		: IMPLEMENTS InterfaceTypeList
		;

InterfaceTypeList
		: InterfaceType
		| InterfaceTypeList ',' InterfaceType
		;

ClassBody 
		: '{' ClassBodyDeclarations '}'							{ $$ = $2; } // Tristan
		;


ClassBodyDeclarations
		: ClassBodyDeclarations ClassBodyDeclaration			{ $$ = $1; $$.Add($2); } // Tristan
		| /* empty */											{ $$ = new List<Statement>(); } // Tristan - updated by Nathan
        ;

ClassBodyDeclaration
		: ClassMemberDeclaration								{ $$ = $1; } // Tristan								
		| InstanceInitializer 
		| StaticInitializer 
		| ConstructorDeclaration
		;

ClassMemberDeclaration
		: FieldDeclaration										{ $$ = $1; } // Khoa
		| MethodDeclaration										{ $$ = $1; } // Vivian
		| ClassDeclaration										{ $$ = $1; } // Khoa
		| InterfaceDeclaration 									{ $$ = $1; } // Khoa
		| ';'
		;

FieldDeclaration
		: FieldModifiers UnannType VariableDeclaratorList ';'	{ $$ = $1; $$ = new VariableDeclarationList($1, $2); } // Khoa
		;

FieldModifiers
		: FieldModifiers FieldModifier							{ $$ = $1; $$.Add($2); } // Khoa
		|
		;

FieldModifier
		: PUBLIC												{ $$ = Modifier.PUBLIC; } // Khoa
		| PROTECTED												{ $$ = Modifier.PROTECTED; } // Khoa
		| PRIVATE												{ $$ = Modifier.PRIVATE; } // Khoa
		| STATIC												{ $$ = Modifier.STATIC; } // Khoa
		| FINAL													{ $$ = Modifier.FINAL; } // Khoa
		| TRANSIENT												{ $$ = Modifier.TRANSIENT; } // Khoa
		| VOLATILE												{ $$ = Modifier.VOLATILE; } // Khoa
		;

VariableDeclaratorList
		: VariableDeclarator									{ $$ = new List<string> { $1 }; } // Nathan
		| VariableDeclaratorList ',' VariableDeclarator			{ $$ = $1; $$.Add($3); } // Nathan
		;

VariableDeclarator
		: VariableDeclaratorId									{ $$ = $1; } // Nathan; this line only exist in AST branch, require further development, probably we have to replace it with next line, which is An's rule
		| VariableDeclaratorId	VariableDeclarator_opt										
		;

VariableDeclarator_opt
		: '=' VariableInitializer
		|
		;

VariableInitializer
		: Expression
		| ArrayInitializer
		;

VariableDeclaratorId
		: IDENTIFIER Dims_Opt									{ $$ = $1; } // Nathan
		;

UnannType
		: UnannReferenceType									{ $$ = $1; } // Tri
		| UnannPrimitiveType									{ $$ = $1; } // Tri
		;

UnannPrimitiveType
		: NumbericType											{ $$ = $1; } // Josh
		| BOOLEAN												{ $$ = new NamedType("BOOLEAN"); } // Josh
		;

UnannReferenceType
		: UnannClassOrInterfaceType 
		| UnannTypeVariable 
		| UnannArrayType										{ $$ = $1; } // Vivian
		;

UnannClassOrInterfaceType
		: UnannClassType
		| UnannInterfaceType
		;

UnannClassType
		: IDENTIFIER TypeArguments_opt
		| UnannClassOrInterfaceType '.' Annotations IDENTIFIER TypeArguments_opt
		;

UnannInterfaceType
		: UnannClassType
		;

UnannTypeVariable
		: IDENTIFIER 											{ $$ = new NamedType($1); } // Adon
		;

UnannArrayType
		: UnannPrimitiveType Dims								{ $$ = new ArrayType($1); } // Adon: Not sure but Dims returns Annotation in the end and Annotation returns thing so we put $$ = $1 here
		| UnannClassOrInterfaceType Dims 
		| UnannTypeVariable Dims								
		;	

MethodDeclaration
		: MethodModifiers MethodHeader MethodBody				{ $$ = new MethodDeclaration( (string)((ArrayList)$2[1])[0], $1, $3, (AST.Type)$2[0], (List<Statement>)((ArrayList)$2[1])[1]); } // Vivian - updated by Nathan
        ;

MethodModifiers
        : MethodModifiers MethodModifier						{ $$ = $1; $$.Add($2); } // Vivian
		| /* Empty */											{ $$ = new List<Modifier>(); } // Vivian
        ;

MethodModifier
		: Annotation											//{ $$ = $1; } // Vivian - removed by Nathan - too hard at the moment - need further development
		| PUBLIC												{ $$ = Modifier.PUBLIC; } // Vivian												
        | STATIC												{ $$ = Modifier.STATIC; } // vivian											
        | FINAL													{ $$ = Modifier.FINAL; }  // Khoa
		| SYNCHRONIZED											{ $$ = Modifier.SYNCHRONIZED; } // Khoa
		| NATIVE												{ $$ = Modifier.NATIVE; } // Khoa
		| STRICTFP												{ $$ = Modifier.STRICTFP; } // Khoa
		;

MethodHeader
		: Result MethodDeclarator Throws_opt					{$$ = new ArrayList() { $1, $2, $3 } ; } // Khoa
		| TypeParameters Annotations Result MethodDeclarator Throws_opt
		;

Result 
		: VOID													{$$ = new NamedType("VOID"); } // Khoa
		| UnannType												{$$ = $1; } // Khoa
	   	;

MethodDeclarator
		: IDENTIFIER '(' FormalParameterList_Opt ')' Dims_Opt	{$$ =  new ArrayList() { $1, $3, $5 };} // Khoa
		;

//PLACEHOLDER - Josh - Tri
FormalParameterList_Opt
		: FormalParameterList									{ $$ = $1; } // Nathan
		| /* empty */											{ $$ = null; } // Nathan
		;

FormalParameterList 
		: FormalParameters 										{ $$ = $1; } // Nathan; this line only exist in AST branch, require further modifications
		| ReceiverParameter
		| FormalParameters ',' LastFormalParameter 						
		| LastFormalParameter 									
		;


FormalParameters 
		: FormalParameter 										{ $$ = new List<Statement> { $1 }; } // Nathan 
		| ReceiverParameter 
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
		: Annotation											//{ $$ = $1; } // Tri - removed by Nathan - too hard at the moment - need further development
		| FINAL													{ $$ = Modifier.FINAL; } // Tri - updated by Nathan
		;

LastFormalParameter
		: VariableModifiers UnannType Annotations ELLIPSIS VariableDeclaratorId
		| FormalParameter
		;

ReceiverParameter
		: Annotations UnannType Identifier_opt THIS
		;

Identifier_opt
		: IDENTIFIER '.'
		|
		;

Throws_opt
		: Throws
		| /* Empty */											{$$ = null; } // Khoa - updated by Nathan													
	  	;
Throws
		: THROWS ExceptionTypeList
		;

ExceptionTypeList
		: ExceptionType											{ $$ = $1; } // Khoa
		| ExceptionTypeList ',' ExceptionType					{ $$ = $1; $$.Add($3); } // Khoa
		;

ExceptionType
		: ClassType												{ $$ = $1; } // Khoa
		| TypeVariable											{ $$ = $1; } // Khoa
		;

MethodBody
		:  Block 												{ $$= $1; }  // Adon
		| ';'													{ $$= null;} // Adon
		;

InstanceInitializer
		: Block													{ $$ = $1; } // Khoa
		;

StaticInitializer
		: STATIC Block
		;

ConstructorDeclaration
		: ConstructorModifiers ConstructorDeclarator Throws_opt ConstructorBody
		;

ConstructorModifiers
		: ConstructorModifiers ConstructorModifier				{ $$ = $1; $$.Add($2); } // Khoa
		|
		;

ConstructorModifier
		: Annotation
		| PUBLIC
		| PROTECTED
		| PRIVATE
		;

ConstructorDeclarator
		: TypeParameters_opt SimpleTypeName '(' FormalParameterList_opt ')'
		;

SimpleTypeName
		: IDENTIFIER
		;
////////// Todo //////////////////////
ConstructorBody
		: '{' ExplicitConstructorInvocation_opt BlockStatements_opt '}'
		;

ExplicitConstructorInvocation_opt
		: ExplicitConstructorInvocation
		|
		;

ExplicitConstructorInvocation
		: TypeArguments_opt THIS '(' ArgumentList_opt ')' ';'
		| TypeArguments_opt SUPER '(' ArgumentList_opt ')' ';'
		| ExpressionName '.' TypeArguments_opt SUPER '(' ArgumentList_opt ')' ';'
		| Primary '.' TypeArguments_opt SUPER '(' ArgumentList_opt ')' ';'
		;

TypeArgumentList_opt
		: TypeArgumentList
		|
		;

ArgumentList_opt
		: ArgumentList
		|
		;

ArgumentList
		: Expression 
		| ArgumentList ',' Expression
		;

EnumDeclaration
		: ClassModifiers ENUM IDENTIFIER Superinterfaces_opt EnumBody
		;

EnumBody
		: '{' EnumConstantList_opt Comma_opt EnumBodyDeclarations_opt '}'
		;

EnumConstantList_opt
		: EnumConstantList
		|
		;

Comma_opt
		: ','
		|
		;

EnumBodyDeclarations_opt
		: EnumBodyDeclarations
		|
		;

EnumConstantList
		: EnumConstant 
		| EnumConstantList ',' EnumConstant
		;

EnumConstant
		: EnumConstantModifiers IDENTIFIER ArgumentListWithBracket_opt ClassBody_opt
		;

EnumConstantModifiers
		: EnumConstantModifiers EnumConstantModifier			{ $$ = $1; $$.Add($2); } // Khoa
		|
		;

EnumConstantModifier
		: Annotation
		;

ArgumentListWithBracket_opt
		: '(' ArgumentList_opt ')'
		|
		;

ClassBody_opt
		: ClassBody
		|
		;

EnumBodyDeclarations
		: ';' ClassBodyDeclarations
		;

/*******************************************************************************************
********************************* Interfaces **************************************
*******************************************************************************************/
InterfaceDeclaration
		: NormalClassDeclaration
		| AnnotationTypeDeclaration
		;

NormalClassDeclaration
		: InterfaceModifers INTERFACE IDENTIFIER TypeParameters_opt ExtendsInterfaces_opt InterfaceBody
		;

InterfaceModifers
		: InterfaceModifers InterfaceModifer					{ $$ = $1; $$.Add($2); } // Khoa
		|
		;

InterfaceModifer
		: Annotation											
		| PUBLIC												{ $$ = Modifier.PUBLIC; } // Khoa										
		| PROTECTED												{ $$ = Modifier.PROTECTED; } // Khoa
		| PRIVATE												{ $$ = Modifier.PRIVATE; } // Khoa
		| ABSTRACT												{ $$ = Modifier.ABSTRACT; } // Khoa
		| STATIC												{ $$ = Modifier.STATIC; } // Khoa
		| STRICTFP												{ $$ = Modifier.STRICTFP; } // Khoa
		;

ExtendsInterfaces_opt
		: ExtendsInterfaces
		|
		;

ExtendsInterfaces
		: EXTENDS InterfaceTypeList
		;

InterfaceBody
		: '{' InterfaceMemberDeclarations'}'
		;

InterfaceMemberDeclarations
		: InterfaceMemberDeclarations InterfaceMemberDeclaration
		|
		;

InterfaceMemberDeclaration
		: ConstantDeclaration									{ $$ = $1; } //Khoa
		| InterfaceMethodDeclaration							{ $$ = $1; } //Khoa
		| ClassDeclaration										{ $$ = $1; } //Khoa
		| InterfaceDeclaration									{ $$ = $1; } //Khoa
		| ';'													{ $$ = null; } //Khoa
		;

ConstantDeclaration
		: ConstantModifiers UnannType VariableDeclaratorList ';'
		;

ConstantModifiers
		: ConstantModifiers ConstantModifier					{ $$ = $1; $$.Add($2); } // Khoa
		|
		;

ConstantModifier
		: Annotation
		| PUBLIC											{ $$ = Modifier.PUBLIC; } // Khoa
		| STATIC											{ $$ = Modifier.STATIC; } // Khoa
		| FINAL												{ $$ = Modifier.FINAL; } // Khoa
		;

InterfaceMethodDeclaration
		: InterfaceMethodModifiers MethodHeader MethodBody
		;

InterfaceMethodModifiers
		: InterfaceMethodModifers InterfaceMethodModifier	{ $$ = $1; $$.Add($2); } // Khoa
		|
		;

InterfaceMethodModifier
		: Annotation
		| PUBLIC										{ $$ = Modifier.PUBLIC; } // Khoa
		| ABSTRACT										{ $$ = Modifier.ABSTRACT; } // Khoa
		| DEFAULT										{ $$ = Modifier.DEFAULT; } // Khoa
		| STATIC										{ $$ = Modifier.STATIC; } // Khoa
		| STRICTFP										{ $$ = Modifier.STRICTFP; } // Khoa
		;

AnnotationTypeDeclaration
		: InterfaceModifers '@' INTERFACE IDENTIFIER AnnotationTypeBody
		;

AnnotationTypeBody
		: '{' AnnotationTypeMemberDeclarations'}'
		;

AnnotationTypeMemberDeclarations
		: AnnotationTypeMemberDeclarations AnnotationTypeMemberDeclaration
		|
		;

AnnotationTypeMemberDeclaration
		: AnnotationTypeElementDeclaration
		| ConstantDeclaration
		| ClassDeclaration
		| InterfaceDeclaration
		| ';'
		;

AnnotationTypeElementDeclaration
		: AnnotationTypeElementModifers UnannType IDENTIFIER '(' ')' Dims_opt DefaultValue_opt ';'
		;

AnnotationTypeElementModifers	
		: AnnotationTypeElementModifers AnnotationTypeElementModifer	{ $$ = $1; $$.Add($2); } // Khoa
		|
		;

AnnotationTypeElementModifer
		: Annotation
		| PUBLIC										{ $$ = Modifier.PUBLIC; } // Khoa
		| ABSTRACT										{ $$ = Modifier.ABSTRACT; } // Khoa
		;

DefaultValue_opt
		: DefaultValue
		|
		;

DefaultValue
		: DEFAULT ElementValue
		;


// Removed by Nathan - too hard at the moment - require further development
//Annotations
//		: Annotations Annotation								{ $$ = new Anotations($2); } // Adon
//		| /* Empty */											{ $$ = null; } // Adon
//		;


Annotation
		: NormalAnnotation											
		| MarkerAnnotation
		| SingleElementAnnotation
		;

NormalAnnotation
		: '@' TypeName '(' ElementValuePairList_opt ')'
		;

ElementValuePairList_opt
		: ElementValuePairList
		| 
		;

ElementValuePairList
		: ElementValuePair
		| ElementValuePairList ',' ElementValuePair
		;

ElementValuePair
		: IDENTIFIER '=' ElementValue
		;

ElementValue
		: ConditionalExpression
		| ElementValueArrayInitializer
		| Annotation
		;

ElementValueArrayInitializer
		: '{' ElementValueList Comma_opt'}'
		;

ElementValueList
		: ElementValue 
		| ElementValueList ',' ElementValue
		;

MarkerAnnotation
		: '@' TypeName
		;

SingleElementAnnotation							// Reduce/Reduce conflict on ')' - NormalAnnotation
		: '@' TypeName '(' ElementValue ')'
		;

/*******************************************************************************************
********************************* Arrays **************************************
*******************************************************************************************/
ArrayInitializer
		: '{' VariableInitializerList_opt Comma_opt'}'
		;

VariableInitializerList_opt
		: VariableInitializerList
		|
		;

VariableInitializerList
		: VariableInitializer 
		| VariableInitializerList ',' VariableInitializer
		;

/*******************************************************************************************
********************************* Blocks and Statements **************************************
*******************************************************************************************/
Block 
		: '{' BlockStatements_Opt '}'							{ $$ = $2; } // Tristan
		;

BlockStatements_Opt
		: BlockStatements										{ $$ = $1; } // Tristan
		| /* Empty */											{ $$ = null; } // Tristan
		;

BlockStatements
		: BlockStatement										{ $$ = new List<Statement> { $1 }; } // Tristan 
		| BlockStatements BlockStatement						{ $$ = $1; $$.Add($2); } // Tristan
		;

BlockStatement
		: LocalVariableDeclarationStatement						{ $$ = $1; } // Vivian
		| Statement												{ $$ = $1; } // Vivian										
		| ClassDeclaration										
		;

LocalVariableDeclarationStatement
		: LocalVariableDeclaration ';'							{ $$ = $1; } // Vivian - updated by Nathan
		;

LocalVariableDeclaration
		: UnannType VariableDeclaratorList						{ $$ = new VariableDeclarationList($1, $2); } // Vivian; this line only exist in AST branch - Adon
		//: VariableModifiers UnannType VariableDeclaratorList	{ $$ = new VariableDeclarationList($1, $2); } // Vivian - too hard at the moment - Nathan - require further development
		;

Statement 
		: StatementWithoutTrailingSubstatement					{$$ = $1; } // Nathan
        | LabeledStatement										{$$ = $1; } // Khoa
		| IfThenStatement										{$$ = $1; } // Khoa
		| IfThenElseStatement									{$$ = $1; } // Khoa
		| WhileStatement										{$$ = $1; } // Khoa
		| ForStatement											{$$ = $1; } // Khoa
		;

StatementNoShortIf
		: StatementWithoutTrailingSubstatement					{$$ = $1; } // Khoa
		| LabeledStatementNoShortIf
		| IfThenElseStatementNoShortIf
		| WhileStatementNoShortIf
		| ForStatementNoShortIf
		;

StatementWithoutTrailingSubstatement
		: Block
		| EmptyStatement										{ $$ = $1; } // Khoa, need to define EmptyStatement 
		| ExpressionStatement 									{ $$ = $1; } // Nathan
		| AssertStatement										{ $$ = $1; } // Khoa, need to define AssertStatement
		| SwitchStatement										{ $$ = $1; } // Khoa, need to define SwitchStatement
		| DoStatement											{ $$ = $1; } // Khoa, need to DoStatement
		| BreakStatement										{ $$ = $1; } // Khoa, need to define BreakStatement
		| ContinueStatement										{ $$ = $1; } // Khoa, need to define ContinueStatement
		| ReturnStatement										{ $$ = $1; } // Khoa, need to define ReturnStatement
		| SynchronizedStatement									{ $$ = $1; } // Khoa, need to define SynchronizedStatement
		| ThrowStatement										{ $$ = $1; } // Khoa, need to define ThrowStatement
		| TryStatement											{ $$ = $1; } // Khoa, need to define TryStatement
		;

EmptyStatement
		: ';'													{ $$ = null; } // Khoa
		;

LabeledStatement
		: IDENTIFIER ':' Statement
		;

LabeledStatementNoShortIf
		: IDENTIFIER ':' StatementNoShortIf
		;

ExpressionStatement
		: StatementExpression ';'								{ $$ = new ExpressionStatement($1); } // Khoa
		;

StatementExpression
		: Assignment											{ $$ = $1; } // Khoa - updated by Nathan
		| PreIncrementExpression 
		| PreDecrementExpression 
		| PostIncrementExpression 
		| PostDecrementExpression 
		| MethodInvocation 
		| ClassInstanceCreationExpression	
		;

IfThenStatement
		: IF '(' Expression ')' Statement
		;

IfThenElseStatement
		: IF '(' Expression ')' StatementNoShortIf ELSE Statement	
		;

IfThenElseStatementNoShortIf
		: IF '(' Expression ')' StatementNoShortIf ELSE StatementNoShortIf
		;

AssertStatement
		: ASSERT Expression ';' 
		| ASSERT Expression ':' Expression ';'
		;

SwitchStatement
		: SWITCH '(' Expression ')' SwitchBlock
		;

SwitchBlock
		: '{' SwitchBlockStatementGroups SwitchLabel_repeat '}'
		;

SwitchBlockStatementGroups
		: SwitchBlockStatementGroups SwitchBlockStatementGroup		{ $$ = $1; $$.Add($2); } // Khoa
		|
		;

SwitchBlockStatementGroup
		: SwitchLabels BlockStatements
		;

SwitchLabel_repeat
		: SwitchLabel_repeat SwitchLabel
		|
		;

SwitchLabels
		: SwitchLabel
		| SwitchLabels SwitchLabel
		;

SwitchLabel
		: CASE ConstantExpression ':'
		| CASE EnumConstantName ':'
		| DEFAULT ':'
		;

EnumConstantName
		: IDENTIFIER
		;

WhileStatement
		: WHILE '(' Expression ')' Statement
		;

WhileStatementNoShortIf
		: WHILE '(' Expression ')' StatementNoShortIf
		;

DoStatement
		: DO Statement WHILE '(' Expression ')' ';'
		;

ForStatement
		: BasicForStatement 
		| EnhancedForStatement
		;

ForStatementNoShortIf
		: BasicForStatementNoShortIf 
		| EnhancedForStatementNoShortIf
		;

BasicForStatement
		: FOR '(' ForInit_opt ';' Expression_opt ';' ForUpdate_opt ')' Statement
		;

BasicForStatementNoShortIf
		: FOR '(' ForInit_opt ';' Expression_opt ';' ForUpdate_opt ')' StatementNoShortIf
		;

ForInit_opt
		: ForInit
		|
		;
ForInit
		: 
		| StatementExpressionList
		| LocalVariableDeclaration
		;

ForUpdate_opt
		: ForUpdate
		|
		;

ForUpdate
		: 
		| StatementExpressionList
		;

StatementExpressionList
		: StatementExpression 
		| StatementExpressionList ',' StatementExpression
		;

EnhancedForStatement
		: FOR '(' VariableModifiers UnannType VariableDeclaratorId ':' Expression ')' Statement
		;

EnhancedForStatementNoShortIf
		: FOR '(' VariableModifiers UnannType VariableDeclaratorId ':' Expression ')' StatementNoShortIf
		;

BreakStatement
		: BREAK Identifier_opt ';'
		;

ContinueStatement
		: CONTINUE Identifier_opt ';'
		;

ReturnStatement
		: RETURN Expression_opt ';'
		;	

ThrowStatement
		: THROW Expression ';'
		;

SynchronizedStatement
		: SYNCHRONIZED '(' Expression ')' Block
		;

TryStatement
		: TRY Block Catches
		| TRY Block Catches_opt Finally
		| TryWithResourcesStatement
		;

Catches_opt
		: Catches
		|
		;

Catches
		: CatchClause
		| Catches CatchClause
		;

CatchClause
		: CATCH '(' CatchFromalParameter ')' Block
		;

CatchFromalParameter
		: VariableModifiers CatchType VariableDeclaratorId
		;

CatchType
		: UnannClassType 
		| CatchType '|' CatchType
		;

Finally_opt
		: Finally
		|
		;

Finally
		: FINALLY Block
		;

TryWithResourcesStatement
		: TRY ResourceSpecification Block Catches_opt Finally_opt
		;

ResourceSpecification
		: '(' ResourceList SemmiColon_opt ')'
		;

SemmiColon_opt
		: ';'
		|
		;

ResourceList
		: Resource 
		| ResourceList ';' Resource
		;

Resource
		: VariableModifiers UnannType VariableDeclaratorId '=' Expression
		;

/*******************************************************************************************
********************************* Expression **************************************
*******************************************************************************************/
Primary
		: PrimaryNoNewArray										{ $$ = $1; } // Nathan
		| ArrayCreationExpression
		;

PrimaryNoNewArray
		: 
		| Literal												{ $$ = $1; } // Nathan, this line only exists in AST branch, and AST does not have empty
		| ClassLiteral
		| THIS
		| TypeName '.' THIS
		| '(' Expression ')'
		| ClassInstanceCreationExpression
		| FieldAccess
		| ArrayAccess
		| MethodInvocation
		| MethodReference												
		;

ClassLiteral
		: TypeName SquareBrackets '.' CLASS
		| NumbericType SquareBrackets '.' CLASS
		| BOOLEAN SquareBrackets '.' CLASS
		| VOID '.' CLASS
		;

SquareBrackets
		: SquareBrackets '['']'
		|
		;

ClassInstanceCreationExpression
		: UnqualifiedClassInstanceCreationExpression
		| ExpressionName '.' UnqualifiedClassInstanceCreationExpression
		| Primary '.' UnqualifiedClassInstanceCreationExpression
		;

UnqualifiedClassInstanceCreationExpression
		: NEW TypeArguments_opt ClassOrInterfaceTypeToInstantiate '(' ArgumentList_opt')' ClassBody_opt
		;

ClassOrInterfaceTypeToInstantiate
		: Annotations IDENTIFIER ClassOrInterfaceTypeToInstantiate_repeat TypeArgumentsOrDiamond_opt
		;

ClassOrInterfaceTypeToInstantiate_repeat
		: ClassOrInterfaceTypeToInstantiate_repeat '.' Annotations IDENTIFIER
		|
		;

TypeArgumentsOrDiamond_opt
		: TypeArgumentsOrDiamond
		|
		;

TypeArgumentsOrDiamond
		: TypeArguments
		| '<''>'
		;

FieldAccess
		: Primary '.' IDENTIFIER
		| SUPER '.' IDENTIFIER
		| TypeName '.' SUPER '.' IDENTIFIER
		;

ArrayAccess
		: ExpressionName '[' Expression ']'
		| PrimaryNoNewArray '[' Expression ']'
		;

MethodInvocation
		: MethodName '(' ArgumentList_opt')'
		| TypeName '.' TypeArguments_opt IDENTIFIER '(' ArgumentList_opt')'
		| ExpressionName '.' TypeArguments_opt IDENTIFIER '(' ArgumentList_opt')'
		| Primary '.' TypeArguments_opt IDENTIFIER '(' ArgumentList_opt')'
		| SUPER '.' TypeArguments_opt IDENTIFIER '(' ArgumentList_opt')'
		| TypeName '.' SUPER '.' TypeArguments_opt IDENTIFIER '(' ArgumentList_opt')'
		;

ArgumentList_opt
		: ArgumentList
		|
		;

ArgumentList
		: Expression
		| ArgumentList ',' Expression
		;

MethodReference
		: ExpressionName DOUBLE_COLON TypeArguments_opt IDENTIFIER
		| ReferenceType DOUBLE_COLON TypeArguments_opt IDENTIFIER
		| Primary DOUBLE_COLON TypeArguments_opt IDENTIFIER
		| SUPER DOUBLE_COLON TypeArguments_opt IDENTIFIER
		| TypeName '.' SUPER DOUBLE_COLON TypeArguments_opt IDENTIFIER
		| ClassType DOUBLE_COLON TypeArguments_opt NEW
		| ArrayType DOUBLE_COLON NEW
		;

ArrayCreationExpression
		: NEW PrimitiveType DimExprs Dims_opt
		| NEW ClassOrInterfaceType DimExprs Dims_opt
		| NEW PrimitiveType Dims ArrayInitializer
		| NEW ClassOrInterfaceType Dims ArrayInitializer
		;

DimExprs
		: DimExpr 
		| DimExprs DimExpr
		;

DimExpr
		: Annotations '[' Expression ']'
		;

Expression
		: LambdaExpression										{ $$ = $1; } // Nathan
		| AssignmentExpression									{ $$ = $1; } // Nathan
		;

Expression_opt
		: Expression
		|
		;

LambdaExpression
		: LambdaParameters ARROW LambdaBody						{ } // not implemented yet - Nathan
		;

LambdaParameters
		: IDENTIFIER
		| '(' FormalParameterList_opt ')'
		| '(' InferredFormalParameterList')'
		;

InferredFormalParameterList
		: IDENTIFIER 
		| InferredFormalParameterList ',' IDENTIFIER
		;

LambdaBody
		: Expression
		| Block
		;

AssignmentExpression
		: ConditionalExpression									{ $$ = $1; } // Nathan
		| Assignment											{ $$ = $1; } // Nathan
		;

Assignment
		: LeftHandSide AssignmentOperator Expression			{ $$ = new AssignmentExpression($1, $3); } // Khoa
		;

LeftHandSide
		: ExpressionName										{ $$ = $1; } // Khoa
		| FieldAccess
		| ArrayAccess
		;

AssignmentOperator
		: '='													 // Khoa
		| MULTIPLICATION_ASSIGNMENT
		| DIVISION_ASSIGNMENT
		| MODULUS_ASSIGNMENT
		| ADDITION_ASSIGNMENT
		| SUBTRACTION_ASSIGNMENT
		| LEFT_SHIFT_ASSIGNMENT
		| SIGNED_RIGHT_SHIFT_ASSIGNMENT
		| UNSIGNED_RIGHT_SHIFT_ASSIGNMENT
		| BITWISE_AND_ASSIGNMENT
		| BITWISE_XOR_ASSIGNMENT
		| BITWISE_OR_ASSIGNMENT
		;

ConditionalExpression
		: ConditionalOrExpression												{ $$ = $1; } // Nathan
		//| ConditionalOrExpression '?' Expression ':' ConditionalExpression	{ $$ = new TernaryExpression($1, $3, $5); } // not implemented yet - Nathan; need further development
		//| ConditionalOrExpression '?' Expression ':' LambdaExpression			{ $$ = new TernaryExpression($1, $3, $5); } // not implemented yet - Nathan; need further development
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
		| InclusiveOrExpression '|' ExclusiveOrExpression
		;

ExclusiveOrExpression
		: AndExpression													{ $$ = $1; } //Nathan
		| ExclusiveOrExpression '^' AndExpression
		;

AndExpression
		: EqualityExpression											{ $$ = $1; } //Nathan
		| AndExpression '&' EqualityExpression
		;

EqualityExpression
		: RelationalExpression											{ $$ = $1; } //Nathan
		| EqualityExpression EQUAL RelationalExpression 
		| EqualityExpression NOT_EQUAL RelationalExpression
		;		

RelationalExpression
		: ShiftExpression												{ $$ = $1; } //Nathan
		| RelationalExpression '<' ShiftExpression
		| RelationalExpression '>' ShiftExpression
		| RelationalExpression LESS_THAN_OR_EQUAL ShiftExpression
		| RelationalExpression GREATER_OR_EQUAL ShiftExpression
		| RelationalExpression INSTANCEOF ReferenceType
		;

ShiftExpression
		: AdditiveExpression											{ $$ = $1; } //Nathan
		| ShiftExpression LEFT_SHIFT AdditiveExpression
		| ShiftExpression SIGNED_RIGHT_SHIFT AdditiveExpression
		| ShiftExpression UNSIGNED_RIGHT_SHIFT AdditiveExpression
		;

AdditiveExpression
		: MultiplicativeExpression										{ $$ = $1; } //Nathan
		| AdditiveExpression '+' MultiplicativeExpression
		| AdditiveExpression '-' MultiplicativeExpression
		;

MultiplicativeExpression
		: UnaryExpression
		| MultiplicativeExpression '*' UnaryExpression
		| MultiplicativeExpression '/' UnaryExpression
		| MultiplicativeExpression '%' UnaryExpression
		;

UnaryExpression
		: PostfixExpression											{ $$ = $1; } //Nathan; this line only exists in AST branch but this rule does exist in UnaryExpressionNotPlusMinus
		| PreIncrementExpression									{ $$ = $1; } // Khoa, same as Nathan's comment
		| PreDecrementExpression									{ $$ = $1; } // Khoa, same as Nathan's comment
		| '+' UnaryExpression										{ $$ = $1; } // Khoa, same as Nathan's comment
		| '-' UnaryExpression										{ $$ = $1; } // Khoa, same as Nathan's comment
		| UnaryExpressionNotPlusMinus								{ $$ = $1; } // Khoa, same as Nathan's comment
		;

PreIncrementExpression
		: '+''+' UnaryExpression
		;

PreDecrementExpression
		: '-''-' UnaryExpression
		;

UnaryExpressionNotPlusMinus
		: PostfixExpression
		| '~' UnaryExpression
		| '!' UnaryExpression
		| CastExpression
		;

PostfixExpression
		: Primary													{ $$ = $1; } //Nathan
		| ExpressionName											{ $$ = $1; } //Nathan
		| PostIncrementExpression
		| PostDecrementExpression
		;

PostIncrementExpression
		: PostfixExpression '+''+'
		;

PostDecrementExpression
		: PostfixExpression '-''-'
		;

CastExpression
		: '(' PrimitiveType ')' UnaryExpression
		| '(' ReferenceType AdditionalBounds ')' UnaryExpressionNotPlusMinus
		| '(' ReferenceType AdditionalBounds ')' LambdaExpression
		;

ConstantExpression
		: Expression
		;

Literal
		: IntegerLiteral										{ $$ = new IntegerLiteralExpression($1); } // Nathan
		| FloatingPointLiteral
		| BooleanLiteral
		| CharacterLiteral
		| StringLiteral
		| NullLiteral
		;

%%

public Parser(Scanner scanner) : base(scanner)
{
}

