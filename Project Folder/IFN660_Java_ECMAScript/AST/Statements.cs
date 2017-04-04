using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
    public class Statements: Node
    {
        private Statement statement;
        private Statements statements;
        public Statements()
        {

        }

        public Statements(Statement statement)
        {
            this.statement = statement;
        }

        public Statements(Statement statement, Statements statements)
        {
            this.statement = statement;
            this.statements = statements;
        }
    }
}
