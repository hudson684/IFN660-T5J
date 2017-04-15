using System;
using System.Collections.Generic;

namespace IFN660_Java_ECMAScript.AST
{
    public class MethodDeclaration : Node
    {

        //changed made by Josh to fix incorrect code be Adon.
        private List<Modifier> methodModifiers;
        private String methodIdentifier;
        //private MethodDeclaration methodDeclaration;
        private Type returnType;
        private List<Statement> statementList;
        private List<VariableDefinitionStatement> args;

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

        public MethodDeclaration(String methodIdentifier, List<Modifier> methodModifiers, List<Statement> statementList, Type returnType, List<VariableDefinitionStatement> args)
        {
            this.methodIdentifier = methodIdentifier;
            this.methodModifiers = methodModifiers;
            this.statementList = statementList;
            this.returnType = returnType;
            this.args = args;
        }

        public override Boolean ResolveNames(LexicalScope scope)
        {
            bool loopResolve = true;

            foreach (Statement each in statementList)
            {
                loopResolve = loopResolve & each.ResolveNames(scope);
            }

            foreach (VariableDefinitionStatement each in args)
            {
                loopResolve = loopResolve & each.ResolveNames(scope);
            }

            return loopResolve;
        }
    }
}
