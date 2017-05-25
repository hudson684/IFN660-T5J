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
        private string TypeName;
        private string Name;
        public ImportDeclaration(string TypeName)
		{
            this.TypeName = TypeName;
        }

        public ImportDeclaration(string TypeName, string Name)
        {
            this.TypeName = TypeName;
            this.Name = Name;
        }
        public override bool ResolveNames(LexicalScope scope)
		{
			return true;
		}
		public override void TypeCheck()
		{
			
		}

<<<<<<< HEAD
	}
=======
        public override void GenCode(StringBuilder sb)
        {

        }

    }

>>>>>>> master
}
