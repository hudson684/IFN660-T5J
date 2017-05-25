using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace IFN660_Java_ECMAScript.AST
{
    public interface MethodDec : Declaration
    {
        bool checkArgTypes(List<Expression> args);
        void setArguments(List<Expression> args);
    }

    public class MethodDeclaration : Statement, MethodDec
	{

		//changed made by Josh to fix incorrect code be Adon.
		private List<Modifier> methodModifiers;
		private String methodIdentifier;
		//private MethodDeclaration methodDeclaration;
		private Type returnType;
		private Statement statementList;
		private List<Expression> args;

		public MethodDeclaration(String methodIdentifier, List<Modifier> methodModifiers, Statement statementList, Type returnType, List<Expression> args)
		{
			this.methodIdentifier = methodIdentifier;
			this.methodModifiers = methodModifiers;
			this.statementList = statementList;
			this.returnType = returnType;
			this.args = args;
		}

        public MethodDeclaration()
        {
        }

        public void AddItemsToSymbolTable(LexicalScope scope)
        {
            scope.Symbol_table.Add(methodIdentifier, this);
        }

		public override Boolean ResolveNames(LexicalScope scope)
		{
            // Step 1: Add method name to current scope
            AddItemsToSymbolTable(scope);

			// Step 2: Create new scope and populate the symbol table
			var newScope = getNewScope(scope, args);

			// Step 3: ResolveNames for each statement
			bool loopResolve = true;

            foreach (Expression each in args)
            {
                loopResolve = each.ResolveNames(newScope);
            }

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

        public void setArguments(List<Expression> args)
        {
            // do nothing
        }

        public override void GenCode(StringBuilder sb)
        {
            cg.emit(sb, ".method static ");
            foreach (var modif in methodModifiers)
                cg.emit(sb, "{0} ", modif.ToString().ToLower());
            returnType.GenCode(sb);
            cg.emit(sb, "{0}", methodIdentifier);
            cg.emit(sb, "(");

            // args do this properly - nathan
            string fp_list = "";
            foreach (Expression each in args)
            {
                FormalParam fp = each as FormalParam;
                if (fp != null)
                {
                    fp_list = fp_list + fp.ObtainType().GetILName() + ' ' + fp.GetName() + ',';
                }
            }
            fp_list = fp_list.TrimEnd(',');// remove last ','
            cg.emit(sb, fp_list + ")");

            cg.emit(sb, "{{\n"); // start of method body
            // If the method is called "main" set it as the program entrypoing
            if (methodIdentifier.ToLower() == "main")
                cg.emit(sb, "\t.entrypoint\n");

            // generate code for the method body statements
            statementList.GenCode(sb);

            cg.emit(sb, "\tret\n");
            cg.emit(sb, "}} {0}",Environment.NewLine); // end of method body
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
                Console.WriteLine("Error: Undeclared method indentifier", name);

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

        public override void GenCode(StringBuilder sb)
        {
            MethodDec methodD = declarationRef as MethodDec;
            if (methodD != null)
            {
                // set argurments
                methodD.setArguments(args);
                Node methodN = methodD as Node;
                if (methodN != null)
                {
                    methodN.GenCode(sb);
                }
            }

        }
    }
}
