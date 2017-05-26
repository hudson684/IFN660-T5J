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

        public int GetNumber()
        {
            return -1;
        }

        public class StringConCat: Node
        {
            public override bool ResolveNames(LexicalScope scope)
            {
                return true; // nothing to do
            }

            public override void TypeCheck()
            {
                // nothing to do
            }

            public static void GenCallCode(StringBuilder sb, params Expression[] args)
            {
                
                foreach (Expression arg in args)
                {
                    arg.GenCode(sb);
                    if (!arg.type.isTheSameAs(new NamedType("String")))
                    {
                        cg.emit(sb, "\tbox\t\t[mscorlib]System.{0}\n", arg.type.GetCorLibName());
                    }
                }
                cg.emit(sb, "\tcall\tstring [mscorlib]System.String::Concat(");
                String objString = "";
                for (int i = 0; i<args.Length; i++)
                {
                    objString = objString + "object, ";
                }
                objString = objString.TrimEnd(',',' ');// remove last ','
                cg.emit(sb, objString + ")\n");
            }

            public override void GenCode(StringBuilder sb)
            {
                throw new NotImplementedException();
            }
        }

        public class Println: Node, MethodDec
        {

            public Println()
            {
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

            public int GetNumber()
            {
                return -1;
            }

            public void AddItemsToSymbolTable(LexicalScope scope)
            {
                // nothing to add
            }

            public override bool ResolveNames(LexicalScope scope)
            {
                return true; // nothing to do
            }

            public override void TypeCheck()
            {
                // nothing to do
            }
            public void GenCallCode(StringBuilder sb)
            {

                //string varType = arg.ObtainType().GetILName();
                //arg.GenCode(sb);
                cg.emit(sb, "\tcall\tvoid [mscorlib]System.Console::WriteLine(");
            }

            public override void GenCode(StringBuilder sb)
            {
                throw new NotImplementedException();
            }
        }
    }
}
