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
        public override void TypeCheck()
        {
            ///for(statement in blockstatement){
            ///     try(statement.getSwitchLabelisDef){
            ///         if(statement.getswitchLabelisDef){
            ///             expression.getType().comparable(statement.typecheck())
            ///         } else {
            ///             //type check is true because this is the default value
            ///         }
            ///     } // do not attempt anything if there is no getSwitchLabelisDefault
            /// } end loop with all nescesary typechecking.
            ///         





        
            

        }
    }

    public class SwitchLabelStatement : Statement
    {
        private Expression switchValue;
        private Boolean switchLabelNotDefault; 


        public Boolean getSwitchLabelNotDefault()
        {
            return switchLabelNotDefault;
        }
        //this exists for case with Expression
        public SwitchLabelStatement(Expression switchValue)
        {
            this.switchValue = switchValue;
            switchLabelNotDefault = true; 
        }

        //this exists for case with Constant Name
        public SwitchLabelStatement(String switchValueName)
        {
            // Ignore this rabbit hole for now
        }

        //this exists for the default case
        public SwitchLabelStatement()
        {
            switchLabelNotDefault = false; 
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
