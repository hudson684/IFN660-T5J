using System;

namespace IFN660_Java_ECMAScript.AST
{
    public class MethodDeclaration : Node
    {
        private Modifier[] methodModifiers;
        private String methodIdentifier;
        


        public MethodDeclaration(String methodIdentifier, Modifier[] methodModifiers)
        {
            this.methodIdentifier = methodIdentifier;
            this.methodModifiers = methodModifiers;
        }


    }
}
