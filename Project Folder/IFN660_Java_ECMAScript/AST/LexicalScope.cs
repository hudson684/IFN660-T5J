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
            this.parentScope = null;
            this.symbol_table = new Dictionary<string, Declaration>();
        }

        public LexicalScope ParentScope
        {
            get;
            set;
        }

        public Dictionary<string, Declaration> Symbol_table
        {
            get;
            set;
        }

        public Declaration ResolveHere(string symbol)
        {
            Declaration it;
            if (Symbol_table.TryGetValue(symbol, out it))
                return it;
            else
                return null;
        }

        public Declaration Resolve(string symbol)
        {
            Declaration local = ResolveHere(symbol);
            if (local != null)
                return local;
            else if (ParentScope != null)
                return ParentScope.Resolve(symbol);
            else
                return null;
        }
    }
}
