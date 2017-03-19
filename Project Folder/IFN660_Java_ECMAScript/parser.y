%namespace IFN660_Java_ECMAScript
%union
{
    public int num;
    public string name;
}

%token <num> NUMBER
%token <name> IDENT
%token IF ELSE INT BOOL GE
%token Void Main

%left '='
%nonassoc '<'
%left '+'

%%


Program : Statement
        ;

Statement : IF '(' Expression ')' Statement ELSE Statement
          | '{' StatementList '}'
          | Expression ';'
          | Type IDENT ';'
          ;

Type : INT
     | BOOL
     ;

StatementList : StatementList Statement
              | /* empty */
              ;

Expression : NUMBER
           | IDENT
           | Expression '=' Expression
           | Expression '+' Expression
           | Expression '<' Expression
           ;

Empty:
	 ;

// WORK By AN

CompilationUnit:
            PackageDeclaration_Opt
            ImportDeclarations
            TypeDeclarations
            ;

PackageDeclarationOpt
            :Empty
            ;

ImportDeclarations
            :Empty
            ;

TypeDeclarations
            :Empty 
            |TypeDeclaration TypeDeclarations
	        ;

TypeDeclaration
            : ClassDeclaration
	        | InterfaceDeclaration
	        ;

InterfaceDeclaration
            :
            ;

ClassDeclaration
            : NormalClassDeclaration
            | EnumDeclaration
            ;
EnumDeclaration
            :
            ;
NormalClassDeclaration
            : ClassModifiers class Identifier TypeParameters_Opt Superclass_Opt Superinterfaces_Opt ClassBody
            ;

ClassModifers
            : Empty
            | ClassModifer ClassModifers
            ;

ClassModifer
            : Annotation
            | public
            | protected
            | private
            | abstract
            | static
            | final
            | strictfp
            ;

Annotation
            : 
            ;

TypeParameters_Opt
            : Empty
            ;

Superclass_Opt
            : Empty
            ;

Superinterfaces_Opt
            : Empty
            ;
Identifier
            : IdentifierChars
            ;

IdentifierChars
            : JavaLetter JavaLetterOrDigits
            ;

JavaLetter
            :
            ;
JavaLetterOrDigits
            : Empty
            | JavaLetterOrDigit JavaLetterOrDigits
            ;
ClassBody
            :'{' ClassBodyDeclarations '}'
            ;

ClassBodyDeclarations
            : Empty
            | ClassBodyDeclaration ClassBodyDeclarations
            ;
ClassBodyDeclaration
            : ClassMemberDeclaration
            ;

ClassMemberDeclaration
            : MethodDeclaration
            ;

MethodDeclaration
            : MethodModifiers MethodHeader MethodBody
            ;

MethodModifiers
            : Empty
            | MethodModifier MethodModifiers
            ;
MethodModifier
            : Annotation
            | public
            | protected
            | private
            | abstract
            | static
            | final
            | synchronized
            | native
            | strictfp
            ;
MethodHeader
            : Result MethodDeclorator Throws_Opt
            ;

Throws_Opt
            : Empty
            | Throws
            ;
MethodBody
            :Empty
            ;

//WORK BY JOSH HUDSON
Result 
            : void
	        ;

Throws
            : Empty
	        ;
	 
MethodDeclorator
            : Identifier '(' FormalParameterList_Opt ')' Dims_Opt
			;

Identifier
            : Main
		    ;

//PLACEHOLDER - Josh
FormalParameterList_Opt
                : Empty
                | FormalParameterList
			    ;
FormalParameterList
            :FormalParameters
            ;

FormalParameters
            : FormalParameter '{','}'

Dims_Opt : Empty
		 ;

// JOSHUA'S WORK END

%%

public Parser(Scanner scanner) : base(scanner)
{
}
