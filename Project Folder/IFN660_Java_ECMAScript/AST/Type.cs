using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
    public enum type
    {
        STRING,
        VOID,
        INTEGER
    }

    public class Type : Node
    {
        private Enum elementType;

        public Type() { }

        public Type (Enum elementType)
	    {
            this.elementType = elementType;
	    }
    }


    public class ArrayType : Type
    {
        private Type elementType;

        public ArrayType(Type elementType) 
        {
            this.elementType = elementType;
        }
    }
    
    /*
    public class VoidType : Type
    {
        public VoidType ()
        {
        }
    }

    public class StringType : Type
    {
        public StringType ()
        {
        }
    }

    public class IntegerType : Type
    {
        public IntegerType()
        {
        }
    }
     * */
}
