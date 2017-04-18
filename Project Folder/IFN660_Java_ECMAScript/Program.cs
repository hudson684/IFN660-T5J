using System; 
using System.IO;
using IFN660_Java_ECMAScript.AST;

namespace IFN660_Java_ECMAScript
{
    class Program
    {
        static void Main(string[] args)
        {
            Scanner scanner = new Scanner(
               new FileStream(args[0], FileMode.Open));
            //Parser parser = new Parser(scanner);
            //parser.Parse();
            //Parser.root.DumpValue(0);
            
            ////var xExpres = new Exception { }
            /*
            var mods = new List<Modifier> { Modifier.PUBLIC, Modifier.STATIC };
            var classMods = new List<Modifier> { Modifier.PUBLIC };

            var argList = new List<VariableDefinitionStatement> { new VariableDefinitionStatement(new ArrayType(new NamedType("STRING")), "args") }; // "args" was varexpr

            var lhs = new VariableExpression("x");
            var rhs = new IntegerLiteralExpression(42);

            var assignVar = new VariableDefinitionStatement(new NamedType("INTEGER"), "x"); // "x" was lhs

            var assignExpr = new AssignmentExpression(lhs, rhs);
            var assignStmt = new ExpressionStatement(assignExpr);
            var statementList = new List<Statement> { assignVar, assignStmt }; 

            var method = new MethodDeclaration("Main", mods, statementList, new NamedType("VOID"), argList);
            var classDec = new ClassDeclaration("HelloWorld", classMods, method);

            var classes = new List<ClassDeclaration>  { classDec };

            var pro = new CompilationUnitDeclaration(null, null, classes);

            pro.DumpValue(0);
            */
       Arr
        }
        bool SemanticAnalysis(Node root)
        {
            return root.ResolveNames(null);
        }
    }
}
