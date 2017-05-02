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
            var newScope = getNewScope(scope, statements);

            // Step 2: ResolveNames for each part of the complilation unit
            bool loopResolve = true;

            if (statements != null)
            {
                foreach (Statement each in statements)
                {
                    loopResolve = loopResolve & each.ResolveNames(newScope);
                }
            }

            return loopResolve;
        }

        public override void TypeCheck()
        {
            // do something here - Nathan
        }

    }
}
