using System;
using System.Collections.Generic;

namespace IFN660_Java_ECMAScript.AST
{
    public interface MethodDec : Declaration
    {
        bool checkArgTypes(List<Expression> args);
    }

    public class MethodDeclaration : Statement, MethodDec
	{

		//changed made by Josh to fix incorrect code be Adon.
		private List<Modifier> methodModifiers;
		private String methodIdentifier;
		//private MethodDeclaration methodDeclaration;
		private Type returnType;
		private Statement statementList;
		private List<Statement> args;

		public MethodDeclaration(String methodIdentifier, List<Modifier> methodModifiers, Statement statementList, Type returnType, List<Statement> args)
		{
			this.methodIdentifier = methodIdentifier;
			this.methodModifiers = methodModifiers;
			this.statementList = statementList;
			this.returnType = returnType;
			this.args = args;
		}

        public void AddItemsToSymbolTable(LexicalScope scope)
        {
            scope.Symbol_table.Add(methodIdentifier, this);
        }

		public override Boolean ResolveNames(LexicalScope scope)
		{
			// Step 1: Create new scope and populate the symbol table
			var newScope = getNewScope(scope, args);

			// Step 2: ResolveNames for each statement
			bool loopResolve = true;

            foreach (Statement each in args)
            {
                loopResolve = each.ResolveNames(newScope);
            }

			if (statementList != null)
			{
                loopResolve = statementList.ResolveNames(newScope);
			}

			return loopResolve;
		}

		public override void TypeCheck()
		{
            returnType.TypeCheck();
            statementList.TypeCheck();
            args.ForEach(x => x.TypeCheck());
		}

        public Type ObtainType()
        {
            return returnType;
        }

        public bool checkArgTypes(List<Expression> args)
        {
            bool rval = true;

            for (int i = 0; i < args.Count; i++)
            {
                // issue with 
                //if (args[i].ObtainType().isTheSameAs(this.args[i].))
            }

            return rval;
        }

    }

    public class MethodInvocation : Expression
    {
        private String name;
        private List<Expression> args;
        private Declaration declarationRef;

        public MethodInvocation(String name, List<Expression> args)
        {
            this.name = name;
            this.args = args;
        }

        public override bool ResolveNames(LexicalScope scope)
        {
            bool loopResolve = true;

            if (args != null)
            {
                foreach (Expression argument in args)
                {
                    loopResolve = loopResolve & argument.ResolveNames(scope);
                }
            }

            // check for valid declaration of method...
            if (scope != null)
            {
                declarationRef = scope.Resolve(name);
            }

            if (declarationRef == null)
                Console.WriteLine("Error: Undeclared indentifier", name);

            return (declarationRef != null) & loopResolve;
        }

        public override void TypeCheck()
        {
            // check the type of the arguments
            foreach (Expression argument in args)
            {
                argument.TypeCheck();
            }

            // check the type of the arguments matches what the method expects
            MethodDec decl = declarationRef as MethodDec;
            if (decl != null)
            {
                if (!decl.checkArgTypes(args))
                {
                    // args do match what is expected
                    System.Console.WriteLine("Invalid arguments for method", name);
                    throw new Exception("TypeCheck error");
                }
            }

            // return the type of the method
            type = declarationRef.ObtainType();
        }

        public override Type ObtainType()
        {
            return type;
        }
    }
}
