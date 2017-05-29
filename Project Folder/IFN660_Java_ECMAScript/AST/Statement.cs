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
            var newScope = getNewScope(scope, null);

            if (ElseStmts == null)
                return CondExpr.ResolveNames(newScope) & ThenStmts.ResolveNames(newScope);
            else
                return CondExpr.ResolveNames(newScope) & ThenStmts.ResolveNames(newScope) & ElseStmts.ResolveNames(newScope);
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
            int endLabel = 0;
            cg.emit(sb, "\tbrfalse L{0}\n", elseLabel);
            ThenStmts.GenCode(sb);
            if (ElseStmts != null)
            {
                endLabel = LastLabel++;
                cg.emit(sb, "\tbr L{0}\n", endLabel);
            }
            cg.emit(sb, "L{0}:\n", elseLabel);
            if (ElseStmts != null)
            {
                ElseStmts.GenCode(sb);
                cg.emit(sb, "L{0}:\n", endLabel);
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
            cg.emit(sb, "L{0}:\n", codeLabel);
            Statements.GenCode(sb);
            cg.emit(sb, "L{0}:\n", testLabel);
            Cond.GenCode(sb);
            cg.emit(sb, "L{0}:", finalLabel);
            cg.emit(sb, "\tbrtrue.s\tL{0}\n", codeLabel);
        }

    }

    public class SwitchStatement : Statement
    {
        /// <summary>
        /// by Joshua
        /// 
        /// Switch Statement is quite confusing to for future reference it will be useful for there to be coments on it
        /// 
        /// A typical switch statement is seperated into four main parts
        /// Firstly the overarching switch statement that contains everything else
        /// 
        /// in actual code the switch statement part looks like this
        /// 
        /// switch(expression expr){
        /// 
        /// }
        /// 
        /// Inside a swich expression contains switch blocks
        /// These contain labels and block statements in that order
        /// never label, block statement, label
        /// 
        /// In the real code a typical block statement can look like this
        /// case 1:
        /// case 2: int x; x = 2; break;
        /// 
        /// note the empty case 1, that is allowed as there is no block statement after it
        /// 
        /// the final two parts are the label itself and the block statement, as the block statement is not unique to 
        /// the swich statement I won't cover it
        /// 
        /// the case statement is simple
        /// it is just a label following one of three rules:
        ///     either it has a constant value i.e case 42:
        ///     it has a constant name i.e case constX: (note that this case is not implimented in the code)
        ///     finally it is the default value i.e default:
        /// 
        /// A full example of case is as follows
        ///     switch(y){
        ///         //first block
        ///         case 42:
        ///         case 2: int x; x = 2; x = y + 2;
        ///         //second block
        ///         case 3: int z; z = y + 1;
        ///         //final block
        ///         default: int q: q = y + 4;
        ///      }
        ///      
        /// 
        /// 
        /// </summary>

        private Expression expression;
        private List<Statement> block;

        public SwitchStatement(Expression expression, List<Statement> block)
        {
            this.expression = expression;
            this.block = block;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            //note each switch block is a new scope
            var newScope = getNewScope(scope, null);

            bool loopResolve = true;

            if (block != null)
            {
                foreach (Statement each in block)
                {
                    Declaration decl = each as Declaration; // try to cast statement as a declaration
                    if (decl != null)
                    {
                        decl.AddItemsToSymbolTable(scope);
                    }
                    loopResolve = loopResolve & each.ResolveNames(scope);
                }
            }

            return loopResolve && expression.ResolveNames(scope);
        }

        //for type checking of the case labels to work, the type of expression used above needs to be passed down to the switch blocks.

        public override void TypeCheck()
        {
            this.expression.TypeCheck();

            if (!expression.type.isTheSameAs(new NamedType("INT")))
            {
                System.Console.WriteLine("Type error in SwitchStatement\n");
                throw new Exception("TypeCheck error");
            }

            foreach(SwitchBlockGroup Blk in block)
            {
                Blk.setswichExprType(expression.type);
                Blk.TypeCheck();
            }

        }

        /// <summary>
        /// The tricky part of code generation is the fact that the switch statement needs the labels for all of the label statements, 
        /// this means that I need to create them and then pass them to any label in the lower switch blocks.
        /// 
        /// Also note that if there is a default statement then after the switch block the break statement needs to point to that,
        /// otherwise it needs to point to the end of the switch block
        /// 
        /// 
        /// the one issue I forsee is that in complicated switch statements the labels might get out of order
        /// 
        /// 
        /// </summary>
        /// <param name="sb"></param>
        public override void GenCode(StringBuilder sb)
        {


            cg.emit(sb, "\tswitch \t (");
            int labelLabel;
            bool firstItem = true;
            bool hasDefault = false;
            int defaultLabel = 0;

            foreach (Statement each in block)
            {
                if (each is SwitchBlockGroup)
                {
                    SwitchBlockGroup blocks = each as SwitchBlockGroup;
                    


                    foreach (var item in blocks.getlabels())
                    {
                        labelLabel = LastLabel++;
                        SwitchLabelStatement lab = item as SwitchLabelStatement;
                        if (!lab.getSwitchLabelNotDefault())
                        {
                            hasDefault = true;
                            defaultLabel = labelLabel;
                           
                        } else
                        {
                            
                            if (!firstItem)
                            {
                                cg.emit(sb, ",");
                            }
                            else
                            {
                                firstItem = false;
                            }
                            cg.emit(sb, "L{0}", labelLabel);

                        }
                        lab.switchLabelLabelSet(labelLabel);
                    }
                }           
            }
            cg.emit(sb, ")\n");

            int finalLabel = LastLabel++;
            if (hasDefault)
            {
                cg.emit(sb, "\tbr.s L{0}\n", defaultLabel);
            } else
            {
                cg.emit(sb, "\tbr.s L{0}\n", finalLabel);
            }


            foreach(Statement sta in block)
            {
                sta.GenCode(sb);
            }

            cg.emit(sb, "L{0}", finalLabel);

        }
    }

    public class SwitchBlockGroup: Statement
    {
        private List<Statement> labels;
        private List<Statement> statements;

        private Type swichExprType;

        public SwitchBlockGroup(List<Statement> labels, List<Statement> statements)
        {
            this.labels = labels;
            this.statements = statements;
        }

        public List<Statement> getlabels()
        {
            return labels;
        }

        public void setswichExprType(Type type)
        {
            swichExprType = type;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            // Step 2: ResolveNames for each part of the complilation unit
            bool loopResolve = true;

            if (statements != null)
            {
                foreach (Statement each in statements)
                {
                    Declaration decl = each as Declaration; // try to cast statement as a declaration
                    if (decl != null)
                    {
                        decl.AddItemsToSymbolTable(scope);
                    }
                    loopResolve = loopResolve & each.ResolveNames(scope);
                }
            }

            return loopResolve;
        }

        public override void TypeCheck()
        {
            foreach (SwitchLabelStatement lab in labels)
            {
                lab.setswichExprType(swichExprType);
                lab.TypeCheck();
            }

            foreach (Statement stmt in statements)
            {
                stmt.TypeCheck();
            }
        }
        public override void GenCode(StringBuilder sb)
        {
            foreach(Statement lab in labels)
            {
                lab.GenCode(sb);
            }

            foreach (Statement stmt in statements)
            {
                stmt.GenCode(sb);
            }
        }
    }


    public class SwitchLabelStatement : Statement
    {
        private Expression SwitchValue;
        private Boolean SwitchLabelNotDefault;
        private Type swichExprType;

        private int switchLabelLabel = 0;


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

        public void switchLabelLabelSet(int lab)
        {
            switchLabelLabel = lab;
        }

        public void setswichExprType(Type type)
        {
            swichExprType = type;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }
        public override void TypeCheck()
        {
            if (SwitchValue != null)
            {
                SwitchValue.TypeCheck();
                if (!SwitchValue.type.isTheSameAs(swichExprType))
                {
                    System.Console.WriteLine("Type error in DoStatement\n");
                    throw new Exception("TypeCheck error");
                }
            }
     
        }
        public override void GenCode(StringBuilder sb)
        {
            cg.emit(sb, "L{0}", switchLabelLabel);
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
            var newScope = getNewScope(scope, null);
            bool loopResolve = TryStmts.ResolveNames(newScope);
            if (CatchStmts != null)
                loopResolve = loopResolve & CatchStmts.ResolveNames(newScope);
            if (FinallyStmts != null)
                loopResolve = loopResolve & FinallyStmts.ResolveNames(newScope);
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
            cg.emit(sb, "\t.try\n");
            cg.emit(sb, "\t{{\n");
            int tryLabel = LastLabel++;
            if (CatchStmts != null && FinallyStmts != null)
            {
                int tryLabel2 = LastLabel++;
                cg.emit(sb, "\t.try\n");
                cg.emit(sb, "\t{{\n");
                TryStmts.GenCode(sb);
                cg.emit(sb, "\tleave.s\tL{0}\n", tryLabel2);
                cg.emit(sb, "\t}}\n");
                cg.emit(sb, "\tcatch [mscorlib]System.Object \n");
                cg.emit(sb, "\t{{\n");
                CatchStmts.GenCode(sb);
                cg.emit(sb, "\tleave.s\tL{0}\n", tryLabel2);
                cg.emit(sb, "\t}}\n");
                cg.emit(sb, "L{0}:\n", tryLabel2);
            }
            else
            {
                TryStmts.GenCode(sb);
            }
            cg.emit(sb, "\tleave.s\tL{0}\n", tryLabel);
            cg.emit(sb, "\t}}\n");

            if (FinallyStmts != null)
            {
                cg.emit(sb, "\tfinally\n");
                cg.emit(sb, "\t{{\n");
                FinallyStmts.GenCode(sb);
                cg.emit(sb, "\tendfinally\n");
                cg.emit(sb, "\t}}\n");
            }
            else
            {
                cg.emit(sb, "\tcatch [mscorlib]System.Object \n");
                cg.emit(sb, "\t{{\n");
                CatchStmts.GenCode(sb);
                cg.emit(sb, "\tleave.s\tL{0}\n", tryLabel);
                cg.emit(sb, "\t}}\n");
            }
            cg.emit(sb, "L{0}:\n", tryLabel);
        }

    }
    public class ThrowStatement : Statement              //KoJo
    {
        // ThrowStatement only take a very unique type of Expression
        // which is the UnqualifiedClassInstanceCreationExpression
        // where a new unchecked exception class is instantiated
        // Eventually Expression will be changed to UnqualifiedClassInstanceCreationExpression
        private Expression Expr;
        private List<string> SystemExceptions = new List<string>();  // list of all System Exceptions
        // This is the case when ThrowStatement exists inside a TryStatement. For Example:
        // Try
        //{}
        //Catch 
        //{Throw}
        // This is the only case where Throw can be followed by null 
        public ThrowStatement()
        {

        }
        public ThrowStatement(Expression Expr)
        {
            this.Expr = Expr;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            // If Expr = null, then ThrowStatement must be inside a TryStatement
            // Check if there is a presence of Try & Catch anywhere in LexicalScope
            // If yes, truen
            if (Expr == null)
            {
                if (scope.Resolve("try") != null && scope.Resolve("catch") != null)
                {
                    return true;
                }
                else
                {
                    throw new Exception("A throw statement with no arguments is only allowed inside a Try-Catch!");
                }
            }
            // If Expre != null, then proceed to typechecking
            // As Expression in TryStatement doesn't have to be declared anywhere in the current scope
            // They only need to be an inheritance of the Exception class 
            else
            {
                return true;
            }
        }
        public override void TypeCheck()
        {
            // Khoa
            // Assuming that if Expr = null, it already passed ResolveName()
            if (Expr == null)
            {
                Expr.TypeCheck();
            }
            else // When Expr != null
            {
                // first check if the identifier is any of the System Exceptions

            }
        }
        public override void GenCode(StringBuilder sb)
        {
            // Put a simplest throw here, at least it throws... - Adon
            cg.emit(sb, "\tnewobj instance void [mscorlib]System.Exception::.ctor()\n");
            cg.emit(sb, "\tthrow\n");
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