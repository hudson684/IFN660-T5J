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
        private List<VariableDeclaration> args;

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

        public MethodDeclaration(String methodIdentifier, List<Modifier> methodModifiers, List<Statement> statementList, Type returnType, List<VariableDeclaration> args)
        {
            this.methodIdentifier = methodIdentifier;
            this.methodModifiers = methodModifiers;
            this.statementList = statementList;
            this.returnType = returnType;
            this.args = args;
        }

        public override Boolean ResolveNames(LexicalScope scope)
        {
            // Step 1: set the new scope
            var newScope = new LexicalScope();
            newScope.ParentScope = scope;

            // Step 2: Check for declarations in the new scope and add to symbol_table of old scope
            foreach (Statement each in statementList)
            {
                Declaration decl = each as Declaration;
                if (decl != null)
                {
                    if (newScope.Symbol_table == null)
                    {
                        newScope.Symbol_table = new Dictionary<string, Declaration>
                            { { decl.GetName(), decl } };
                    }
                    else
                    {
                        newScope.Symbol_table.Add(decl.GetName(), decl);
                    }
                }
            }

            // Step 3: ResolveNames for each part of the complilation unit
            bool loopResolve = true;

            foreach (Statement each in statementList)
            {
                loopResolve = loopResolve & each.ResolveNames(newScope);
            }

            // this is maybe not needed? - Nathan
            foreach (VariableDeclaration each in args)
            {
                loopResolve = loopResolve & each.ResolveNames(newScope);
            }

            return loopResolve;
        }
    }
}
