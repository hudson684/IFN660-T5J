using System;

namespace IFN660_Java_ECMAScript.AST
{
    public class MethodDeclaration : Node
    {

        //changed made by Josh to fix incorrect code be Adon.
        private Modifier[] methodModifiers;
        private String methodIdentifier;
        private MethodDeclaration methodDeclaration;
        private String result;
        private Statement[] statementList;

        public MethodDeclaration(String methodIdentifier, Modifier[] methodModifiers, MethodDeclaration methodDeclaration, String result)
        {
            this.methodIdentifier = methodIdentifier;
            this.methodModifiers = methodModifiers;
            this.methodDeclaration = methodDeclaration;
            this.result = result;
        }
        public MethodDeclaration(String methodIdentifier, Modifier[] methodModifiers, String result)
        {
            this.methodIdentifier = methodIdentifier;
            this.methodModifiers = methodModifiers;
            this.result = result;
        }

        public MethodDeclaration(String methodIdentifier, Modifier[] methodModifiers, Statement[] statementList, String result)
        {
            this.methodIdentifier = methodIdentifier;
            this.methodModifiers = methodModifiers;
            this.statementList = statementList;
            this.result = result;
        }


    }
}
