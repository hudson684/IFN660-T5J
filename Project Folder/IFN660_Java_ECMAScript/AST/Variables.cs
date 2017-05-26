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
        private Expression initVal;
        int num;

        public VariableDeclaration(Type type, string name, Expression initVal = null)
        {
            this.varType = type;
            this.name = name;
            this.initVal = initVal;
            num = LastLocal++ - MethodOffsetLocal;
        }

        public string GetName() { return name; }
        public int GetNumber() { return num; }
        public void AddItemsToSymbolTable(LexicalScope scope)
        {
            scope.Symbol_table.Add(name, this);
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            // Step 1: Add variables to symboltable
            AddItemsToSymbolTable(scope);

            // Step 2: ResolveName on variable type
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
            cg.emit(sb, "\t.locals init ([{0}] {1} {2})\n", num, varType.GetILName(), name.ToString());

            // if initialiser is not null, evaluate the initialiser expression and store in variable
            if (initVal != null)
            {
                
                initVal.GenCode(sb);
                cg.emit(sb, "\tstloc.{0}\n", num);
            }
        }
    }

    public class VariableDeclarationList : Expression
    {
        // this class just builds a list of VariableDeclarations based on the input type and var names. Nathan
        private List<VariableDeclaration> variableDecs;

        public VariableDeclarationList(Type type, List<VariableDeclarator> names)
        {
            variableDecs = new List<VariableDeclaration>();

            if (names != null)
            {
                foreach (VariableDeclarator name in names)
                {
                    variableDecs.Add(new VariableDeclaration(type, name.getName(), name.getInitVal() ) );
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

    public class VariableDeclarator
    {
        // this class is needed to bridge between the way the Java grammar is written and the structure of the AST
        private string name;
        private Expression initVal;

        public VariableDeclarator(string name, Expression initVal)
        {
            this.name = name;
            this.initVal = initVal;
        }

        public string getName()
        { 
            return name;
        }
        public Expression getInitVal()
        {
            return initVal;
        }
    }

    public class FormalParam : Expression, Declaration
    {
        private Type varType;
        private string name;
        int num;

        public FormalParam(Type type, string name)
        {
            this.varType = type;
            this.name = name;
            num = LastArgument++ - MethodOffsetArgument;
        }

        public string GetName() { return name; }
        public int GetNumber() { return num; }
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
