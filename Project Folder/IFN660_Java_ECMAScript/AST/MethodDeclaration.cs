using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace IFN660_Java_ECMAScript.AST
{
	public class MethodDeclaration : Statement, Declaration
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

			if (statementList != null)
			{
                loopResolve = statementList.ResolveNames(newScope);
			}

			return loopResolve;
		}

        public int GetNumber()
        {
            return 0;
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

        public override void GenCode(StringBuilder sb)
        {
            emit(sb, ".method ");
            foreach (var modif in methodModifiers)
                emit(sb, "{0} ", modif);
            returnType.GenCode(sb);
            emit(sb, "{0}", methodIdentifier);
            emit(sb, "( ");
            statementList.GenCode(sb);
            emit(sb, "{{");
            emit(sb, "}} {0}",Environment.NewLine);
        }

    }
}
