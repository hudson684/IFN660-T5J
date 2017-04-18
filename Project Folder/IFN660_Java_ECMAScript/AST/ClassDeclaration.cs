using System;
using System.Collections.Generic;

namespace IFN660_Java_ECMAScript.AST
{
 
    public class ClassDeclaration: Node, Declaration
    {
        private List<Modifier> classModifiers;
        private String classIdentifier;
        private List<MethodDeclaration> methodDeclarations;
       // private ClassDeclaration classDeclaration;

        public ClassDeclaration(String classIdentifier, List<Modifier> classModifiers, List<MethodDeclaration> methodDeclarations = null)
        {
            this.classIdentifier = classIdentifier;
            this.classModifiers = classModifiers;
            this.methodDeclarations = methodDeclarations;
        }

        public string GetName()
        {
            return classIdentifier;
        }

        public override Boolean ResolveNames(LexicalScope scope)
        {
            // Step 1: set the new scope
            var newScope = new LexicalScope();
            newScope.ParentScope = scope;
            newScope.Symbol_table = new Dictionary<string, Declaration>();

            // Step 2: Check for declarations in the new scope and add to symbol_table of old scope
            if (methodDeclarations != null)
            {
                foreach (MethodDeclaration each in methodDeclarations)
                {
                    newScope.Symbol_table.Add(each.GetName(), each);
                }
            }

            // Step 3: ResolveNames for each method
            bool loopResolve = true;

            if (methodDeclarations != null)
            {
                foreach (MethodDeclaration each in methodDeclarations)
                {
                    loopResolve = loopResolve & each.ResolveNames(newScope);
                }
            }

            return loopResolve;
        }

    }
}
