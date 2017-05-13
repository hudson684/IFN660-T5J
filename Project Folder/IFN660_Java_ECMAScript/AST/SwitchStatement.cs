using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
    public class SwitchStatement : Statement       // KoJo
    {
        private Expression expression;
        private List<Statement> StmtList;
        // Something for SwitchBlock
        public SwitchStatement(Expression expression, List<Statement> StmtList)
        {
            this.expression = expression;
            this.StmtList = StmtList;
        }


        public override bool ResolveNames(LexicalScope scope)
        {
            bool loopResolve = true;

            foreach (Statement each in StmtList)
            {
                loopResolve = loopResolve & each.ResolveNames(scope);
            }

            return expression.ResolveNames(scope) & loopResolve;
        }
    }

    public class SwitchLabelStatement : Statement
    {

        //this exists for case with Expression
        public SwitchLabelStatement(Expression switchValue)
        {

        }

        //this exists for case with Constant Name
        public SwitchLabelStatement(String switchValueName)
        {

        }

        //this exists for the default case
        public SwitchLabelStatement()
        {

        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }
    }

}
