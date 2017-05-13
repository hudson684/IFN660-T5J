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
        private BlockStatement BlockStatement; 
        public SwitchStatement(Expression expression, BlockStatement BlockStatement)  //Khoa, replaced List<Statement> by BlockStatement
        {
            this.expression = expression;
            this.BlockStatement = BlockStatement; 
        }


        public override bool ResolveNames(LexicalScope scope)
        {
            bool loopResolve = true;
            //Khoa, replaced List<Statement> by BlockStatement
            return expression.ResolveNames(scope) & BlockStatement.ResolveNames(scope) & loopResolve;

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

    public class SwitchBlockStatementGroup : Statement
    {
        private List<SwitchLabelStatement> SwitchLabelStatementList;
        private List<Statement> StatementList; 

        public SwitchBlockStatementGroup(List<SwitchLabelStatement> SwitchLabelStatementList, List<Statement> StatementList)
        {
            this.SwitchLabelStatementList = SwitchLabelStatementList;
            this.StatementList = StatementList;
        }
        public override bool ResolveNames(LexicalScope scope)
        {
            bool loopResolve = true;

            foreach (Statement each in StatementList)
            {
                loopResolve = loopResolve & each.ResolveNames(scope);
            }

            foreach (SwitchLabelStatement each in SwitchLabelStatementList)
            {
                loopResolve = loopResolve & each.ResolveNames(scope); 
            }
            return loopResolve;
        }
        public override void TypeCheck()
        {

        }
    }
    public class SwitchLabelStatement : Statement
    {
        private Expression SwitchValue;
        private Boolean SwitchLabelNotDefault;

        public Boolean getSwitchLabelNotDefault()
        {
            return SwitchLabelNotDefault;
        }
        //this exists for case with Expression
        public SwitchLabelStatement(Expression SwitchValue)
        {
            this.SwitchValue = SwitchValue;
            SwitchLabelNotDefault = true;
        }

        //this exists for case with Constant Name
        public SwitchLabelStatement(String switchValueName)
        {
            // Ignore this rabbit hole for now
        }

        //this exists for the default case
        public SwitchLabelStatement()
        {
            SwitchLabelNotDefault = false;
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
