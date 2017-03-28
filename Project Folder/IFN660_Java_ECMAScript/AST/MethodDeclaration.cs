using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
