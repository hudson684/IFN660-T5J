using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
	public class Parameters : Node
	{
		private String[] str;
		public Parameters(String[] str)
		{
			this.str = str;
		}

		public override bool ResolveNames(LexicalScope scope)
		{
			// need to more here...
			return true;
		}
		public override Boolean TypeCheck()
		{
			return true;
		}

	}
}
