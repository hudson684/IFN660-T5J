using System.Collections.Generic;

namespace IFN660_Java_ECMAScript.AST
{
    class Program
    {
        static void Main(string[] args)
        {
            //Scanner scanner = new Scanner(
            //   new FileStream(args[0], FileMode.Open));
            //Parser parser = new Parser(scanner);
            //parser.Parse();

            //var xExpres = new Exception { }
            Modifier[] mods = { Modifier.PUBLIC, Modifier.STATIC };
            Modifier[] classMods = { Modifier.PUBLIC };

            VariableDefinitionStatement[] argList = { new VariableDefinitionStatement(new ArrayType(new Type(type.STRING)), new VariableExpression("args") ) };

            var lhs = new VariableExpression("x");
            var rhs = new IntegerLiteralExpression(42);

            var assignVar = new VariableDefinitionStatement(new Type(type.INTEGER), lhs);

            var assignExpr = new AssignmentExpression(lhs, rhs);
            var assignStmt = new ExpressionStatement(assignExpr);
            Statement[] statementList = { assignVar, assignStmt }; 

            var method = new MethodDeclaration("Main", mods, statementList, type.VOID, argList);
            var classDec = new ClassDeclaration("HelloWorld", classMods, method);

            ClassDeclaration[] classes = { classDec };

            var pro = new CompilationUnitDeclaration(null, null, classes);

            pro.DumpValue(0);
        }
    }
}
