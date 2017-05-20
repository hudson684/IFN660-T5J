using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace IFN660_Java_ECMAScript.AST
{
	public abstract class Node
	{

		public abstract Boolean ResolveNames(LexicalScope scope);
		public abstract void TypeCheck();

		void Indent(int n)
		{
			for (int i = 0; i < n; i++)
				Console.Write("    ");
		}

		public void DumpValue(int indent)
		{
			Indent(indent);
			if (this is Declaration)
				Console.WriteLine("{0} - {1:X8}", GetType().Name, GetHashCode());
			else
				Console.WriteLine("{0}", GetType().Name);

			Indent(indent);
			Console.WriteLine("{");

			foreach (var field in GetType().GetFields(System.Reflection.BindingFlags.NonPublic |
																		   System.Reflection.BindingFlags.Instance))
			{
				object value = field.GetValue(this);
				Indent(indent + 1);

                if (value is Node)
                {

                    if (!(value is VariableDeclarationList) && (value is Declaration)) 
                    {
                        Console.WriteLine("{0}: {1:X8}", field.Name, value.GetHashCode());
                        //Indent(indent + 2);
                        //Console.WriteLine("{0}", value.GetHashCode());
                    }
                    else
                    {
                        Console.WriteLine("{0}:", field.Name);
                        ((Node)value).DumpValue(indent + 2);
                    }
                }
                else if (value is IEnumerable && !(value is String))
                {                              
                    Console.WriteLine("{0}: [", field.Name);
                    var e = (IEnumerable)value;
                    foreach (var item in e)
                    {
                        if (item is Node)
                            ((Node)item).DumpValue(indent + 2);
                        else
                        {
                            Indent(indent + 2);
                            Console.WriteLine(item);
                        }
                    }
                    Indent(indent + 1);
                    Console.WriteLine("]");
                }
                else
                    Console.WriteLine("{0}: {1}", field.Name, value);
            }
			Indent(indent);
			Console.WriteLine("}");
		}

		public static LexicalScope getNewScope(LexicalScope oldScope, List<Expression> variableList)
		{
            // Step 1: Create scope that includes standard libraries (ie Java.Lang) if oldScope == null.
            if (oldScope == null)
            {
                var JLnode = new JavaLang();
                oldScope = new LexicalScope();
                oldScope.Symbol_table = new Dictionary<string, Declaration>();
                JLnode.AddItemsToSymbolTable(oldScope);
            }

			// Step 1: set the new scope
			var newScope = new LexicalScope();
			newScope.ParentScope = oldScope;
			newScope.Symbol_table = new Dictionary<string, Declaration>();

			// Step 2: Check for declarations in the new scope and add to symbol_table of old scope
			if (variableList != null)
			{
				foreach (Expression each in variableList)
				{
					Declaration decl = each as Declaration; // try to cast statement as a declaration
					if (decl != null)
					{
                        decl.AddItemsToSymbolTable(newScope);
					}
				}
			}

			return newScope;
		}

        /// <summary>
        /// Use Stringbuider to append all the text rather then invoke I/O read/write
        /// </summary>
        /// <param name="sb"> Current StringBuidler object</param>
        /// <param name="fmt">String with format i.e "X = {0}",x</param>
        /// <param name="args">
        /// params allow use to have variable number of parameter
        /// We use object[] so we dont need to think about type
        /// https://msdn.microsoft.com/en-us/library/ms229008(v=vs.100).aspx
        /// </param>
        internal void emit(StringBuilder sb, string fmt, params object[] args)
        {
            sb.AppendFormat(fmt, args);
            //sb.Write(Environment.NewLine);
        }

        public abstract void GenCode(StringBuilder sb);


        // Helper function to do List typecheck
        //public static void ListTypeCheck<T>(List<T> list) where T : Node
        //{
        //    foreach (T each in list)
        //    {
        //        each.TypeCheck();
        //    }
        //}
    }
}
