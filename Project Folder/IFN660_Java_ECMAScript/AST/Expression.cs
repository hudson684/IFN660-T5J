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
		public override Boolean TypeCheck()
		{
			return true;
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
		public override Boolean TypeCheck()
		{
			return true;
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
		public override Boolean TypeCheck()
		{
			return true;
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
		public override Boolean TypeCheck()
		{
			return true;
		}

	}

}


