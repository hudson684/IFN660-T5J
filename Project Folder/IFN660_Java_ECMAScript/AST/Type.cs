﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
    public abstract class Type : Node
    {
    }

    public class ArrayType : Type
    {
        private Type elementType;

        public ArrayType(Type elementType)
        {
            this.elementType = elementType;
        }
    }

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
}
