#define AST_MANUAL // comment out this line to use parser&scanner

using System.IO;
using IFN660_Java_ECMAScript.AST;
using System.Collections.Generic;

namespace IFN660_Java_ECMAScript
{
    class Program
    {
        static void Main(string[] args)
        {

#if AST_MANUAL
            //var xExpres = new Exception { }
            
            var mods = new List<Modifier> { Modifier.PUBLIC, Modifier.STATIC };
            var classMods = new List<Modifier> { Modifier.PUBLIC };

            var argList = new List<VariableDeclaration> { new VariableDeclaration(new ArrayType(new NamedType("STRING")), "args") };

            var lhs = new VariableExpression("x");
            var rhs = new IntegerLiteralExpression(42);

            var assignVar = new VariableDeclaration(new NamedType("INTEGER"), "x");

            var assignExpr = new AssignmentExpression(lhs, rhs);
            var assignStmt = new ExpressionStatement(assignExpr);
            //var assignExpr2 = new AssignmentExpression(lhs, new VariableExpression("Main"));
            //var assignStmt2 = new ExpressionStatement(assignExpr2);
            //var statementList = new List<Statement> { assignVar, assignStmt, assignStmt2 };
            var statementList = new List<Statement> { assignVar, assignStmt };

            var method = new MethodDeclaration("Main", mods, statementList, new NamedType("VOID"), argList);
            var classDec = new ClassDeclaration("HelloWorld", classMods, new List<MethodDeclaration> { method });

            var classes = new List<ClassDeclaration>  { classDec };

            var pro = new CompilationUnitDeclaration(null, null, classes);

            // Semantic Analysis
            bool nameResolutionSuccess;
            nameResolutionSuccess = pro.ResolveNames(null);

            pro.DumpValue(0);

            if (!nameResolutionSuccess)
                System.Console.WriteLine("*** ERROR - Name Resolution Failed ***");

#else
            Scanner scanner = new Scanner(
               new FileStream(args[0], FileMode.Open));
            Parser parser = new Parser(scanner);
            parser.Parse();
            Parser.root.DumpValue(0);
#endif

        }

        bool SemanticAnalysis(Node root)
        {
            return root.ResolveNames(null);
        }
    }
}
