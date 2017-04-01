%namespace GPLexTutorial
%union
{
    public int num;
    public string name;
}

%token <num> NUMBER
%token <name> IDENT
%token IF ELSE INT BOOL


%%

Program: 
       ;

// Part B by Adon
ClassBodyDeclarations: ClassBodyDeclaration
                     ;

ClassBodyDeclaration: ClassMemberDeclarations
                    ;

ClassMemberDeclarations: ClassMemberDeclaration
                       ;

ClassMemberDeclaration: MethodModifiers MethodHeaders MethodBody
                      ;

MethodModifiers: MethodModifier
               | MethodModifier MethodModifiers
               ;

MethodModifier: 'Public'
              | 'static'
              ;

MethodHeaders: MethodHeader
             ;

%%

public Parser(Scanner scanner) : base(scanner)
{
}
