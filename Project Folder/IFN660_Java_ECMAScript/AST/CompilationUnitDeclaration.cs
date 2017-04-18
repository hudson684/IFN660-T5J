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

            // Step 2: Check for declarations in the new scope and add to symbol_table of old scope
            foreach (ClassDeclaration each in ClassDeclarations)
            {
                if (newScope.Symbol_table == null)
                {
                    newScope.Symbol_table = new Dictionary<string, Declaration>
                        { { each.GetName(), each } };
                }
                else
                {
                    newScope.Symbol_table.Add(each.GetName(), each);
                }
            }
            
            // Step 3: ResolveNames for each part of the complilation unit
            //   Maybe we don't need to ResolveNames for ImportDeclarations? - Nathan
            bool loopResolve = true;

            //foreach (ImportDeclaration each in ImportDeclarations)
            //{
            //    loopResolve = loopResolve & each.ResolveNames(newScope);
            //}

            foreach (ClassDeclaration each in ClassDeclarations)
            {
                loopResolve = loopResolve & each.ResolveNames(newScope);
            }

            // need to get loops for lists
            return loopResolve; // PackageDeclaration.ResolveNames(newScope) & loopResolve;
        }
    }

}
