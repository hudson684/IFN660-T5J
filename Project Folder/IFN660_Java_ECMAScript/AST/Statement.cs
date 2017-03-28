using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript
{
    
    public abstract class Statement : Node
    {
    };

    public class IfStatement : Statement
    {
        private Expression Cond;
        private Statement Then, Else;
        public IfStatement(Expression Cond, Statement Then, Statement Else)
        {
            this.Cond = Cond; this.Then = Then; this.Else = Else;
        }
    }
}
