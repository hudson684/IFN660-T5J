using System.Collections.Generic;
using System;
using System.Text;
using System.IO;

namespace IFN660_Java_ECMAScript.AST
{

	public abstract class Statement : Node
	{
        public static int LastLabel;
        //public virtual void GenCode(StreamWriter sb) { }
    };

    public class IfStatement : Statement
    {
        private Expression CondExpr;
        private Statement ThenStmts, ElseStmts;
        public IfStatement(Expression CondExpr, Statement ThenStmts, Statement ElseStmts)
        {
            this.CondExpr = CondExpr; this.ThenStmts = ThenStmts; this.ElseStmts = ElseStmts;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            if (ElseStmts == null)
                return CondExpr.ResolveNames(scope) & ThenStmts.ResolveNames(scope);
            else
                return CondExpr.ResolveNames(scope) & ThenStmts.ResolveNames(scope) & ElseStmts.ResolveNames(scope);
        }

        public override void TypeCheck()
        {
            CondExpr.TypeCheck();

            if (!CondExpr.type.isTheSameAs(new NamedType("BOOLEAN")))
            {
                Console.WriteLine("Invalid type for if statement condition\n");
                throw new Exception("TypeCheck error");
            }
            ThenStmts.TypeCheck();
            if (ElseStmts != null)
                ElseStmts.TypeCheck();
        }

        public override void GenCode(StringBuilder sb)
        {
            CondExpr.GenCode(sb);
            int elseLabel = LastLabel++;
            cg.emit(sb, "\tbrfalse L{0}\n", elseLabel);
            ThenStmts.GenCode(sb);
            cg.emit(sb, "L{0}:", elseLabel);
            if (ElseStmts != null)
            {
                ElseStmts.GenCode(sb);
            }
        }
    }

    public class WhileStatement : Statement
	{
		// by Nathan
		private Expression Cond;
		private Statement Statements;

		public WhileStatement(Expression Cond, Statement Statements)
		{
			this.Cond = Cond;
			this.Statements = Statements;
		}

		public override bool ResolveNames(LexicalScope scope)
		{
            // 1. create new scope
            var newScope = getNewScope(scope, null);

            // 2. resolve names in while condition and statement(s)
			return Cond.ResolveNames(newScope) & Statements.ResolveNames(newScope);
		}
		public override void TypeCheck()
		{
            this.Cond.TypeCheck();

            if (!Cond.type.isTheSameAs(new NamedType("BOOLEAN")))
            {
                System.Console.WriteLine("Type error in WhileStatement\n");
                throw new Exception("TypeCheck error");
            }

            Statements.TypeCheck();
        }
        public override void GenCode(StringBuilder sb)
        {
            int codeLabel, testLabel, finalLabel;

            codeLabel = LastLabel++;
            testLabel = LastLabel++;
            finalLabel = LastLabel++;

            cg.emit(sb, "\tbr.s\tL{0}\n", testLabel);
            cg.emit(sb, "L{0}:", codeLabel);    //removed \n since we don't need it - by Adon
            Statements.GenCode(sb);
            cg.emit(sb, "L{0}:", testLabel);    //removed \n since we don't need it - by Adon
            Cond.GenCode(sb);
            cg.emit(sb, "L{0}:", finalLabel);
            cg.emit(sb, "\tbrtrue.s\tL{0}\n", codeLabel);
        }

    }

    public class SwitchStatement : Statement
    {
        // by Tri
        private Expression expression;
        private Statement block;

        public SwitchStatement(Expression expression, Statement block)
        {
            this.expression = expression;
            this.block = block;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            var newScope = getNewScope(scope, null);
            return expression.ResolveNames(newScope);
        }

        public override void TypeCheck()
        {
            this.expression.TypeCheck();

            if (!expression.type.isTheSameAs(new NamedType("INT")))
            {
                System.Console.WriteLine("Type error in SwitchStatement\n");
                throw new Exception("TypeCheck error");
            }
        }
        public override void GenCode(StringBuilder sb)
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
        public override void GenCode(StringBuilder sb)
        {
               
        }
    }


    public class AssertStatement : Statement
    {
        // by Tri
        private Expression expression1;
        private Expression expression2;

        public AssertStatement(Expression expression1)
        {
            this.expression1 = expression1;
        }

        public AssertStatement(Expression expression1, Expression expression2)
        {
            this.expression1 = expression1;
            this.expression2 = expression2;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            var newScope = getNewScope(scope, null);
            bool value = expression1.ResolveNames(newScope);
            if (expression2 != null)
            {
                return value & expression2.ResolveNames(newScope);
            }
            return value;
        }

        public override void TypeCheck()
        {
            this.expression1.TypeCheck();

            if (!expression1.type.isTheSameAs(new NamedType("BOOLEAN")))
            {
                System.Console.WriteLine("Type error in AssertStatement\n");
                throw new Exception("TypeCheck error");
            }

            if (expression2 != null)
            {
                this.expression2.TypeCheck();
                if (expression2.type.isTheSameAs(new NamedType("VOID")))
                {
                    System.Console.WriteLine("Type error in AssertStatement\n");
                    throw new Exception("TypeCheck error");
                }
            }
        }
        public override void GenCode(StringBuilder sb)
        {

        }
    }

    public class LabeledStatement : Statement
    {
      //by Vivian
        private string Name;
        private Statement Statements;

        public LabeledStatement(string Name, Statement Statements)
        {
            this.Name = Name;
            this.Statements = Statements;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return Statements.ResolveNames(scope);
        }

        public override void TypeCheck()
        {
            Statements.TypeCheck();
        }
        public override void GenCode(StringBuilder sb)
        {

        }
    }


    public class BreakStatement : Statement
    {
        //by Vivian
        private String Name;

        public BreakStatement(String Name)
        {
            this.Name = Name;
        }
        public BreakStatement()
        {
        }
        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }
        public override void TypeCheck()
        {
            //doesnt matter
        }
        public override void GenCode(StringBuilder sb)
        {

            cg.emit(sb, "\tbr.s\tL{0}\n", LastLabel-1);    //test

        }
    }

    public class ContinueStatement : Statement
    {
        //by Vivian
        private string Name;

        public ContinueStatement(String Name)
        {
            this.Name = Name;
        }
        public ContinueStatement()
        {
        }
        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }
        public override void TypeCheck()
        {
        }
        public override void GenCode(StringBuilder sb)
        {

        }
    }

    public class ReturnStatement : Statement
    {
        //by Vivian
        private Expression Expr;

        public ReturnStatement(Expression Expr)
        {
            this.Expr = Expr;
        }
        public ReturnStatement()
        {
        }
        public override bool ResolveNames(LexicalScope scope)
        {
            return Expr.ResolveNames(scope);
        }
        public override void TypeCheck()
        {
            Expr.TypeCheck();
        }
        public override void GenCode(StringBuilder sb)
        {

            Expr.GenCode(sb);

        }
    }

    public class DoStatement : Statement
    {
        // by Tri
        private Expression expression;
        private Statement statement;

        public DoStatement(Statement statement, Expression expression)
        {
            this.statement = statement;
            this.expression = expression;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            var newScope = getNewScope(scope, null);
            return expression.ResolveNames(newScope) & statement.ResolveNames(newScope);
        }

        public override void TypeCheck()
        {
            this.expression.TypeCheck();

            if (!expression.type.isTheSameAs(new NamedType("BOOLEAN")))
            {
                System.Console.WriteLine("Type error in DoStatement\n");
                throw new Exception("TypeCheck error");
            }

            statement.TypeCheck();
        }
        public override void GenCode(StringBuilder sb)
        {

        }
    }

    public class ForStatement : Statement
    {
        // by Nathan - still testing
        private Statement ForInit;
        private Expression TestExpr;
        private Statement ForUpdate;
        private List<Statement> StmtList;

		public ForStatement(Statement ForInit, Expression TestExpr, Statement ForUpdate, List<Statement> StmtList)
		{
			this.ForInit = ForInit;
			this.TestExpr = TestExpr;
			this.ForUpdate = ForUpdate;
			this.StmtList = StmtList;
		}
        public override void GenCode(StringBuilder sb)
        {

        }

        public override bool ResolveNames(LexicalScope scope)
		{
			bool loopResolve = true;

			foreach (Statement each in StmtList)
			{
				loopResolve = loopResolve & each.ResolveNames(scope);
			}

			return ForInit.ResolveNames(scope) & TestExpr.ResolveNames(scope) & ForUpdate.ResolveNames(scope) & loopResolve;
		}

		public override void TypeCheck()
		{
            ForInit.TypeCheck();
            ForUpdate.TypeCheck();
            StmtList.ForEach(x => x.TypeCheck());

            this.TestExpr.TypeCheck();
            try
            {
                if (!TestExpr.type.Equals(new NamedType("BOOLEAN")))
                {
                    Console.WriteLine("Invalid type for if statement condition\n");
                }
            }
            catch (Exception e)
            {
                throw new Exception("TypeCheck error: {0}", e);
            }

        }
	}

    /*
     * This TryStatement is not fully functional, be aware for using it - Adon
    */
    public class TryStatement : Statement
    {
        private Statement TryStmts, CatchStmts, FinallyStmts;

        public TryStatement(Statement tryStatements, Statement CatchStmts, Statement FinallyStmts)
        {
            this.TryStmts = tryStatements;
            this.CatchStmts = CatchStmts;
            this.FinallyStmts = FinallyStmts;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            bool loopResolve = TryStmts.ResolveNames(scope);
            if (CatchStmts != null)
                loopResolve = loopResolve & CatchStmts.ResolveNames(scope);
            if (FinallyStmts != null)
                loopResolve = loopResolve & FinallyStmts.ResolveNames(scope);
            return loopResolve;
        }

        public override void TypeCheck()
        {
            TryStmts.TypeCheck();
            if (CatchStmts != null)
                CatchStmts.TypeCheck();
            if (FinallyStmts != null)
                FinallyStmts.TypeCheck();
        }
        public override void GenCode(StringBuilder sb)
        {
            TryStmts.GenCode(sb);
            if (FinallyStmts != null)
                FinallyStmts.GenCode(sb);
            if (FinallyStmts != null)
                FinallyStmts.GenCode(sb);
        }

    }
    public class ThrowStatement : Statement              //KoJo
    {
        private Expression Expr;

        public ThrowStatement(Expression Expr)
        {
            this.Expr = Expr;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            bool loopResolve = true;

            return Expr.ResolveNames(scope) & loopResolve;
        }
        public override void TypeCheck()
        {
            // Khoa
            // If Expression was entered, try TypeChecking. If not, return error
            // Need to figure out how to check if Expression is Reference Type
            try
            {
                if (Expr != null)
                {
                    Expr.TypeCheck();
                }
            }
            catch (Exception e)
            {
                throw new Exception("No Expression was entered: {0}", e);
            }
        }
        public override void GenCode(StringBuilder sb)
        {

        }
    }

    public class SynchronizedStatement : Statement    //KoJo
    {
        private Expression Expr;
        private Statement Stmt;
        public SynchronizedStatement(Expression Expr, Statement Stmt)
        {
            this.Expr = Expr;
            this.Stmt = Stmt;
        }
        public override bool ResolveNames(LexicalScope scope)
        {
            bool loopResolve = true;

            return Expr.ResolveNames(scope) & Stmt.ResolveNames(scope) & loopResolve;
        }

        public override void TypeCheck()
        {
            // Khoa  
            //The Expression must always be there, where the Statement doesn't have to
            // If Expression is null, skip TypeChecking for Statement
            try
            {
                if (Expr != null)
                {
                    Expr.TypeCheck();
                    Stmt.TypeCheck();
                }
            }
            catch (Exception e)
            {
                throw new NullReferenceException("No Expression was entered: {0}", e);
            }
        }
        public override void GenCode(StringBuilder sb)
        {

        }
    }

    public class ExpressionStatement : Statement
	{
		private Expression expr;

		public ExpressionStatement(Expression expr)
		{
			this.expr = expr;
		}

		public override bool ResolveNames(LexicalScope scope)
		{
			return expr.ResolveNames(scope);
		}
		public override void TypeCheck()
		{
            this.expr.TypeCheck();
            /*try
            {
                if (!expr.type.Equals(new NamedType("BOOLEAN")))
                {
                    Console.WriteLine("Invalid type for if statement condition\n");
                }
            }
            catch (Exception e)
            {
                throw new Exception("TypeCheck error");
            }*/
        }

        public override void GenCode(StringBuilder sb)
        {
            expr.GenCode(sb);
            if (!expr.ObtainType().isTheSameAs(new NamedType("VOID")))
                cg.emit(sb, "\tpop\n");
        }

    }

    public class VariableDeclarationStatement : Statement
    {
        private Expression varDec;

        public VariableDeclarationStatement(Expression varDec)
        {
            this.varDec = varDec;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return varDec.ResolveNames(scope);
        }
        public override void TypeCheck()
        {
            this.varDec.TypeCheck();
            /*try
            {
                if (!expr.type.Equals(new NamedType("BOOLEAN")))
                {
                    Console.WriteLine("Invalid type for if statement condition\n");
                }
            }
            catch (Exception e)
            {
                throw new Exception("TypeCheck error");
            }*/
        }

        public override void GenCode(StringBuilder sb)
        {
            varDec.GenCode(sb);
        }
    }
}