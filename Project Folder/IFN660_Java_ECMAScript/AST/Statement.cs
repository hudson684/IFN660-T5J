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

        public VariableDefinitionStatement(Type VariableType, Expression VariableName)
        {
            this.VariableType = VariableType;
            this.VariableName = VariableName;
        }

    }


   

}
