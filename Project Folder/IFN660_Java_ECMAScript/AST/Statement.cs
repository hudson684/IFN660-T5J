namespace IFN660_Java_ECMAScript.AST
{
    
    public abstract class Statement : Node
    {
    };

    public class IfStatement : Statement
    {
        private Expression Cond;
        private Statement Then, Else;
        public IfStatement(Expression Cond, Statement Then, Statement Else)
        {
            this.Cond = Cond; this.Then = Then; this.Else = Else;
        }

        public override bool ResolveNames()
        {
            return Cond.ResolveNames() & Then.ResolveNames() & Else.ResolveNames();
        }
    }

    public class WhileStatement : Statement
    {
        // by Nathan
        private Expression Cond;
        private Statement[] StmtList;

        public WhileStatement(Expression Cond, Statement[] StmtList)
        {
            this.Cond = Cond;
            this.StmtList = StmtList;
        }

        public override bool ResolveNames()
        {
            return Cond.ResolveNames(); // & StmtList.ResolveNames();
        }
    }

    public class ForStatement : Statement
    {
        // by Nathan - still testing
        private Statement ForInit;
        private Expression TestExpr;
        private Statement ForUpdate;
        private Statement[] StmtList;

        public ForStatement(Statement ForInit, Expression TestExpr, Statement ForUpdate, Statement[] StmtList)
        {
            this.ForInit = ForInit;
            this.TestExpr = TestExpr;
            this.ForUpdate = ForUpdate;
            this.StmtList = StmtList;
        }

        public override bool ResolveNames()
        {
            return ForInit.ResolveNames() & TestExpr.ResolveNames() & ForUpdate.ResolveNames();// & StmtList.ResolveNames();
        }
    }

    public class ExpressionStatement : Statement
    {
        private Expression expr;

        public ExpressionStatement (Expression expr)
        {
            this.expr = expr;
        }

        public override bool ResolveNames()
        {
            return expr.ResolveNames();
        }
    }

    public class VariableDefinitionStatement : Statement
    {
        private Type VariableType;
        private string VariableName;
        private Expression VariableAssignment;

        public VariableDefinitionStatement(Type VariableType, string VariableName, Expression VariableAssignment)
        {
            this.VariableType = VariableType;
            this.VariableName = VariableName;
            this.VariableAssignment = VariableAssignment;
        }

        public override bool ResolveNames()
        {
            // do something here...
            return VariableAssignment.ResolveNames();
        }

    }
    public class VariableDeclaration : Statement
    {
        private Type type;
        private string name;
        public VariableDeclaration(Type type, string name)
        {
            this.type = type;
            this.name = name;
        }
        public override bool ResolveNames()
        {
            // do something here...
            return type.ResolveNames();
        }
    };




}
