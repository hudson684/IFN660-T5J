using System;
using System.Collections.Generic;

namespace IFN660_Java_ECMAScript.AST
{
    public class MethodDeclaration : Statement, Declaration
    {

        //changed made by Josh to fix incorrect code be Adon.
        private List<Modifier> methodModifiers;
        private String methodIdentifier;
        //private MethodDeclaration methodDeclaration;
        private Type returnType;
        private List<Statement> statementList;
        private List<Statement> args;

        public MethodDeclaration(String methodIdentifier, List<Modifier> methodModifiers, List<Statement> statementList, Type returnType, List<Statement> args)
        {
            this.methodIdentifier = methodIdentifier;
            this.methodModifiers = methodModifiers;
            this.statementList = statementList;
            this.returnType = returnType;
            this.args = args;
        }

        public string GetName()
        {
            return methodIdentifier;
        }

        public override Boolean ResolveNames(LexicalScope scope)
        {
            // Step 1: set the new scope
            var newScope = new LexicalScope();
            newScope.ParentScope = scope;
            newScope.Symbol_table = new Dictionary<string, Declaration>();

            // Step 2: Check for declarations in the new scope and add to symbol_table of old scope
            if (statementList != null)
            {
                foreach (Statement each in statementList)
                {
                    Declaration decl = each as Declaration; // try to cast statement as a declaration
                    if (decl != null)
                    {
                        newScope.Symbol_table.Add(decl.GetName(), decl);
                    }
                }
            }

            if (args != null)
            {
                foreach (VariableDeclaration each in args)
                {
                    newScope.Symbol_table.Add(each.GetName(), each);
                }
            }

            // Step 3: ResolveNames for each statement
            bool loopResolve = true;

            if (statementList != null)
            {
                foreach (Statement each in statementList)
                {
                    loopResolve = loopResolve & each.ResolveNames(newScope);
                }
            }

            return loopResolve;
        }
    }
}
