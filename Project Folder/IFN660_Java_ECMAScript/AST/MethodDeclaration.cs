using System;
using System.Collections.Generic;

namespace IFN660_Java_ECMAScript.AST
{
	public class MethodDeclaration : Statement, Declaration
	{

		//changed made by Josh to fix incorrect code be Adon.
		private List<Modifier> methodModifiers;
		private String methodIdentifier;
		//private MethodDeclaration methodDeclaration;
		private Type returnType;
		private List<Statement> statementList;
		private List<Statement> args;

		public MethodDeclaration(String methodIdentifier, List<Modifier> methodModifiers, List<Statement> statementList, Type returnType, List<Statement> args)
		{
			this.methodIdentifier = methodIdentifier;
			this.methodModifiers = methodModifiers;
			this.statementList = statementList;
			this.returnType = returnType;
			this.args = args;
		}

		public List<string> GetName()
		{
			return new List<string> { methodIdentifier };
		}

		public override Boolean ResolveNames(LexicalScope scope)
		{
			// Step 1: Create new scope and populate the symbol table
			var newScope = getNewScope(scope, statementList, args);

			// Step 2: ResolveNames for each statement
			bool loopResolve = true;

			if (statementList != null)
			{
				foreach (Statement each in statementList)
				{
					loopResolve = loopResolve & each.ResolveNames(newScope);
				}
			}

			return loopResolve;
		}
		public override Boolean TypeCheck()
		{
			return true;
		}

        public Type GetType()
        {
            return null;
        }

	}
}
