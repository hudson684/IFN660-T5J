using System;

namespace IFN660_Java_ECMAScript.AST
{
    public class MethodDeclaration : Node
    {

        //changed made by Josh to fix incorrect code be Adon.
        private Modifier[] methodModifiers;
        private String methodIdentifier;
        //private MethodDeclaration methodDeclaration;
        private Type returnType;
        private Statement[] statementList;
        private VariableDefinitionStatement[] args;

        /*
        public MethodDeclaration(String methodIdentifier, Modifier[] methodModifiers, MethodDeclaration methodDeclaration, Type returnType)
        {
            this.methodIdentifier = methodIdentifier;
            this.methodModifiers = methodModifiers;
            //this.methodDeclaration = methodDeclaration;
            this.returnType = returnType;
        }
        public MethodDeclaration(String methodIdentifier, Modifier[] methodModifiers, Type returnType)
        {
            this.methodIdentifier = methodIdentifier;
            this.methodModifiers = methodModifiers;
            this.returnType = returnType;
        }
         * */

        public MethodDeclaration(String methodIdentifier, Modifier[] methodModifiers, Statement[] statementList, Type returnType, VariableDefinitionStatement[] args)
        {
            this.methodIdentifier = methodIdentifier;
            this.methodModifiers = methodModifiers;
            this.statementList = statementList;
            this.returnType = returnType;
            this.args = args;
        }

        public override Boolean ResolveNames()
        {
            // need to put in loop to iterate over statementList
            return true;
        }
    }
}
