using System;
using System.Collections.Generic;


namespace IFN660_Java_ECMAScript.AST
{
    public class CompilationUnitDeclaration : Node
    {
        private PackageDeclaration[] PackageDeclarations;
        private ImportDeclaration[] ImportDeclarations;
        private ClassDeclaration[] TypeDeclarations;

        public CompilationUnitDeclaration(PackageDeclaration[] PackageDeclarations, ImportDeclaration[] ImportDeclarations, ClassDeclaration[] TypeDeclarations)
        {
            this.PackageDeclarations = PackageDeclarations;
            this.ImportDeclarations = ImportDeclarations;
            this.TypeDeclarations = TypeDeclarations;
        }
    }

}
