using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
	public abstract class Expression : Node
	{
		public Type type;
        public abstract Type ObtainType();
    
        public static int LastLocal;
        //public virtual void GenCode(StreamWriter sb) { }
        public virtual void GenStoreCode(StringBuilder sb, string ex)
        {
            throw new Exception ( "Invalid " + ex );
        }
	}

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

            // check that the types are the same
            if (!lhs.type.isTheSameAs(rhs.type))
            {
                if (!lhs.type.isCompatibleWith(rhs.type))
                {
                    System.Console.WriteLine("Type error in AssignmentExpression\n");
                    throw new Exception("TypeCheck error");
                }
            }

            // set type to the lhs type
            type = lhs.type;
		}

        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {
            rhs.GenCode(sb);
            lhs.GenStoreCode(sb,"assignment");
            lhs.GenCode(sb);
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
				Console.WriteLine("Error: Undeclared indentifier", value);

			return declarationRef != null;
		}
		public override void TypeCheck()
		{
            type = declarationRef.ObtainType();
			
		}

        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {
            cg.emit(sb, "\tldloc.{0}\n", declarationRef.GetNumber());
        }

        public override void GenStoreCode(StringBuilder sb, string ex)
        {
            cg.emit(sb, "\tstloc.{0}\n", declarationRef.GetNumber());
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
                case ">":
                case "<":
                case "==":
                    if (!lhs.type.isTheSameAs(new NamedType("INT")) || !rhs.type.isTheSameAs(new NamedType("INT")))
                    {
                        System.Console.WriteLine("Invalid arguments for \"{0}\" expression\n", oper);
                        throw new Exception("TypeCheck error");
                    }
                    type = new NamedType("BOOLEAN");
                    break;
                case "+":
                case "-":
                case "*":
                case "%":
                case "/":
                    if (lhs.type.isTheSameAs(rhs.type) && !lhs.type.isTheSameAs(new NamedType("BOOLEAN")))
                    {
                        type = lhs.type;
                    }
                    else if (lhs.type.isCompatibleWith(rhs.type))
                    {
                        type = lhs.type;
                    }
                    else if (rhs.type.isCompatibleWith(lhs.type))
                    {
                        type = rhs.type;
                    }
                    else
                    {
                        System.Console.WriteLine("Invalid arguments for less than expression\n");
                        throw new Exception("TypeCheck error");
                    }
                    break;
               
                default:
                    {
                        System.Console.WriteLine("Unexpected binary operator %c \n", oper);
                        throw new Exception("TypeCheck error");
                    }
            }
		}

        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {
            lhs.GenCode(sb);
            rhs.GenCode(sb);
            switch (oper)
            {
                case "<":
                    cg.emit(sb, "\tclt\n");
                    break;
                case ">":
                    cg.emit(sb, "\tcgt\n");  
                    break;
                case "==":
                    cg.emit(sb, "\tceq\n");  
                    break;
                case "+":
                    cg.emit(sb, "\tadd\n");
                    break;
                case "-":
                    cg.emit(sb, "\tsub\n");
                    break;
                case "%":
                    cg.emit(sb, "\trem\n"); 
                    break;
                case "*":
                    cg.emit(sb, "\tmul\n");  
                    break;
                case "/":
                    cg.emit(sb, "\tdiv\n");  
                    break;
                    Console.WriteLine("Unexpected binary operator {0}\n", oper);
                    break;
            }
        }
    }

    public class InstanceOfExpression : Expression
    {
        private Expression lhs;
        //private Type type;
        public InstanceOfExpression(Expression lhs, Type type)
        {
            this.lhs = lhs;
            this.type = type;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return lhs.ResolveNames(scope);
        }

        public override void TypeCheck()
        {
            
        }

        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {
            lhs.GenCode(sb);
		}
    }


    public class PreUnaryExpression : Expression
    {
        private Expression expression;
        private string oper;

        public PreUnaryExpression(string oper, Expression expression)
        {
            this.expression = expression;
            this.oper = oper;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return expression.ResolveNames(scope);
        }
        public override void TypeCheck()
        {
            
        }
        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {
            expression.GenCode(sb);
            switch (oper)
            {
                case "++":
                    cg.emit(sb, "\tadd\n");  
                    break;
                case "--":
                    cg.emit(sb, "\tsub\n");  
                    break;
                default:
                    Console.WriteLine("Unexpected preunary operator {0}\n", oper);
                    break;
            }
        }
    }

    public class PostUnaryExpression : Expression
    {
        private Expression expression;
        private string oper;

        public PostUnaryExpression(Expression expression, string oper)
        {
            this.expression = expression;
            this.oper = oper;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return expression.ResolveNames(scope);
        }
        public override void TypeCheck()
        {
            
        }

        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {
            expression.GenCode(sb);
            switch (oper)
            {
                case "++":
                    cg.emit(sb, "\tadd\n"); 
                    break;
                case "--":
                    cg.emit(sb, "\tsub\n");  
                    break;
                default:
                    Console.WriteLine("Unexpected postunary operator {0}\n", oper);
                    break;
            }
        }

    }
    public class CastExpression : Expression
    {
        private Type PrimitiveType;
        private Expression UnaryExpression;
        public CastExpression(Type PrimitiveType, Expression UnaryExpression)
        {
            this.PrimitiveType = PrimitiveType;
            this.UnaryExpression = UnaryExpression;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return UnaryExpression.ResolveNames(scope);
        }
        public override void TypeCheck()
        {
            try
            {
                if (PrimitiveType != null & UnaryExpression != null)
                {
                    PrimitiveType.TypeCheck();
                    UnaryExpression.TypeCheck();
                    // Set type to Primitivetype
                    // We're assuming everything is Int in this compiler
                    // Therefore there's no need to check if an Expression is FP-strict or not at this point
                    // If both are not null. Set type to PrimitiveType
                    type = PrimitiveType;
                }
            }
            catch
            {
                if (PrimitiveType == null)
                {
                    throw new Exception("Missing PrimitiveType!");
                }
                else
                {
                    throw new Exception("Missing Expression!");
                }
            }
        }

        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {
            UnaryExpression.GenCode(sb);
        }

    }
}

	


