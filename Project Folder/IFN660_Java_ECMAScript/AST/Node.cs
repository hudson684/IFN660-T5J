using System;
using System.Collections;
using System.Collections.Generic;

namespace IFN660_Java_ECMAScript.AST
{
	public abstract class Node
	{

		public abstract Boolean ResolveNames(LexicalScope scope);
		public abstract Boolean TypeCheck();

		void Indent(int n)
		{
			for (int i = 0; i < n; i++)
				Console.Write("    ");
		}

		public void DumpValue(int indent)
		{
			Indent(indent);
			if (this is Declaration)
				Console.WriteLine("{0} - {1:X8}", GetType().ToString(), GetHashCode());
			else
				Console.WriteLine("{0}", GetType().ToString());

			Indent(indent);
			Console.WriteLine("{");

			foreach (var field in GetType().GetFields(System.Reflection.BindingFlags.NonPublic |
																		   System.Reflection.BindingFlags.Instance))
			{
				object value = field.GetValue(this);
				Indent(indent + 1);

				if (value is Node)
				{

					if ((value is Declaration))
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
				else
					Console.WriteLine("{0}: {1}", field.Name, value);

				if (value is IEnumerable && !(value is String))
				{
					var e = (IEnumerable)value;

					Indent(indent + 1);
					Console.WriteLine("[");

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

			}

			Indent(indent);
			Console.WriteLine("}");
		}

		public static LexicalScope getNewScope(LexicalScope oldScope, List<Statement> statementList, List<Statement> argList)
		{
			// Step 1: set the new scope
			var newScope = new LexicalScope();
			newScope.ParentScope = oldScope;
			newScope.Symbol_table = new Dictionary<string, Declaration>();

			// Step 2: Check for declarations in the new scope and add to symbol_table of old scope
			if (statementList != null)
			{
				foreach (Statement each in statementList)
				{
					Declaration decl = each as Declaration; // try to cast statement as a declaration
					if (decl != null)
					{
						foreach (string name in decl.GetName())
						{
							newScope.Symbol_table.Add(name, decl);
						}
					}
				}
			}

			if (argList != null)
			{
				foreach (VariableDeclaration each in argList)
				{
					newScope.Symbol_table.Add(each.GetName()[0], each);
				}
			}

			return newScope;
		}
	}
}
