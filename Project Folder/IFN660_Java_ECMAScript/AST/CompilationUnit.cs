using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
    public class CompilationUnit : Node
    {
        private ClassDeclaration classDeclaration;
        private PackageDeclaration packageDeclaration;
        private ImportDeclaration importDeclaration;

        public CompilationUnit(ClassDeclaration classDeclaration, PackageDeclaration packageDecalration, ImportDeclaration importDecalration)
        {
            this.classDeclaration = classDeclaration;
            this.packageDeclaration = null;
            this.importDeclaration = null;
        }
    }

}
