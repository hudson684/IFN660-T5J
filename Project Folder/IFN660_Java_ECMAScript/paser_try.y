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


UnannClassType
		: IDENTIFIER TypeArguments_opt
		//| UnannClassOrInterfaceType '.' Annotations IDENTIFIER TypeArguments_opt
		;


TryStatement
		: TRY Block Catches										{ } //Adon
		//| TRY Block Catches_opt Finally							{ } //Adon
		//| TryWithResourcesStatement
		;

//Catches_opt
//		: Catches												{ } //Adon
//		|														{ } //Adon
//		;

Catches
		: CatchClause											{ $$ =  $1; } //Adon
		| Catches CatchClause									{ } //Adon
		;

CatchClause
		: CATCH '(' CatchFromalParameter ')' Block				{ } //Adon
		;

CatchFromalParameter
		: VariableModifiers CatchType VariableDeclaratorId		{ } //Adon
		;

CatchType
		: UnannClassType										{ } //Adon
//		| CatchType '|' CatchType								{ } //Adon
		;

//Finally_opt
//		: Finally												{ $$ = $1; } //Adon
//		|
//		;

//Finally
//		: FINALLY Block											{ $$ = $1; } //Adon
//		;

//TryWithResourcesStatement
//		: TRY ResourceSpecification Block Catches_opt Finally_opt
//		;
