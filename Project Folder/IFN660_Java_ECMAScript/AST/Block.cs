using System;
using System.Collections.Generic;

namespace IFN660_Java_ECMAScript.AST
{
    public class BlockStatement : Statement
    {
        private List<Statement> statements;

        public BlockStatement (List<Statement> statements)
        {
            this.statements = statements;
        }

        public List<Statement> Statements
        { get; }

        public override bool ResolveNames(LexicalScope scope)
        {
            // Step 1: Create new scope and populate the symbol table
            // Special case with blocks - add to symbol table line by line as the names are resolved.
            // This is the catch the situation where the declaration is after the use of the variable.
            var newScope = getNewScope(scope, null); 

            // Step 2: ResolveNames for each part of the complilation unit
            bool loopResolve = true;

            if (statements != null)
            {
                foreach (Statement each in statements)
                {
                    Declaration decl = each as Declaration; // try to cast statement as a declaration
                    if (decl != null)
                    {
                        decl.AddItemsToSymbolTable(newScope);
                    }
                    loopResolve = loopResolve & each.ResolveNames(newScope);
                }
            }

            return loopResolve;
        }

        public override void TypeCheck()
        {
            statements.ForEach(x => x.TypeCheck());
        }

    }
}
