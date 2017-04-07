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
%token BOOLEAN	      DO         GOTO         PRIVATE     THIS
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

Program : CompilationUnit										{ // Nathan }
        ;


// Types, Values and Variable 
Type	: PrimitiveType										{ // Tri }
		| ReferenceType										{ // Tri }
		;

PrimitiveType
		: Annotations NumbericType
		| Annotations BOOLEAN
		;

NumbericType
		: IntegralType											{ // Josh }
		| FloatingPointType										{ // Josh }
		;

IntegralType
		: BYTE													{ // Josh }
		| SHORT													{ // Josh }
		| INT													{ // Vivian }
		| LONG													{ // Vivian }
		| CHAR													{ // Vivian }
		;

FloatingPointType
		: FLOAT													{ // Vivian }
		| DOUBLE												{ // Vivian }
		;

ReferenceType
		: ClassOrInterfaceType
		| TypeVariable
		| ArrayType
		;

ClassOrInterfaceType
		: ClassType
		| InterfaceType
		;

ClassType
		: Annotations IDENTIFIER TypeArguments_repeat
		| ClassOrInterfaceType '.' Annotations IDENTIFIER
		| TypeArguments_repeat
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

TypeParameters
		: TypeParameterModifiers IDENTIFIER TypeBound_opt
		;

TypeParameterModifiers
		: TypeParameterModifiers TypeParameterModifier
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
		| EXTENDS ClassOrInterfaceType AdditionalBound
		;

AdditionalBound
		: '&' InterfaceType
		;

TypeArguments_repeat
		: TypeArguments_repeat TypeArguments
		;
TypeArguments_opt
		: TypeArguments
		|
		;

TypeArguments
		: '<' TypeArgumentList '>'
		;

TypeArgumentList
		: TypeArgument TypeArgument_repeat
		;

TypeArgument_repeat
		: ',' TypeArgument_repeat TypeArgument
		|
		;
TypeArgument
		: ReferenceType
		| Wildcard
		;

Wildcard
		: Annotations '?' WildcardBounds_opt
		;

WildcardBounds_opt
		: WildcardBounds
		|
		;

WildcardBounds
		: EXTENDS ReferenceType
		| SUPER ReferenceType
		;

// Names	
TypeName
		: IDENTIFIER
		| PackageOrTypeName '.' IDENTIFIER
		;

PackageOrTypeName
		: IDENTIFIER
		| PackageOrTypeName '.' IDENTIFIER
		;

ExpressionName
		: IDENTIFIER
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

StatementList 
		: StatementList Statement								{ // Tri }
        | /* empty */											{ // Tri }
        ;

Expression 
		: LambdaExpression
		| AssignmentExpression									{ // Josh }  
        ;

Empty	:
		;

// Group A Start
CompilationUnit 
		: PackageDeclaration_opt ImportDeclarations TypeDeclarations	{ // Josh }
		;

PackageDeclaration_opt
		: PackageDeclaration											{ // Josh }
		| 
		;

PackageDeclaration
		: PackageModifiers PACKAGE IDENTIFIER PackageDeclaration_repeat
		;

PackageDeclaration_repeat
		: PackageDeclaration_repeat '.' IDENTIFIER
		|
		;

PackageModifiers
		: PackageModifiers PackageModifier
		;

PackageModifier
		: Annotation
		;

ImportDeclarations
		: ImportDeclarations ImportDeclaration
		|
		;

ImportDeclaration
		: SingleTypeImportDeclaration 
		| TypeImportOnDemandDeclaration 
		| SingleStaticImportDeclaration 
		| StaticImportOnDemandDeclaration
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
		: TypeDeclaration TypeDeclarations
		| /* empty */											{ // Josh }
		| /* follow up */
		;
TypeDeclaration 
		: ClassDeclaration 										 { // Vivian }
		| InterfaceDeclaration 
		;

ClassDeclaration 
		: NormalClassDeclaration /* need to add EnumDeclaration */ { // Vivian }
		| EnumDeclaration
		;

NormalClassDeclaration 
		: ClassModifiers CLASS IDENTIFIER TypeParameters_opt SuperClass_opt Superinterfaces_opt ClassBody { // Vivian }
		;

ClassModifiers 
		: ClassModifiers ClassModifier							{ // Vivian }
		| /* empty */											{ // Vivian }
		;

ClassModifier 
		: Annotation											{ // Adon }
		| PUBLIC												{ // Adon }
		| PROTECTED 											{ // Adon }
		| PRIVATE 												{ // Adon }
		| ABSTRACT 												{ // Adon }
		| STATIC 												{ // Adon }
		| FINAL 												{ // Adon }
		| STRICTFP 												{ // Adon }
		;

Annotation
		: NormalAnnotation											{ // Tristan }
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
		: ElementValuePair ElementValuePair_repeat
		;

ElementValuePair_repeat
		: ',' ElementValuePair_repeat ElementValuePair
		;

ElementValuePair
		: IDENTIFIER '=' ElementValue

//GROUP C TRACKING
TypeParameters_opt 
		: TypeParameters
		|								{ // Tristan }
		;

TypeParameters
		: '<' TypeParameterList '>'
		;

TypeParameterList
		: TypeParameter TypeParameterList_repeat
		;

TypeParameterList_repeat
		: ',' TypeArgument_repeat TypeParameter
		|
		;

SuperClass_opt								{ // Tristan }
		: SuperClass
		|
		;

SuperClass
		: EXTENDS ClassType
		;

Superinterfaces_opt /* empty */								{ // Tristan }
		: Superinterfaces
		|
		;

Superinterfaces
		: IMPLEMENTS InterfaceTypeList
		;

InterfaceTypeList
		: InterfaceType InterfaceTypeList_repeat
		;

InterfaceTypeList_repeat
		: ',' InterfaceTypeList_repeat InterfaceType
		|
		;

ClassBody 
		: '{' ClassBodyDeclarations '}'							{ // Tristan }
		;

// Group A End

// PartB by Adon Mofified by Josh to remove MemberDeclarations as it is unessisary
ClassBodyDeclarations
		: ClassBodyDeclarations ClassBodyDeclaration			{ // Tristan }
		| /* empty */											{ // Tristan }
        ;

ClassBodyDeclaration
		: ClassMemberDeclaration								{ // Tristan }
		| InstanceInitializer 
		| StaticInitializer 
		| ConstructorDeclaration
		;

// Fixed by An
ClassMemberDeclaration
		: FieldDeclaration 
		| MethodDeclaration 
		| ClassDeclaration 
		| InterfaceDeclaration 									{ // Sneha }
		| ';'
		;

FieldDeclaration
		: FieldModifiers UnannType VariableDeclaratorList ';'
		;

FieldModifiers
		: FieldModifiers FieldModifier
		|
		;

FieldModifier
		: PUBLIC
		| PROTECTED
		| PRIVATE
		| STATIC
		| FINAL
		| TRANSIENT
		| VOLATILE
		;

// Change ClassMemberDeclaration to MethodDeclaration -An	
MethodDeclaration
		: MethodModifiers MethodHeader MethodBody				{ // Sneha }
        ;

MethodModifiers
        : MethodModifiers MethodModifier						{ // Sneha }
		| /* Empty */											{ // Sneha }
        ;

MethodModifier
		: Annotation											{ // Sneha }
		| PUBLIC												{ // Sneha }
        | STATIC												{ // Sneha }
        | FINAL
		| SYNCHRONIZED
		| NATIVE
		| STRICTFP
		;

MethodHeader
		: Result MethodDeclarator Throws_opt					{ // Khoa }
        | TypeParameters Annotations Result MethodDeclarator Throws_opt
		;

// End Fix
// End GroupB

//WORK BY JOSH HUDSON
Result 
		: VOID													{ // Khoa }
		| UnannType												{ // Khoa }
	   	;

Throws_opt
		: Empty													{ // Khoa }
	  	;
Throws
		: THROWS ExceptionTypeList
		;

// Fixed spelling error	 
MethodDeclarator
		: IDENTIFIER '(' FormalParameterList_Opt ')' Dims_Opt	{ // Khoa }
		;

//PLACEHOLDER - Josh - Tri
FormalParameterList_Opt
		: FormalParameterList									{ // An }
		| /* empty */											{ // An }
		;

Dims_Opt 
		: Dims													{ // An }
		| /* Empty */											{ // An }
		;
// JOSHUA'S WORK END

//Work by Tri
FormalParameterList 
		: ReceiverParameter
		| FormalParameters ',' LastFormalParameter 								{ // An }
		| LastFormalParameter 											{ // An }
		;

FormalParameters 
		: FormalParameter FormalParameters_repeat 				{ // Nathan }
		| ReceiverParameter FormalParameters_repeat									{ // Nathan }
		;

FormalParameters_repeat
		: ',' FormalParameters_repeat FormalParameter
		|
		;

FormalParameter 
		:  VariableModifiers UnannType VariableDeclaratorId		{ // Nathan }
		;
VariableModifiers 
		: VariableModifiers VariableModifier					{ // Nathan }
		| /* empty */											{ // Nathan }
		;

VariableModifier 
		: Annotation											{ // Tri }
		| FINAL													{ // Tri }
		;

LastFormalParameter
		: VariableModifiers UnannType Annotations '...' VariableDeclaratorId
		| FormalParameter
		;

ReceiverParameter
		: Annotations UnannType Identifier_opt THIS
		;

Identifier_opt
		: IDENTIFIER '.'
		|
		;

ExceptionTypeList
		: ExceptionType	ExceptionType_repeat
		;

ExceptionType_repeat
		: ',' ExceptionType_repeat ExceptionType
		|
		;

ExceptionType
		: ClassType
		| TypeVariable
		;

InstanceInitializer
		: STATIC Block
		;

ConstructorDeclaration
		: ConstructorModifiers ConstructorDeclaration Throws_opt
		| ConstructorBody
		;

ConstructorModifiers
		: ConstructorModifiers ConstructorModifier
		|
		;

ConstructorModifier
		: Annotation
		| PUBLIC
		| PROTECTED
		| PRIVATE
		;

ConstructorDeclaration
		: TypeParameters_opt SimpleTypeName '(' FormalParameterList_Opt')'
		;

SimpleTypeName
		: IDENTIFIER
		;

ConstructorBody
		: '{' ExplicitConstructorInvocation_opt BlockStatements_Opt'}'
		;

ExplicitConstructorInvocation_opt
		: ExplicitConstructorInvocation
		|
		;

ExplicitConstructorInvocation
		: TypeArguments_opt THIS '(' ArgumentList_opt')' ';'
		| TypeArguments_opt SUPER '(' ArgumentList_opt')' ';'
		| ExpressionName '.' TypeArguments_opt SUPER '(' ArgumentList_opt')' ';'
		| Primary '.' TypeArguments_opt SUPER '(' ArgumentList_opt')' ';'
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
		: Expression ArgumentList_repeat
		;

ArgumentList_repeat
		: ',' ArgumentList_repeat Expression
		;

EnumDeclaration
		: ClassModifiers ENUM IDENTIFIER Superinterfaces_opt EnumBody
		;

EnumBody
		: '{' EnumConstantList_opt '}' Comma_opt EnumBodyDeclarations_opt
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
		: EnumConstant EnumConstantList_repeat
		;

EnumConstantList_repeat
		: ',' EnumConstantList_repeat EnumConstant
		;

EnumConstant
		: EnumConstantModifiers IDENTIFIER ArgumentListWithBracket_opt ClassBody_opt
		;

EnumConstantModifiers
		: EnumConstantModifiers EnumConstantModifier
		|
		;
ArgumentListWithBracket_opt
		: '(' ArgumentList_opt ')'
		|
		;

ClassBody_opt
		: ClassBody
		|
		;

EnumConstantModifier
		: Annotation
		;

EnumBodyDeclarations
		: ';' ClassBodyDeclarations
		;

InterfaceDeclaration
		: NormalClassDeclaration
		| AnnotationTypeDeclaration
		;

NormalClassDeclaration
		: InterfaceModifers INTERFACE IDENTIFIER TypeParameters_opt
		| ExtendsInterfaces_opt InterfaceBody
		;

InterfaceModifers
		: InterfaceModifers InterfaceModifer
		|
		;
InterfaceModifer
		: Annotation
		| PUBLIC
		| PROTECTED
		| PRIVATE
		| ABSTRACT
		| STATIC
		| STRICTFP
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
		: ConstantDeclaration 
		| InterfaceMethodDeclaration 
		| ClassDeclaration
		| InterfaceDeclaration
		| ';'
		;

ConstantDeclaration
		: ConstantModifiers UnannType VariableDeclaratorList ';'
		;

ConstantModifiers
		: ConstantModifiers ConstantModifier
		|
		;

ConstantModifier
		: Annotation
		| PUBLIC
		| STATIC
		| FINAL
		;

InterfaceMethodDeclaration
		: InterfaceMethodModifiers MethodHeader MethodBody
		;

InterfaceMethodModifiers
		: InterfaceModifers InterfaceMethodModifier
		|
		;

InterfaceMethodModifier
		: Annotation
		| PUBLIC
		| ABSTRACT
		| DEFAULT	
		| STATIC	
		| STRICTFP
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
		: AnnotationTypeElementModifers UnannType IDENTIFIER '(' ')' Dims_Opt
		| DefaultValue_opt ';'
		;

AnnotationTypeElementModifers	
		: AnnotationTypeElementModifers AnnotationTypeElementModifer
		|
		;

AnnotationTypeElementModifer
		: Annotation
		| PUBLIC
		| ABSTRACT
		;

DefaultValue_opt
		: DefaultValue
		|
		;

DefaultValue
		: DEFAULT ElementValue
		;

ElementValue
		: ConditionalExpression
		| ElementValueArrayInitializer
		| Annotation
		;

ElementValueArrayInitializer
		: '{' ElementValueList_opt Comma_opt'}'
		;

ElementValueList_opt
		: ElementValueList
		| 
		;

ElementValueList
		: ElementValue ElementValue_repeat
		;

ElementValue_repeat
		: ElementValue_repeat ',' ElementValue
		|
		;

MarkerAnnotation
		: '@' TypeName
		;

SingleElementAnnotation
		: '@' TypeName '(' ElementValue ')'
		;

ArrayInitializer
		: '{' VariableInitializerList_opt Comma_opt'}'
		;

VariableInitializerList_opt
		: VariableInitializerList
		|
		;

VariableInitializerList
		: VariableInitializer VariableInitializer_repeat
		;

VariableInitializer_repeat
		: VariableInitializer_repeat ',' VariableInitializer
		|
		;

//End work by Tri
// Work by Vivian
Dims
		: Annotations '['']'									{ // Tri }
		;

VariableDeclaratorId
		: IDENTIFIER Dims_Opt									{ // Tri }
		;

UnannType
		: UnannReferenceType									{ // Tri }
		| UnannPrimitiveType									{ // Tri }
		;

UnannPrimitiveType
		: NumbericType											{ // Josh }
		| BOOL													{ // Josh }
		;

UnannReferenceType
		: UnannClassOrInterfaceType 
		| UnannTypeVariable 
		| UnannArrayType										{ // Vivian }										{ // Vivian }
		;

UnannClassOrInterfaceType
		: UnannClassType
		| UnannInterfaceType
		;

UnannClassType
		: IDENTIFIER TypeArguments_opt
		| UnannClassOrInterfaceType '.' Annotations IDENTIFIER
		| TypeArguments_opt
		;

UnannInterfaceType
		: UnannClassType
		;

UnannTypeVariable
		: IDENTIFIER
		;

// Vivian's work end
// Work by Khoa - Fixed by An
UnannArrayType
		: UnannPrimitiveType Dims 
		| UnannClassOrInterfaceType Dims 
		| UnannTypeVariable Dims								{ // Adon }
		;	
			
UnannTypeVariable
		: IDENTIFIER											{ // Adon }
		;	

// Start work by An
MethodBody
		:  Block 												{ // Adon }
		| ';'													{ // Adon }
		;

Annotations
		: Annotation											{ // Adon }
		| /* Empty */											{ // Adon }
		;

Block 
		: '{' BlockStatements_Opt '}'							{ // Tristan }
		;

BlockStatements_Opt
		: BlockStatements										{ // Tristan }
		| /* Empty */											{ // Tristan }
		;

BlockStatements
		: BlockStatement BlockStatement_s						{ // Tristan }
		;

BlockStatement_s
		: BlockStatement_s BlockStatement						{ // Tristan }
		| /* Empty */											{ // Tristan }
		;

BlockStatement
		: LocalVariableDeclarationsAndStatement					{ // Sneha }
		| Statement												{ // Sneha }
		| ClassDeclaration										{ // Sneha }
		;

LocalVariableDeclarationsAndStatement
		: LocalVariableDeclaration ';'							{ // Sneha }
		;

LocalVariableDeclaration
		: VariableModifiers UnannType VariableDeclaratorList	{ // Sneha }
		;

VariableDeclaratorList
		: VariableDeclarator VariableDeclarator_repeat									{ // An }
		| /* follow up */										{ // An }
		;

VariableDeclarator_repeat
		: ',' VariableDeclarator_repeat VariableDeclarator
		|
		;

VariableDeclarator
		: VariableDeclaratorId	VariableDeclarator_opt							{ // An }										{ // An }
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
		: IDENTIFIER Dims_Opt									{ // An }
		;

// Tristan

/*******************************************************************************************
********************************* Block and Statement **************************************
*******************************************************************************************/
Statement 
		: StatementWithoutTrailingSubstatement				{ // Nathan }
        | LabeledStatement 
		| IfThenStatement 
		| IfThenElseStatement 
		| WhileStatement 
		| ForStatement
		;

StatementNoShortIf
		: StatementWithoutTrailingSubstatement
		| LabeledStatementNoShortIf
		| IfThenElseStatementNoShortIf
		| WhileStatementNoShortIf
		| ForStatementNoShortIf
		;

StatementWithoutTrailingSubstatement
		: Block
		| EmptyStatement
		| ExpressionStatement 									{ // An }
		| AssertStatement
		| SwitchStatement 
		| DoStatement 
		| BreakStatement 
		| ContinueStatement 
		| ReturnStatement 
		| SynchronizedStatement 
		| ThrowStatement 
		| TryStatement
		;

EmptyStatement
		: ';'
		;

LabeledStatement
		: IDENTIFIER ':' Statement
		;

LabeledStatementNoShortIf
		: IDENTIFIER ':' StatementNoShortIf
		;

ExpressionStatement
		: StatementExpression ';'								{ // Khoa }
		;

StatementExpression
		: Assignment											{ // Khoa }
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
		: '{' SwitchBlockStatementGroups SwitchLabels_repeat '}'
		;

SwitchBlockStatementGroups
		: SwitchBlockStatementGroups SwitchBlockStatementGroup
		|
		;

SwitchLabels_repeat
		: SwitchLabels SwitchLabel
		|
		;

SwitchBlockStatementGroup
		: SwitchLabels BlockStatements
		;

SwitchLabels
		: SwitchLabel SwitchLabels_repeat
		;

SwitchLabel
		: CASE ConstantExpression ';'
		| CASE EnumConstantName ';'
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

Expression_opt
		: Expression
		|
		;

ForUpdate_opt
		: ForUpdate
		|
		;

ForInit
		: StatementExpressionList
		| LocalVariableDeclaration
		;

ForUpdate
		: StatementExpressionList
		;

StatementExpressionList
		: StatementExpression StatementExpression_repeat
		;

StatementExpression_repeat
		: StatementExpression_repeat ',' StatementExpression
		;

EnhancedForStatement
		: FOR '(' VariableModifiers UnannType VariableDeclaratorId : Expression ')' Statement
		;

EnhancedForStatementNoShortIf
		: FOR '(' VariableModifiers UnannType VariableDeclaratorId : Expression ')' StatementNoShortIf
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
		: THROW Expression ;

SynchronizedStatement
		: SYNCHRONIZED '(' Expression ')' Block
		;

TryStatement
		: Try Block Catches
		| Try Block Catches_opt FINALLY
		| TryWithResourcesStatement
		;

Catches_opt
		: Catches
		|
		;

Catches
		: CatchClause CatchClauses
		;

CatchClauses
		: CatchClauses CatchClause
		|
		;

CatchClause
		: CATCH '(' CatchFromalParameter ')' Block		
		;

CatchFromalParameter
		: VariableModifiers CatchType VariableDeclaratorId
		;

CatchType
		: UnannClassType CatchType_repeat
		;

CatchType_repeat
		: CatchType_repeat '|' ClassType
		|
		;

Finally
		: FINALLY Block
		;

TryWithResourcesStatement
		: TRY ResourceSpecification Block Catches_opt Finally_opt
		;

Finally_opt
		: Finally
		|
		;

ResourceSpecification
		: '(' ResourceList SemmiColon_opt ')'
		;

SemmiColon_opt
		: ';'
		|
		;

ResourceList
		: Resource ResourceList_repeat
		;

ResourceList_repeat
		: ResourceList_repeat ';' Resource
		|
		;

Resource
		: VariableModifiers UnannType VariableDeclaratorId '=' Expression
		;

/*******************************************************************************************
******************************* End Block and Statement  ***********************************
*******************************************************************************************/

/*******************************************************************************************
************************************** Expression  *****************************************
*******************************************************************************************/
Primary
		: PrimaryNoNewArray
		| ArrayCreationExpression
		;

PrimaryNoNewArray
		: Literal
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
		: TypeName SquareBracket_opt '.' CLASS
		| NumbericType SquareBracket_opt '.' CLASS
		| BOOLEAN SquareBracket_opt '.' CLASS
		| VOID'.' CLASS
		;

SquareBracket_opt
		: '['']'
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
		: Annotations IDENTIFIER ClassOrInterfaceTypeToInstantiate_repeat
		| TypeArgumentsOrDiamond_opt
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

MethodReference
		: ExpressionName '::' TypeArguments_opt IDENTIFIER
		| ReferenceType '::' TypeArguments_opt IDENTIFIER
		| Primary '::' TypeArguments_opt IDENTIFIER
		| SUPER '::' TypeArguments_opt IDENTIFIER
		| TypeName '.' SUPER '::' TypeArguments_opt IDENTIFIER
		| ClassType '::' TypeArguments_opt new
		| ArrayType '::' new
		;

ArrayCreationExpression
		: NEW PrimitiveType DimExprs Dims_Opt
		| NEW ClassOrInterfaceType DimExprs Dims_Opt
		| NEW PrimitiveType Dims ArrayInitializer
		| NEW ClassOrInterfaceType Dims ArrayInitializer
		;

DimExprs
		: DimExpr DimExpr_repeat
		;

DimExpr_repeat
		: DimExpr_repeat DimExpr
		|
		;

DimExpr
		: Annotations '[' Expression ']'

LambdaExpression
		: LambdaParameters '->' LambdaBody
		;

LambdaParameters
		: IDENTIFIER
		| '(' FormalParameterList_Opt ')'
		| '(' InferredFormalParameterList')'
		;

InferredFormalParameterList
		: IDENTIFIER Identifier_repeat
		;

Identifier_repeat
		: Identifier_repeat ',' IDENTIFIER
		|
		;

LambdaBody
		: Expression
		| Block
		;

AssignmentExpression
		: ConditionalExpression
		| Assignment
		;

// End Work by Tristan
//work by sneha

Assignment
		: LeftHandSide AssignmentOperator Expression			{ // Khoa }
		;

LeftHandSide
		: ExpressionName										{ // Khoa }
		| FieldAccess
		| ArrayAccess
		;

AssignmentOperator
		: '='													{ // Khoa }
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
		: ConditionalOrExpression
		| ConditionalOrExpression '?' Expression ':' ConditionalExpression
		| ConditionalOrExpression '?' Expression ':' LambdaExpression
		;

ConditionalOrExpression
		: ConditionalAndExpression
		| ConditionalOrExpression LOGICAL_OR ConditionalAndExpression
		;

ConditionalAndExpression
		: InclusiveOrExpression
		| ConditionalAndExpression LOGICAL_AND InclusiveOrExpression
		;

InclusiveOrExpression
		: ExclusiveOrExpression
		| InclusiveOrExpression '|' ExclusiveOrExpression
		;

ExclusiveOrExpression
		: AndExpression
		| ExclusiveOrExpression '^' AndExpression
		;

AndExpression
		: EqualityExpression
		| AndExpression '&' EqualityExpression
		;

EqualityExpression
		: RelationalExpression
		| EqualityExpression EQUAL RelationalExpression 
		| EqualityExpression NOT_EQUAL RelationalExpression
		;		

RelationalExpression
		: ShiftExpression
		| RelationalExpression '<' ShiftExpression
		| RelationalExpression '>' ShiftExpression
		| RelationalExpression LESS_THAN_OR_EQUAL ShiftExpression
		| RelationalExpression GREATER_OR_EQUAL ShiftExpression
		| RelationalExpression INSTANCEOF ReferenceType
		;

ShiftExpression
		: AdditiveExpression
		| ShiftExpression LEFT_SHIFT AdditiveExpression
		| ShiftExpression SIGNED_RIGHT_SHIFT AdditiveExpression
		| ShiftExpression UNSIGNED_RIGHT_SHIFT AdditiveExpression
		;

AdditiveExpression
		: MultiplicativeExpression
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
		: PreIncrementExpression
		| PreDecrementExpression
		| '+' UnaryExpression
		| '-' UnaryExpression
		| UnaryExpressionNotPlusMinus
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
		: Primary
		| ExpressionName
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
		: IntegerLiteral										{ // Nathan }
		| FloatingPointLiteral
		| BooleanLiteral
		| CharacterLiteral
		| StringLiteral
		| NullLiteral
		;

// end of sneha Work

%%

public Parser(Scanner scanner) : base(scanner)
{
}

