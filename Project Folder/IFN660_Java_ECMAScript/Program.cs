//#define AST_MANUAL // comment out this line to use parser&scanner

using System;
using System.IO;
using IFN660_Java_ECMAScript.AST;
using System.Collections.Generic;
using System.Text;

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

            var argList = new List<Statement> { new VariableDeclaration(new ArrayType(new NamedType("STRING")), "args") };

            var lhs = new VariableExpression("x");
            var rhs = new IntegerLiteralExpression(42);

            var assignVar = new VariableDeclaration(new NamedType("INTEGER"), "x");

            var assignExpr = new AssignmentExpression(lhs, rhs);
            var assignStmt = new ExpressionStatement(assignExpr);
            //var assignExpr2 = new AssignmentExpression(lhs, new VariableExpression("Main"));
            //var assignStmt2 = new ExpressionStatement(assignExpr2);
            //var statementList = new List<Statement> { assignVar, assignStmt, assignStmt2 };

            //IfthenStatement test
            var binaryExpression = new BinaryExpression(lhs, "==", rhs);
            var ifThenStatement = new IfThenStatement(binaryExpression, assignStmt);
            var statementList = new List<Statement> { assignVar, assignStmt, ifThenStatement };

            var method = new MethodDeclaration("Main", mods, new BlockStatement(statementList), new NamedType("VOID"), argList);
            var classDec = new ClassDeclaration("HelloWorld", classMods, new List<Statement> { method });

            var classes = new List<Statement>  { classDec };

            var pro = new CompilationUnitDeclaration(null, null, classes);

            
            // Semantic Analysis
            SemanticAnalysis(pro);

            pro.DumpValue(0);
            
#else
            Scanner scanner = new Scanner(
               new FileStream(args[0], FileMode.Open));
            Parser parser = new Parser(scanner);
            parser.Parse();
            if (Parser.root != null)
            {
                SemanticAnalysis(Parser.root);
                CodeGeneration(args[0], Parser.root);
            }
            
            Parser.root.DumpValue(0);
         
#endif

        }

        static void SemanticAnalysis(Node root)
        {
            bool nameResolutionSuccess;

            // name resolution
            nameResolutionSuccess = root.ResolveNames(null);
            if (!nameResolutionSuccess)
            {
                System.Console.WriteLine("*** ERROR - Name Resolution Failed ***");
                throw new Exception("Name Resolution Error");
            }
            
            // type checking
            root.TypeCheck();
           
            
        }

        /// <summary>
        /// CodeGeneration
        /// path: will return currentProjectPath/bin/Debug
        /// Use string buider here rather than write directly to a file
        /// We only write to file when we done 
        /// Use {{ and to output a { and }} for } otherwise an exception will occur
        /// </summary>
        /// <param name="inputFile"></param>
        /// <param name="root"></param>
        static void CodeGeneration(string inputFile, Statement root)
        {
            string outputFilename = inputFile + @".il"; 
            string path = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, outputFilename);
            //Console.WriteLine(path);

            StringBuilder sb = new StringBuilder();
            Node.cg.emit(sb, ".assembly {0} {{}} {1}", inputFile, Environment.NewLine);
            root.GenCode(sb);

            //Console.WriteLine(sb);

            //Write text to file and set append to false
            using (StreamWriter wr = new StreamWriter(path,false))
            {
                wr.WriteLine(sb);
               
            }
        }
    }
}
