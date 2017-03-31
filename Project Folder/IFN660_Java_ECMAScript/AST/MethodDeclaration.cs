using System;

namespace IFN660_Java_ECMAScript.AST
{
    public class MethodDeclaration : Node
    {
        private Parameters parameters;
        private Statements statements;
        

        public MethodDeclaration(Parameters parameters, Statements statements)
        {
            this.parameters = parameters;
            this.statements = statements;
        }

    }
}
