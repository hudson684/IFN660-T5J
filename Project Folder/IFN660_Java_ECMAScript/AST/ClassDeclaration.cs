using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace IFN660_Java_ECMAScript.AST
{
    public class ClassDeclaration: Statement, Declaration
    {
        private List<Modifier> classModifiers;
        private String classIdentifier;
        private List<Statement> classBody;
       // private ClassDeclaration classDeclaration;

        public ClassDeclaration(String classIdentifier, List<Modifier> classModifiers, List<Statement> classBody = null)
        {
            this.classIdentifier = classIdentifier;
            this.classModifiers = classModifiers;
            this.classBody = classBody;
        }

        public void AddItemsToSymbolTable(LexicalScope scope)
        {
            scope.Symbol_table.Add(classIdentifier, this);
        }

        public int GetNumber() {
            return 0;
        }
        public override Boolean ResolveNames(LexicalScope scope)
        {
            // Step 1: Add class name to current scope
            //AddItemsToSymbolTable(scope);
            // Step 0: add all class declarations to the current scope
            foreach (Statement each in classBody)
            {
                Declaration methodDec = each as Declaration;
                if (methodDec != null)
                    methodDec.AddItemsToSymbolTable(scope);
            }

            // Step 2: Create new scope
            var newScope = getNewScope(scope, null);

            // Step 3: ResolveNames for each statement in the class
            bool loopResolve = true;

            if (classBody != null)
            {
                foreach (Statement each in classBody)
                {
                    loopResolve = loopResolve & each.ResolveNames(newScope);
                }
            }
            return loopResolve;
        }

        public override void TypeCheck()
        {
            classBody.ForEach(x => x.TypeCheck());
        }

        public Type ObtainType()
        {
            return new NamedType("CLASS");
        }

        public override void GenCode(StringBuilder sb)
        {
            cg.emit(sb, ".class {0} {{\n", classIdentifier);

            /* not required
            foreach (var modif in classModifiers)
                emit(sb, "{0} ", modif);
            emit(sb, "{0} {{ {1}", classIdentifier, Environment.NewLine);
            */
            foreach (var bd in classBody)
                bd.GenCode(sb);

            cg.emit(sb, "}}");
        }

    }
}
