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
            bool loopResolve = true;

            foreach (ImportDeclaration each in ImportDeclarations)
            {
                loopResolve = loopResolve & each.ResolveNames(scope);
            }

            foreach (ClassDeclaration each in ClassDeclarations)
            {
                loopResolve = loopResolve & each.ResolveNames(scope);
            }

            // need to get loops for lists
            return PackageDeclaration.ResolveNames(scope) & loopResolve;
        }
    }

}
