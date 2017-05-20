using System;
using System.Collections.Generic;
using System.IO;
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

        public override void GenCode(StringBuilder sb)
        {

        }

    }
}
