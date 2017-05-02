﻿using System;
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
			bool resolved = true;

			if (statementList != null)
			{
                resolved = statementList.ResolveNames(newScope);
			}

			return resolved;
		}
		public override Boolean TypeCheck()
		{
			return true;
		}

	}
}
