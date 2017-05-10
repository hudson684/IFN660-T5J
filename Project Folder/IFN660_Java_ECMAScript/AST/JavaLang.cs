using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
    // this class manages all things related to the Java.Lang standard library
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
            scope.Symbol_table.Add("System.out.println", this);
        }

        public Type ObtainType()
        {
            return new NamedType("class");
        }
    }
}
