using System.Collections.Generic;

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

        public override bool ResolveNames()
        {
            return Cond.ResolveNames() & Then.ResolveNames() & Else.ResolveNames();
        }
    }

    public class WhileStatement : Statement
    {
        // by Nathan
        private Expression Cond;
        private List<Statement> StmtList;

        public WhileStatement(Expression Cond, List<Statement> StmtList)
        {
            this.Cond = Cond;
            this.StmtList = StmtList;
        }

        public override bool ResolveNames()
        {
            bool loopResolve = true;

            foreach (Statement each in StmtList)
            {
                loopResolve = loopResolve & each.ResolveNames();
            }

            return Cond.ResolveNames() & loopResolve;
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

        public override bool ResolveNames()
        {
            bool loopResolve = true;

            foreach (Statement each in StmtList)
            {
                loopResolve = loopResolve & each.ResolveNames();
            }

            return ForInit.ResolveNames() & TestExpr.ResolveNames() & ForUpdate.ResolveNames() & loopResolve;
        }
    }

    public class ExpressionStatement : Statement
    {
        private Expression expr;

        public ExpressionStatement (Expression expr)
        {
            this.expr = expr;
        }

        public override bool ResolveNames()
        {
            return expr.ResolveNames();
        }
    }

    public class VariableDefinitionStatement : Statement
    {
        private Type VariableType;
        private string VariableName;

        public VariableDefinitionStatement(Type VariableType, string VariableName)
        {
            this.VariableType = VariableType;
            this.VariableName = VariableName;
        }

        public override bool ResolveNames()
        {
            // do something here...
            return true;
        }

    }
    public class VariableDeclaration : Statement
    {
        private Type type;
        private string name;
        public VariableDeclaration(Type type, string name)
        {
            this.type = type;
            this.name = name;
        }
        public override bool ResolveNames()
        {
            // do something here...
            return type.ResolveNames();
        }
    };




}
