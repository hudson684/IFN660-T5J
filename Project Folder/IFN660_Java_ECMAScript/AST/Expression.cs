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
            // if the variable is an argument as opposed to a variable
            // use the ldarg instruction rather than the ldloc instruction
            FormalParam fp = declarationRef as FormalParam;
            if (fp != null)
            {
                cg.emit(sb, "\tldarg.{0}\n", fp.GetNumber());
            }
            else
            {
                cg.emit(sb, "\tldloc.{0}\n", declarationRef.GetNumber());
            }
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
                case ">=":
                case "<=":
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
                default:
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
            expression.TypeCheck();
            switch (oper)
            {
                case "++":
                case "--":
                case "~":
                case "+":
                case "-":
                    if (expression.type.isTheSameAs(new NamedType("INT")) || expression.type.isTheSameAs(new NamedType("DOUBLE")) || expression.type.isTheSameAs(new NamedType("FLOAT")) || expression.type.isTheSameAs(new NamedType("DOUBLE")))
                    {
                        type = expression.type;
                    }
                    else
                    {
                        System.Console.WriteLine("Invalid arguments for numeric expression\n");
                        throw new Exception("TypeCheck error");
                    }
                    break;
                 // Khoa. "!"is only used for Boolean
                case "!":
                    if (expression.type.isTheSameAs(new NamedType("BOOLEAN")))
                    {
                        type = expression.type;
                    }
                    else
                    {
                        System.Console.WriteLine("Invalid arguments for Boolean expression\n");
                        throw new Exception("TypeCheck error");
                    }
                    break;
                default:
                    {
                        System.Console.WriteLine("Unexpected uniary operator %c \n", oper);
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
            expression.GenCode(sb);
            switch (oper)
            {
                case "++":
                    cg.emit(sb, "\tadd\n");  
                    break;
                case "--":
                    cg.emit(sb, "\tsub\n");  
                    break;
                case "-":
                    cg.emit(sb, "\tneg\n");
                    break;
                case "+":
                    cg.emit(sb, "\tpos\n");
                    break;
                case "~":
                    cg.emit(sb, "\tnot\n");
                    break;
                case "!":
                    cg.emit(sb, "\tceq\n");
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
            expression.TypeCheck();
            switch (oper)
            {
                case "++":
                case "--":
                // Khoa, removed "+", "-", "~", and "!" as PostUnaryExpression only take "++" and "--" 
                    if (expression.type.isTheSameAs(new NamedType("INT")) || expression.type.isTheSameAs(new NamedType("DOUBLE")) || expression.type.isTheSameAs(new NamedType("FLOAT")) || expression.type.isTheSameAs(new NamedType("DOUBLE")))
                    {
                        type = expression.type;
                    }
                    else
                    {
                        System.Console.WriteLine("Invalid arguments for expression\n");
                        throw new Exception("TypeCheck error");
                    }
                    break;
                default:
                    {
                        System.Console.WriteLine("Unexpected uniary operator %c \n", oper);
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
        private Expression Expression;
        public CastExpression(Type PrimitiveType, Expression Expression)
        {
            this.PrimitiveType = PrimitiveType;
            this.Expression = Expression;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return Expression.ResolveNames(scope);
        }
        public override void TypeCheck()
        {
            PrimitiveType.TypeCheck();
            Expression.TypeCheck();
            //first check if expression.type is boolean if primitivetype is bool      
            if (PrimitiveType.isTheSameAs(new NamedType("BOOLEAN")))
            {
                if (Expression.type.isTheSameAs(new NamedType("BOOLEAN")))
                {
                    // if unaryexpression is indeed in boolean type, set type to boolean
                    type = PrimitiveType;
                }
                else
                {
                    throw new Exception("Expression has to be in Boolean Type!");
                }
            }
            // if expression.type is anything else but boolean, check if it's compatible with primitivetype
            else
            {
                // Check if PrimitiveType is compatible with type of Expression
                if (PrimitiveType.isCompatibleWith(Expression.type))
                {
                    // if yes, set type to primititvetype
                    type = PrimitiveType;
                }
                else
                {
                    throw new Exception("PrimitiveType is not compatible with type of Expression!");
                }
            }
        }

        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {
            Expression.GenCode(sb);
            // The type casting only happens when Expression.type != PrimitiveType
            // The is also no type casting for Boolean values as Boolean can only be converted to Boolean
            if (!PrimitiveType.isTheSameAs(Expression.type) && !PrimitiveType.isTheSameAs(new NamedType("BOOLEAN"))) 
            {
                // Assuming that GenCode() is reached only when TypeCheck() has been done
                // Meaning public variable type has already been set to PrimitiveType.
                // If this is not the case, need to find a way to export PrimitiveType to string
                switch (PrimitiveType.GetILName())  //Get IL Name of each Named Type. Source: GetILName() in Type.cs
                {
                    case "uint8": //BYTE
                        cg.emit(sb, "\tconvert.u1\n");
                        break;
                    case "int16":  //SHORT
                        cg.emit(sb, "\tconvert.i2\n");
                        break;
                    case "char":   //CHAR
                        cg.emit(sb, "\tconvert.u2\n");
                        break;
                    case "int32":  //INT
                        cg.emit(sb, "\tconvert.i4\n");
                        break;
                    case "int64":  //LONG
                        cg.emit(sb, "\tconvert.i8\n");
                        break;
                    case "float32":  //FLOAT
                        cg.emit(sb, "\tconvert.r4\n");
                        break;
                    case "float64":  //DOUBLE
                        cg.emit(sb, "\tconvert.r8\n");
                        break;
                    default:
                        Console.WriteLine("Unexpected PrimitiveType {0}\n", PrimitiveType);
                        break;
                }
            }
        }
    }
}

	


