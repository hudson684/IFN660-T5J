using System;
using System.Collections.Generic;

namespace IFN660_Java_ECMAScript.AST
{
    public class CompilationUnitDeclaration : Node
    {
        private PackageDeclarationStatement PackageDeclaration;
        private List<ImportDeclaration> ImportDeclarations;
        private List<ClassDeclaration> ClassDeclarations;


        public CompilationUnitDeclaration(PackageDeclarationStatement PackageDeclaration, List<ImportDeclaration> ImportDeclarations, List<ClassDeclaration> ClassDeclarations)
        {
            this.PackageDeclaration = PackageDeclaration;
            this.ImportDeclarations = ImportDeclarations;
            this.ClassDeclarations = ClassDeclarations;
        }

        public override bool ResolveNames(LexicalScope scope)
        {

            // Step 1: set the new scope
            var newScope = new LexicalScope();
            newScope.ParentScope = scope;
            newScope.Symbol_table = new Dictionary<string, Declaration>();

            // Step 2: Check for declarations in the new scope and add to symbol_table of old scope
            foreach (ClassDeclaration each in ClassDeclarations)
            {
                newScope.Symbol_table.Add(each.GetName(), each);
            }
            
            // Step 3: ResolveNames for each part of the complilation unit
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
    }

}
