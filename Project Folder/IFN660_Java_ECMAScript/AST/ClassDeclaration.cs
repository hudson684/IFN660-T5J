using System;
using System.Collections.Generic;

namespace IFN660_Java_ECMAScript.AST
{
 
    public class ClassDeclaration: Node, Declaration
    {
        private List<Modifier> classModifiers;
        private String classIdentifier;
        private MethodDeclaration methodDeclaration;
       // private ClassDeclaration classDeclaration;

        public ClassDeclaration(String classIdentifier, List<Modifier> classModifiers, MethodDeclaration methodDeclaration = null)
        {
            this.classIdentifier = classIdentifier;
            this.classModifiers = classModifiers;
            this.methodDeclaration = methodDeclaration;
        }

        public string GetName()
        {
            return classIdentifier;
        }

        public override Boolean ResolveNames(LexicalScope scope)
        {
            return methodDeclaration.ResolveNames(scope); 
        }

    }
}
