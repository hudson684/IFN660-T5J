using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
	public class ImportDeclaration : Statement
	{
		public ImportDeclaration()
		{ }

		public override bool ResolveNames(LexicalScope scope)
		{
			return true;
		}
		public override void TypeCheck()
		{
			
		}

	}

    public class SingleTypeImportDeclaration : ImportDeclaration
    {
        //by Vivian
        private string TypeName;
        

        public SingleTypeImportDeclaration(string TypeName)
        {
            this.TypeName = TypeName;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            //return TypeName.ResolveNames(scope);
        }

        public override void TypeCheck()
        {
           // TypeName.TypeCheck();
        }
    }

    public class TypeImportOnDemandDeclaration : ImportDeclaration
    {
        //by Vivian
        private string Name;

        public TypeImportOnDemandDeclaration(string Name)
        {
            this.Name = Name;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }

        public override void TypeCheck()
        {

        }
    }

    public class SingleStaticImportDeclaration : ImportDeclaration
    {
        //by Vivian
        private string TypeName;
        private string IdentifierName;

        public SingleStaticImportDeclaration(string TypeName, string IdentifierName)
        {
            this.TypeName = TypeName;
            this.IdentifierName = IdentifierName;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }

        public override void TypeCheck()
        {

        }
    }


    public class StaticImportOnDemandDeclaration : ImportDeclaration
    {
        //by Vivian
        private string Name;

        public StaticImportOnDemandDeclaration(string Name)
        {
            this.Name = Name;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }

        public override void TypeCheck()
        {

        }
    }

}
