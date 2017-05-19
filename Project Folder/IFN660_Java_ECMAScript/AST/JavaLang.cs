using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
    // this class manages all things related to the Java.Lang standard library
    // written by Nathan


    class JavaLang: Declaration
    {
        public static LexicalScope getJavaLangScope()
        {
            var rootScope = new LexicalScope();

            return rootScope;
        }

        public void AddItemsToSymbolTable(LexicalScope scope)
        {
            scope.Symbol_table.Add("String", this);
            scope.Symbol_table.Add("System.out.println", new Println()); // should include "System.out.println"
        }

        public Type ObtainType()
        {
            return new NamedType("class");
        }

        public class Println: MethodDec
        {
            private string argument;

            public Println()
            {
                argument = null;
            }

            public void setArgument(string argument)
            {
                this.argument = argument;
            }

            public bool checkArgTypes(List<Expression> args)
            {
                
                if (args.Count > 1)
                    // return false if there is more than one argument
                    return false;
                else
                    // assuming the argument has a valid 'ToString()' method return true
                    return true;
            }

            public Type ObtainType()
            {
                return new NamedType("VOID");
            }

            public void AddItemsToSymbolTable(LexicalScope scope)
            {
                // nothing to add
            }
        }
    }
}
