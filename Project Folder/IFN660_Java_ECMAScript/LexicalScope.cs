using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript
{
    public class LexicalScope
    {
        protected LexicalScope parentScope;
        protected Dictionary<string, Declaration> symbol_table;
        public LexicalScope()
        {
            parentScope = null;
            symbol_table.Clear();
        }

        public Declaration ResolveHere(string symbol)
        {
            var it = symbol_table.Where(p => p.Key == symbol).Select(p => p.Value) as Declaration;
            if (it != null)
                return it;
            else return null;
        }

        public Declaration Resolve(string symbol)
        {
            Declaration local = ResolveHere(symbol);
            if (local != null)
                return local;
            else if (parentScope != null)
                return parentScope.Resolve(symbol);
            else
                return null;
        }
    }
}
