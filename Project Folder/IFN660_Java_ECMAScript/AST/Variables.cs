using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
    public class VariableDeclaration : Expression, Declaration
    {
        private Type varType;
        private string name;
        int num;
        public VariableDeclaration(Type type, string name)
        {
            this.varType = type;
            this.name = name;
            num = LastLocal++;
        }

        public string GetName() { return name; }
        public int GetNumber() { return num; }
        public void AddItemsToSymbolTable(LexicalScope scope)
        {
            scope.Symbol_table.Add(name, this);
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            AddItemsToSymbolTable(scope);
            return varType.ResolveNames(scope);
        }
        public override void TypeCheck()
        {
            // needs something here - nathan
        }

        public override Type ObtainType()
        {
            return varType;
        }

        public override void GenCode(StringBuilder sb)
        {
            emit(sb, "\t.locals init ([{0}] {1} {2})\n", num, varType.GetILName(), name.ToString());
        }
    }

    public class VariableDeclarationList : Expression
    {
        // this class just builds a list of VariableDeclarations based on the input type and var names. Nathan
        private List<VariableDeclaration> variableDecs;

        public VariableDeclarationList(Type type, List<string> names)
        {
            variableDecs = new List<VariableDeclaration>();

            if (names != null)
            {
                foreach (string name in names)
                {
                    variableDecs.Add(new VariableDeclaration(type, name));
                }
            }
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            bool loopResolve = true;
            foreach (VariableDeclaration each in variableDecs)
            {
                each.ResolveNames(scope);
            }

            return loopResolve;
        }

        public override void TypeCheck()
        {

        }

        public override Type ObtainType()
        {
            return variableDecs[0].ObtainType();
        }
        public override void GenCode(StringBuilder sb)
        {
            foreach (VariableDeclaration each in variableDecs)
            {
                each.GenCode(sb);
            }
        }
    }

    public class FormalParam : Expression, Declaration
    {
        private Type varType;
        private string name;

        public FormalParam(Type type, string name)
        {
            this.varType = type;
            this.name = name;
        }

        public string GetName() { return name; }
        public int GetNumber() { return -1; }
        public void AddItemsToSymbolTable(LexicalScope scope)
        {
            scope.Symbol_table.Add(name, this);
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return varType.ResolveNames(scope);
        }
        public override void TypeCheck()
        {
            // needs something here - Nathan
        }

        public override Type ObtainType()
        {
            return varType;
        }

        public override void GenCode(StringBuilder sb)
        {
            // do nothing
        }
    }
}
