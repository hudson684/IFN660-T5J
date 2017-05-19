using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
	public abstract class Type : Node
	{
        /*
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
        */

        public abstract bool isTheSameAs(Type type);
        public abstract bool isCompatibleWith(Type type);
        public abstract string GetILName();
        

        /*
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
        */
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
        public override bool isTheSameAs(Type type)
        {
            NamedType nType = type as NamedType; // try to cast type argument as NamedType
            if (nType != null)
            {
                if (this.elementType == nType.elementType || this.elementType.Equals("NULL") || nType.elementType.Equals("NULL"))
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            else
            {
                return false;
            }
        }

        public override bool isCompatibleWith(Type type)
        {
            bool compatible = true;
            String[] primitives = { "BOOLEAN", "BYTE", "SHORT", "CHAR", "INT", "LONG", "FLOAT", "DOUBLE" };

            NamedType nType = type as NamedType; // try to cast type argument as NamedType
            if (nType != null)
            {
                if (primitives.Contains(this.elementType))
                {
                    if (primitives.Contains(nType.elementType))
                    {
                        // Widening Primitve Conversion - see 5.1.2 of the Java spec

                        int thisIndex = Array.IndexOf(primitives, this.elementType);
                        int thatIndex = Array.IndexOf(primitives, nType.elementType);

                        // check if either are boolean
                        if (thisIndex == 0 || thatIndex == 0)
                            compatible = false;

                        if (thisIndex > thatIndex) // should be OK, just need to check a couple of special cases
                        {
                            if (thisIndex == 3) // nothing can be converted to a char
                                compatible = false;
                        }
                        else
                        {
                            compatible = false; // can't convert higher index to lower index
                        }
                    }
                    else
                    {
                        // do something to handle referenceTypes
                        compatible = false;
                    }
                }
                else
                {
                    // do something to handle referenceTypes
                    compatible = false;
                }
            }
            else
            {
                compatible = false;
            }

            return compatible;
        }

        public override string GetILName()
        {
            switch (elementType)
            {
                case ("BOOLEAN"):
                    return "bool";
                case ("BYTE"):
                    return "uint8";
                case ("SHORT"):
                    return "int16";
                case ("INT"):
                    return "int32";
                case ("LONG"):
                    return "int64";
                case ("CHAR"):
                    return "char";
                case ("FLOAT"):
                    return "float32";
                case ("DOUBLE"):
                    return "float64";
                case ("String"):
                    return "string";
                default:
                    return "";
            }
            

        }

        public override void GenCode(StringBuilder sb)
        {
            emit(sb, "{0} ", elementType.ToLower());
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

        public override bool isTheSameAs(Type type)
        {
            ArrayType nType = type as ArrayType; // try to cast type argument as ArrayType
            if (nType != null)
            {
                return this.elementType.isTheSameAs(nType.elementType); //recursive call to check the next level type is the same
            }
            else
            {
                return false;
            }

        }

        public override bool isCompatibleWith(Type type)
        {
            return true;
        }

        public override string GetILName()
        {
            return elementType.GetILName() + "[]";
        }
        public override void GenCode(StringBuilder sb)
        {

        }
    }

       
    public class IntType : Type
	{
        public override bool ResolveNames(LexicalScope scope)
		{
			return true;
		}

        public override bool isTheSameAs(Type type)
        {
            return true;

        }

        public override bool isCompatibleWith(Type type)
        {
            return true;
        }

        public override void TypeCheck()
		{
			
		}

        public override string GetILName()
        {
            return "int32";
        }

        public override void GenCode(StringBuilder sb)
        {

        }
    }

	/*public class BoolType : Type
	{

		public override bool ResolveNames(LexicalScope scope)
		{
			return true;
		}
		public override void TypeCheck()
		{
			
		}

	}
    */
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
