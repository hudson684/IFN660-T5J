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


    }

    //changed made by Josh so that the assignmentStatement is correct
    public class AssignmentExpression : Expression
    {
        private Expression leftHandSide;
        private Expression rightHandSide;
        private string assignmentExpressor;
        public AssignmentExpression(Expression leftHandSide, string assignmentExpressor, Expression rightHandSide)
        {
            this.leftHandSide = leftHandSide;
            this.rightHandSide = rightHandSide;
            this.assignmentExpressor = assignmentExpressor;
        }
    }

}


