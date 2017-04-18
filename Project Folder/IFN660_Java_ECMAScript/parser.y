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

Program : CompilationUnit
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
		: Annotations '['']'
		| Dims Annotations '['']'
		;

Dims_opt
		:
		| Dims
		;

TypeParameter
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

/*******************************************************************************************
********************************* Packages **************************************
*******************************************************************************************/
CompilationUnit 
		: PackageDeclaration_opt ImportDeclarations TypeDeclarations	
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
		: PackageModifiers PackageModifier
		|
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
		: TypeDeclarations TypeDeclaration
		| /* empty */											
		;
TypeDeclaration 
		: ClassDeclaration 										 
		| InterfaceDeclaration 
		| ';'
		;

/*******************************************************************************************
********************************* Classes **************************************
*******************************************************************************************/
ClassDeclaration 
		: NormalClassDeclaration 
		| EnumDeclaration
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

TypeParameters_opt 
		: 
		| TypeParameters						
		;

TypeParameters
		: '<' TypeParameterList '>'
		;

TypeParameterList
		: TypeParameter
		| TypeParameterList ',' TypeParameter
		;

SuperClass_opt								
		: SuperClass
		|
		;

SuperClass
		: EXTENDS ClassType
		;

Superinterfaces_opt
		: Superinterfaces
		|
		;

Superinterfaces
		: IMPLEMENTS InterfaceTypeList
		;

InterfaceTypeList
		: InterfaceType
		| InterfaceTypeList ',' InterfaceType
		;

ClassBody 
		: '{' ClassBodyDeclarations '}'							
		;

ClassBodyDeclarations
		: ClassBodyDeclarations ClassBodyDeclaration			
		| /* empty */											
        ;

ClassBodyDeclaration
		: ClassMemberDeclaration								
		| InstanceInitializer 
		| StaticInitializer 
		| ConstructorDeclaration
		;

ClassMemberDeclaration
		: FieldDeclaration 
		| MethodDeclaration 
		| ClassDeclaration 
		| InterfaceDeclaration 									
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

VariableDeclaratorList
		: VariableDeclarator 								
		| VariableDeclaratorList ',' VariableDeclarator									
		;

VariableDeclarator
		: VariableDeclaratorId	VariableDeclarator_opt										
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
		: IDENTIFIER Dims_opt									
		;

UnannType
		: UnannPrimitiveType 									
		| UnannReferenceType									
		;

UnannPrimitiveType
		: NumbericType											
		| BOOLEAN													
		;

UnannReferenceType
		: UnannClassOrInterfaceType 
		| UnannTypeVariable 
		| UnannArrayType																				
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
		: IDENTIFIER
		;

UnannArrayType
		: UnannPrimitiveType Dims 
		| UnannClassOrInterfaceType Dims 
		| UnannTypeVariable Dims								
		;	

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
        | FINAL
		| SYNCHRONIZED
		| NATIVE
		| STRICTFP
		;

MethodHeader
		: Result MethodDeclarator Throws_opt
		| TypeParameters Annotations Result MethodDeclarator Throws_opt
		;

Result 
		: VOID													
		| UnannType											
	   	;

MethodDeclarator
		: IDENTIFIER '(' FormalParameterList_opt ')' Dims_opt	
		;

FormalParameterList_opt
		: FormalParameterList								
		| /* empty */										
		;

FormalParameterList 
		: ReceiverParameter
		| FormalParameters ',' LastFormalParameter 						
		| LastFormalParameter 									
		;

FormalParameters 
		: FormalParameter  				
		| ReceiverParameter 
		| FormalParameters ',' 	FormalParameter						
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
		| 													
	  	;
Throws
		: THROWS ExceptionTypeList
		;

ExceptionTypeList
		: ExceptionType	
		| ExceptionTypeList ',' ExceptionType
		;

ExceptionType
		: ClassType
		| TypeVariable
		;

MethodBody
		:  Block 												
		| ';'													
		;

InstanceInitializer
		: Block
		;

StaticInitializer
		: STATIC Block
		;

ConstructorDeclaration
		: ConstructorModifiers ConstructorDeclarator Throws_opt ConstructorBody
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

ConstructorDeclarator
		: TypeParameters_opt SimpleTypeName '(' FormalParameterList_opt')'
		;

SimpleTypeName
		: IDENTIFIER
		;
////////// Todo //////////////////////
ConstructorBody
		: '{' ExplicitConstructorInvocation_opt BlockStatements_opt'}'
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
		: EnumConstantModifiers EnumConstantModifier
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
		: AnnotationTypeElementModifers UnannType IDENTIFIER '(' ')' Dims_opt DefaultValue_opt ';'
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

Annotations
		: Annotations Annotation								
		| /* Empty */											
		;

Annotation
		: NormalAnnotation											
		| MarkerAnnotation
		| SingleElementAnnotation
		;

NormalAnnotation
		: '@' TypeName '(' ElementValuePairList_opt ')'
		;

ElementValuePairList_opt
		: 
		| ElementValuePairList
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
		: '{' ElementValueList '}'
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
		: '{' BlockStatements_opt '}'							
		;

BlockStatements_opt
		: BlockStatements										
		| /* Empty */											
		;

BlockStatements
		: BlockStatement 
		| BlockStatements BlockStatement					
		;

BlockStatement
		: LocalVariableDeclarationsAndStatement					
		| Statement												
		| ClassDeclaration										
		;

LocalVariableDeclarationsAndStatement
		: LocalVariableDeclaration ';'							
		;

LocalVariableDeclaration
		: VariableModifiers UnannType VariableDeclaratorList	
		;

Statement 
		: StatementWithoutTrailingSubstatement				
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
		| ExpressionStatement 									
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
		: StatementExpression ';'								
		;

StatementExpression
		: Assignment											
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
		: SwitchBlockStatementGroups SwitchBlockStatementGroup
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
		: FOR '(' ForInit ';' Expression ';' ForUpdate ')' Statement
		;

BasicForStatementNoShortIf
		: FOR '(' ForInit ';' Expression ';' ForUpdate ')' StatementNoShortIf
		;

ForInit
		: 
		| StatementExpressionList
		| LocalVariableDeclaration
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
		| TRY Block Catches_opt Finally_opt
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
		: PrimaryNoNewArray
		| ArrayCreationExpression
		;

PrimaryNoNewArray
		: 
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
		: LambdaExpression
		| AssignmentExpression
		;

Expression_opt
		: Expression
		|
		;

LambdaExpression
		: LambdaParameters ARROW LambdaBody
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
		: ConditionalExpression
		| Assignment
		;

Assignment
		: LeftHandSide AssignmentOperator Expression			
		;

LeftHandSide
		: ExpressionName										
		| FieldAccess
		| ArrayAccess
		;

AssignmentOperator
		: '='													
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
		: IntegerLiteral										
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

