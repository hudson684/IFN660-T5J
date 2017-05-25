using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
    public interface ILiteral { }
    public class IntegerLiteralExpression : Expression, ILiteral
    {
        private int value;
        public IntegerLiteralExpression(int value)
        {
            this.value = value;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }
        public override void TypeCheck()
        {
            type = new NamedType("INT");
        }

        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {
            cg.EmitInt(sb,value);
        }

    }
    public class LongLiteralExpression : Expression, ILiteral
    {
        private long value;
        public LongLiteralExpression(long value)
        {
            this.value = value;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }
        public override void TypeCheck()
        {
            type = new NamedType("LONG");
        }
         public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {
            cg.EmitLong(sb,value);
        }
    }
    public class BooleanLiteralExpression : Expression
    {
        private readonly bool value;
        public BooleanLiteralExpression(bool value)
        {
            this.value = value;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }
        public override void TypeCheck()
        {
            type = new NamedType("BOOLEAN");
        }

        public object GetValue()
        {
            return (object)value;
        }

        public string GetValueAsLiteral()
        {
            return value ? "true" : "false";
        }

        public long GetValueAsLong()
        {
            return value ? 1 : 0;
        }

        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {
            if (value)
                cg.emit(sb, "\tldc.i4.1\n");
            else
                cg.emit(sb, "\tldc.i4.0\n");
        }
    }

    public class FloatingLiteralExpression : Expression, ILiteral
    {
        private readonly float value;
        public FloatingLiteralExpression(float value)
        {
            this.value = value;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }
        public override void TypeCheck()
        {
            // A floating-point literal is of type float if it is suffixed with F or f;
            // otherwise its type is double
            // Need more check here
            type = new NamedType("FLOAT");
        }
        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {

        }
    }
    public class DoubleLiteralExpression : Expression, ILiteral
    {
        private readonly double value;
        public DoubleLiteralExpression(double value)
        {
            this.value = value;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }
        public override void TypeCheck()
        {
            // A floating-point literal is of type float if it is suffixed with F or f;
            // otherwise its type is double
            // Need more check here
            type = new NamedType("DOUBLE");
        }
        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {

        }
    }
    public class CharacterLiteralExpression : Expression
    {
        private char value;
        public CharacterLiteralExpression(char value)
        {
            this.value = value;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }
        public override void TypeCheck()
        {
            type = new NamedType("CHAR");
        }

        public override Type ObtainType()
        {
            return type;
        }


        public override void GenCode(StringBuilder sb)
        {

        }
    }

    public class StringLiteralExpression : Expression
    {
        private string value;
        public StringLiteralExpression(string value)
        {
            this.value = value;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }

        public override void TypeCheck()
        {
            type = new NamedType("String");
        }

        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {

        }
    }

    public class NullLiteralExpression : Expression
    {
        private readonly string value;
        public NullLiteralExpression()
        {
            this.value = "null";
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }

        public override void TypeCheck()
        {
            type = new NamedType("NULL");
        }

        public override Type ObtainType()
        {
            return type;
        }

        public override void GenCode(StringBuilder sb)
        {

        }
    }

    
}
