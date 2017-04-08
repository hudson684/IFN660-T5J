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
    }

    public class ExpressionStatement : Statement
    {
        private Expression expr;

        public ExpressionStatement (Expression expr)
        {
            this.expr = expr;
        }
    }

    public class VariableDefinitionStatement : Statement
    {
        private Type VariableType;
        private Expression VariableName;
        private Expression VariableAssignment;

        public VariableDefinitionStatement(Type VariableType, Expression VariableName, Expression VariableAssignment)
        {
            this.VariableType = VariableType;
            this.VariableName = VariableName;
            this.VariableAssignment = VariableAssignment;
        }

    }


   

}
