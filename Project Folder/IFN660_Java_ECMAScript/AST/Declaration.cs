using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript
{
    public interface Declaration
    {
	    AST.Type ObtainType();
        void AddItemsToSymbolTable(LexicalScope scope);
        int GetNumber();
    }

}
