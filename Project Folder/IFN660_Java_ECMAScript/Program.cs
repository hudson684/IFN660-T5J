namespace IFN660_Java_ECMAScript.AST
{
    class Program
    {
        static void Main(string[] args)
        {

            //var xExpres = new Exception { }
            Modifier[] mods = { Modifier.PUBLIC, Modifier.STATIC };
            Modifier[] classMods = { Modifier.PUBLIC };

            var lhs = new VariableExpression("x");
            var rhs = new IntegerLiteralExpression(42);
            var assignExpr = new AssignmentExpression(lhs, rhs);
            var assignStmt = new ExpressionStatement(assignExpr);
            Statement[] statementList = { assignStmt }; 

            var method = new MethodDeclaration("Main", mods, statementList, new VoidType() );
            var pro = new ClassDeclaration("Hello World", classMods, method);
            pro.DumpValue(1);
        }
    }
}
