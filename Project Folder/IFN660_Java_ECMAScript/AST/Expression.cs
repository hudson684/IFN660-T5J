namespace IFN660_Java_ECMAScript
{
    public abstract class Expression : Node { };

    public class PlusExpression : Expression
    {
        private Expression lhs, rhs;

        public PlusExpression(Expression lhs, Expression rhs)
        {
            this.lhs = lhs;
            this.rhs = rhs;
        }

    }

    public class IntegerLiteral : Expression
    {

        private int value;
        public IntegerLiteral(int value)
        {
            this.value = value;
        }


    };

}


