using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
	public abstract class Type : Node
	{
		public static bool operator == (Type t1, Type t2)
		{
			return (object)t1 == (object)t2 || (object)t1 != null && (object)t2 !=null;
		}

		public static bool operator != (Type t1, Type t2)
		{
			return !(t1 == t2);
		}
		public bool Equals(Type type)
		{
			return this == type;
		}
        // override object.Equals
        public override bool Equals(object obj)
        {
            return Equals(obj as Type);
        }
		
		// override object.GetHashCode
		//public override int GetHashCode()
		//{
		//	Type type = this.type;
		//	// TODO: write your implementation of GetHashCode() here
		//	throw new System.NotImplementedException();
		//	return ReferenceEquals(type,this)? base.GetHashCode():type.GetHashCode();
		//}

		public bool IsAssignableFrom(Type type)
		{
			if(this.Equals(type))
			{
				return true;
			}else if(type == null)
			{
				return false;
			}else{
				return type.IsSubclassOf(this);
			}
		}

        public bool IsSubclassOf(Type type)
        {
            //Type thisType = this.BaseType;
            //while (thisType != null)
            //{
            //	if(thisType.Equals(type))
            //	{
            //		return true;
            //	}
            //	thisType = thisType.BaseType;
            //}
            return false;
        }
	}

	public class NamedType : Type
	{
		private string elementType;

		public NamedType(string elementType)
		{
			this.elementType = elementType;
		}

		public override bool ResolveNames(LexicalScope scope)
		{
			return true;
		}
		public override void TypeCheck()
		{
           
		}

	}

	public class IntType : Type
	{
        public override bool ResolveNames(LexicalScope scope)
		{
            

			return true;
		}
		public override void TypeCheck()
		{
			
		}

	}

	public class BoolType : Type
	{

		public override bool ResolveNames(LexicalScope scope)
		{
			return true;
		}
		public override void TypeCheck()
		{
			
		}

	}


	public class ArrayType : Type
	{
		private Type elementType;

		public ArrayType(Type elementType)
		{
			this.elementType = elementType;
		}

		public override bool ResolveNames(LexicalScope scope)
		{
			return true;
		}
		public override void TypeCheck()
		{
			
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
