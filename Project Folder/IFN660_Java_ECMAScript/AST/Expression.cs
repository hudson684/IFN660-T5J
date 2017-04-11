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

        public override bool ResolveNames()
        {
            return lhs.ResolveNames() & rhs.ResolveNames();
        }

    }

    public class VariableExpression : Expression
    {
        private string value;

        public VariableExpression(string value)
        {
            this.value = value;
        }

        public override bool ResolveNames()
        {
            // check for valid declaration...
            return true;
        }
    }

    public class IntegerLiteralExpression : Expression
    {

        private int value;
        public IntegerLiteralExpression(int value)
        {
            this.value = value;
        }

        public override bool ResolveNames()
        {
            return true;
        }
    }

    //changed made by Josh so that the assignmentStatement is correct
    public class BinaryExpression : Expression
    {
        private Expression leftHandSide;
        private Expression rightHandSide;
        private string assignmentExpressor;
        public BinaryExpression(Expression leftHandSide, string assignmentExpressor, Expression rightHandSide)
        {
            this.leftHandSide = leftHandSide;
            this.rightHandSide = rightHandSide;
            this.assignmentExpressor = assignmentExpressor;
        }

        public override bool ResolveNames()
        {
            return leftHandSide.ResolveNames() & rightHandSide.ResolveNames();
        }
    }

}


