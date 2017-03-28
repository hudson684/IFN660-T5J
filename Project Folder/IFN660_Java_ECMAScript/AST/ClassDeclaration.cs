using System;

namespace IFN660_Java_ECMAScript.AST
{
 
    public class ClassDeclaration: Node
    {
        private Modifier[] classModifiers;
        private String classIdentifier;
        

        public ClassDeclaration(String classIdentifier, Modifier[] classModifiers)
        {
            this.classIdentifier = classIdentifier;
            this.classModifiers = classModifiers;
        }


    }
}
