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
            if(Else == null)
                return Cond.ResolveNames(scope) & Then.ResolveNames(scope);
            else
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
            if (Else != null)
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

    public class TryStatement : Statement
    {
        private Statement tryStatements, catchStatements, finallyStatements;

        public TryStatement(Statement tryStatements, Statement catchStatements, Statement finallyStatements)
        {
            this.tryStatements = tryStatements;
            this.catchStatements = catchStatements;
            this.finallyStatements = finallyStatements;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            bool loopResolve = tryStatements.ResolveNames(scope);
            if (catchStatements != null)
                loopResolve = loopResolve & catchStatements.ResolveNames(scope);
            if (finallyStatements != null)
                loopResolve = loopResolve & finallyStatements.ResolveNames(scope);
            return loopResolve;
        }

        public override void TypeCheck()
        {
            tryStatements.TypeCheck();
            if (catchStatements != null)
                catchStatements.TypeCheck();
            if (finallyStatements != null)
                finallyStatements.TypeCheck();
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
