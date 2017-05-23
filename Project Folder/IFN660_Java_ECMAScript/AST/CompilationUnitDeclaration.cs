using System;

using System.Collections.Generic;

namespace IFN660_Java_ECMAScript.AST
{
    public class CompilationUnitDeclaration : Statement
    {
        private Statement PackageDeclaration;
        private List<Statement> ImportDeclarations;
        private List<Statement> ClassDeclarations;


        public CompilationUnitDeclaration(Statement PackageDeclaration, List<Statement> ImportDeclarations, List<Statement> ClassDeclarations)
        {
            this.PackageDeclaration = PackageDeclaration;
            this.ImportDeclarations = ImportDeclarations;
            this.ClassDeclarations = ClassDeclarations;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            // Step 1: Create new scope and populate the symbol table
            var newScope = getNewScope(scope, ClassDeclarations, null);

            
            // Step 2: ResolveNames for each part of the complilation unit
            bool loopResolve = true;

            if (ClassDeclarations != null)
            {
                foreach (ClassDeclaration each in ClassDeclarations)
                {
                    loopResolve = loopResolve & each.ResolveNames(newScope);
                }
            }

            // need to do something special with package declarations and import declarations - Nathan

            return loopResolve; 
        }

        public override void TypeCheck()
        {
            ClassDeclarations.ForEach(x => x.TypeCheck());
            
            // 2 lines belwo will give errors cause we did not implemented anything within 2 classesl.
            //this.PackageDeclaration.TypeCheck();
            //ImportDeclarations.ForEach(x => x.TypeCheck());
        }
    }

}
