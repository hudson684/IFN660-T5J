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
            // Step 1: Create new scope and populate the symbol table
            var newScope = getNewScope(scope, classBody);

            // Step 2: ResolveNames for each method
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
            emit(sb, ".class ", classIdentifier);
            foreach (var modif in classModifiers)
                emit(sb, "{0} ", modif);
            emit(sb, "{0} {{ {1}", classIdentifier, Environment.NewLine);
            foreach (var bd in classBody)
                bd.GenCode(sb);
            emit(sb, "}}");
        }

    }
}
