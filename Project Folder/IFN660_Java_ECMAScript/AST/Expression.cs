using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
	public abstract class Expression : Node
	{
		public Type type;
	};

	public class AssignmentExpression : Expression
	{
		private Expression lhs, rhs;

		public AssignmentExpression(Expression lhs, Expression rhs)
		{
			this.lhs = lhs;
			this.rhs = rhs;
		}

		public override bool ResolveNames(LexicalScope scope)
		{
			return lhs.ResolveNames(scope) & rhs.ResolveNames(scope);
		}
		public override void TypeCheck()
		{
            lhs.TypeCheck();
            rhs.TypeCheck();
            if (!rhs.type.IsAssignableFrom(lhs.type))
            {
                System.Console.WriteLine("Type error in AssignmentExpression\n");
                throw new Exception("TypeCheck error");
            }
            type = rhs.type;
		}



	}

	public class VariableExpression : Expression
	{
		private string value;
		private Declaration declarationRef;

		public VariableExpression(string value)
		{
			this.value = value;
			this.declarationRef = null;
		}

		public override bool ResolveNames(LexicalScope scope)
		{
			// check for valid declaration...
			if (scope != null)
			{
				declarationRef = scope.Resolve(value);
			}

			if (declarationRef == null)
				Debug.WriteLine("Error: Undeclared indentifier", value);
			else
				Debug.WriteLine("Found variable in scope", value);

			return declarationRef != null;
		}
		public override void TypeCheck()
		{
            type = declarationRef.GetType();
			
		}

	}

	public class IntegerLiteralExpression : Expression
	{

		private long value;
		public IntegerLiteralExpression(long value)
		{
			this.value = value;
		}

		public override bool ResolveNames(LexicalScope scope)
		{
			return true;
		}
		public override void TypeCheck()
		{
            type = new IntType();
		} 

	}

	//changed made by Josh so that the assignmentStatement is correct
	public class BinaryExpression : Expression
	{
		private Expression lhs, rhs;
		private string oper;
		public BinaryExpression(Expression lhs, string oper, Expression rhs)
		{
			this.lhs = lhs;
			this.rhs = rhs;
			this.oper = oper;
		}

		public override bool ResolveNames(LexicalScope scope)
		{
			return lhs.ResolveNames(scope) & rhs.ResolveNames(scope);
		}
		public override void TypeCheck()
		{
            lhs.TypeCheck();
            rhs.TypeCheck();
            switch (oper)
            {
                case "<":
                    if (!lhs.type.Equals(new IntType()) || !lhs.type.Equals(new IntType()))
                    {
                        System.Console.WriteLine("Invalid arguments for less than expression\n");
                        throw new Exception("TypeCheck error");
                    }
                    type = new BoolType();
                    break;
                case "+":
                    if (!lhs.type.Equals(new IntType()) || !lhs.type.Equals(new IntType()))
                    {
                        System.Console.WriteLine("Invalid arguments for less than expression\n");
                        throw new Exception("TypeCheck error");
                    }
                    type = new IntType();
                    break;
               
                default:
                    {
                        System.Console.WriteLine("Unexpected binary operator %c \n", oper);
                        throw new Exception("TypeCheck error");
                    }
                    break;
            }
		}

	}

}


