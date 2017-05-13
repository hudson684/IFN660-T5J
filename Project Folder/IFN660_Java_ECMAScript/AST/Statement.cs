using System.Collections.Generic;
using System;

namespace IFN660_Java_ECMAScript.AST
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

		public override bool ResolveNames(LexicalScope scope)
		{
			return Cond.ResolveNames(scope) & Then.ResolveNames(scope) & Else.ResolveNames(scope);
		}

		public override void TypeCheck()
		{
			this.Cond.TypeCheck();
			try
			{
				if (!Cond.type.Equals(new NamedType("BOOLEAN")))
				{
					Console.WriteLine("Invalid type for if statement condition\n");
				}
			}
			catch (Exception e)
			{
				throw new Exception("TypeCheck error");
			}
            Then.TypeCheck();
            Else.TypeCheck();
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
                throw new Exception("TypeCheck error");
            }

        }
	}
    public class ThrowStatement : Statement              //KoJo
    {
        // by Nathan - still testing
        private Statement ThrowInit;
        private Expression Expr;

        public ThrowStatement(Statement ThrowInit, Expression Expr)
        {
            this.ThrowInit = ThrowInit;
            this.Expr = Expr;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            bool loopResolve = true;

            return ThrowInit.ResolveNames(scope) & Expr.ResolveNames(scope) & loopResolve;
        }
        public override void TypeCheck()
        {

        }

    }

    public class SynchronizedStatement : Statement
    //KoJo, both this and SwitchStatement have Expression and BlockStatement
    // Need testing on whether they can be megered into 1 
    {
        private Expression Expr;
        private BlockStatement BlckStmt;
        public SynchronizedStatement(Expression Expr, BlockStatement BlckStmt)
        {
            this.Expr = Expr;
            this.BlckStmt = BlckStmt;
        }
        public override bool ResolveNames(LexicalScope scope)
        {
            bool loopResolve = true;

            return Expr.ResolveNames(scope) & BlckStmt.ResolveNames(scope) & loopResolve;
        }

        public override void TypeCheck()
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
            try
            {
                if (!expr.type.Equals(new NamedType("BOOLEAN")))
                {
                    Console.WriteLine("Invalid type for if statement condition\n");
                }
            }
            catch (Exception e)
            {
                throw new Exception("TypeCheck error");
            }
        }

	}


	public class VariableDeclaration : Statement, Declaration
	{
		private Type type;
		private string name;
		public VariableDeclaration(Type type, string name)
		{
			this.type = type;
			this.name = name;
		}

        public void AddItemsToSymbolTable(LexicalScope scope)
        {
            scope.Symbol_table.Add(name, this);
        }

        public override bool ResolveNames(LexicalScope scope)
		{
			return type.ResolveNames(scope);
		}
		public override void TypeCheck()
		{
			
		}

        public Type ObtainType()
        {
            return type;
        }
	}

	public class VariableDeclarationList : Statement, Declaration
	{
		private Type type;
		private List<string> names;

		public VariableDeclarationList(Type type, List<string> names)
		{
			this.type = type;
			this.names = names;
		}


        public void AddItemsToSymbolTable(LexicalScope scope)
        {
            foreach (string each in names)
                scope.Symbol_table.Add(each, this);
        }

        public override bool ResolveNames(LexicalScope scope)
		{
			return type.ResolveNames(scope);
		}

		public override void TypeCheck()
		{
			
		}

        public Type ObtainType()
        {
            return type;
        }
	}
}
