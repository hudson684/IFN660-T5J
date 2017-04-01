using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript
{
    public abstract class Expression : Node { };

    public class AssignmentExpression : Expression
    {
        private Expression lhs, rhs;

        public AssignmentExpression(Expression lhs, Expression rhs)
        {
            this.lhs = lhs;
            this.rhs = rhs;
        }

    }

    public class VariableExpression : Expression
    {
        private string value;

        public VariableExpression(string value)
        {
            this.value = value;
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


