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
            emit(sb, ".method static ");
            foreach (var modif in methodModifiers)
                emit(sb, "{0} ", modif.ToString().ToLower());
            returnType.GenCode(sb);
            emit(sb, "{0}", methodIdentifier);
            emit(sb, "(");

            // args do this properly - nathan
            string fp_list = "";
            foreach (Statement each in args)
            {
                FormalParam fp = each as FormalParam;
                if (fp != null)
                {
                    fp_list = fp_list + fp.ObtainType().GetILName() + ' ' + fp.GetName() + ',';
                }
            }
            fp_list = fp_list.TrimEnd(',');


            //emit(sb, "string[] args");

            emit(sb, fp_list + ")");

            emit(sb, "{{\n");
            // manually put in entry point
            emit(sb, "\t.entrypoint\n");

            // locals - do this properly - nathan
            //emit(sb, "\t.locals init (int32 x, int32 y)\n");

            statementList.GenCode(sb);

            // manually add WriteLine of variable 1
            // this will be done properly with System.out.println is implemented - nathan
            emit(sb, "\tldloc.1\n");
            emit(sb, "\tcall\tvoid [mscorlib]System.Console::WriteLine(int32)\n");

            emit(sb, "\tret\n");
            emit(sb, "}} {0}",Environment.NewLine);
        }

    }
}
