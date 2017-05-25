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
            type = declarationRef.ObtainType();

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
                case ">":
                case "<=":
                case ">=":
                case "==":
                case "!=":
                    if (!lhs.type.isTheSameAs(rhs.type) && !lhs.type.isTheSameAs(new NamedType("BOOLEAN")))
                    {
                        System.Console.WriteLine("Invalid arguments for less than expression\n");
                        return;
                        //throw new Exception("TypeCheck error");
                    }
                    type = new NamedType("BOOLEAN");
                    break;

                //Mathematical expressions
                case "+":
                case "-":
                case "*":
                case "%":
                case "/":
                case "^":
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
                        System.Console.WriteLine("Invalid arguments for expression\n");
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
                case "!":
                case "+":
                case "-":
                    if (!expression.type.isTheSameAs(new NamedType("BOOLEAN")))
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
    }
}


	


