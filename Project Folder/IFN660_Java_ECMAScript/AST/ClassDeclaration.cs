using System;

namespace IFN660_Java_ECMAScript.AST
{
 
    public class ClassDeclaration: Node
    {
        private Modifier[] classModifiers;
        private String classIdentifier;
        private MethodDeclaration methodDeclaration;



        public ClassDeclaration(String classIdentifier, Modifier[] classModifiers, MethodDeclaration methodDeclaration)
        {
            this.classIdentifier = classIdentifier;
            this.classModifiers = classModifiers;
            this.methodDeclaration = methodDeclaration;
        }


    }
}
