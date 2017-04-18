#define AST_MANUAL

using System;
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
            var statementList = new List<Statement> { assignVar, assignStmt }; 

            var method = new MethodDeclaration("Main", mods, statementList, new NamedType("VOID"), argList);
            var classDec = new ClassDeclaration("HelloWorld", classMods, method);

            var classes = new List<ClassDeclaration>  { classDec };

            var pro = new CompilationUnitDeclaration(null, null, classes);

            // Semantic Analysis
            var rootScope = new LexicalScope();
            pro.ResolveNames(rootScope);

            pro.DumpValue(0);
            
#else
            Scanner scanner = new Scanner(
               new FileStream(args[0], FileMode.Open));
            //Parser parser = new Parser(scanner);
            //parser.Parse();
            //Parser.root.DumpValue(0);
#endif

        }

        bool SemanticAnalysis(Node root)
        {
            return root.ResolveNames(null);
        }
    }
}
