using System;
using System.Collections;
using System.Collections.Generic;

namespace IFN660_Java_ECMAScript.AST
{
    public abstract class Node
    {

        void Indent(int n)
        {
            for (int i = 0; i < n; i++)
                Console.Write("    ");
        }

        public abstract Boolean ResolveNames(LexicalScope scope);

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
    }
}
