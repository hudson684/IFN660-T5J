using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript
{
	public enum Tokens
	{
		EOF = 264,
		WHILE = 265,
		IDENT = 266,
		GE = 267,
		NUMBER = 268,
		ABSTRACT = 269,
		ASSERT = 270,
		BOOLEAN = 271,
		BREAK = 272,
		BYTE = 273,
		CASE = 274,
		CATCH = 275,
		CHAR = 276,
		CLASS = 277,
		CONST = 278,
		CONTINUE = 279,
		DEFAULT = 280,
		DO = 281,
		DOUBLE = 282,
		ELSE = 283,
		ENUM = 284,
		EXTENDS = 285,
		FINAL = 286,
		FINALLY = 287,
		FLOAT = 288,
		FOR = 289,
		IF = 290,
		GOTO = 291,
		IMPLEMENTS = 292,
		IMPORT = 293,
		INSTANCEOF = 294,
		INT = 295,
		INTERFACE = 296,
		LONG = 297,
		NATIVE = 298,
		NEW = 299,
		PACKAGE = 300,
		PRIVATE = 301,
		PROTECTED = 302,
		PUBLIC = 303,
		RETURN = 304,
		SHORT = 305,
		STATIC = 306,
		STRICTFP = 307,
		SUPER = 308,
		SWITCH = 309,
		SYNCHRONIZED = 310,
		THIS = 311,
		THROW = 312,
		THROWS = 313,
		TRANSIENT = 314,
		TRY = 315,
		VOID = 316,
		VOLATILE = 317,
		INTERGER_LITERALS = 318,
		FLOATING_POINT_LITERALS = 319,
		BOOLEAN_LITERALS = 320,
		NULL_LITERAL = 321,
			
	};

	public struct MyValueType
	{
		public int num;
		public string name;
	};

	public abstract class ScanBase
	{
		public MyValueType yylval;

		public abstract int yylex ();

		protected virtual bool yywrap ()
		{
			return true;
		}
	}

	class Program
	{
		static void Main (string[] args)
		{
			Scanner scanner = new Scanner (
				                  new System.IO.FileStream (args [0], System.IO.FileMode.Open));
			#region Tokens
			Tokens token;
			do {
				token = (Tokens)scanner.yylex ();
				switch (token) {
				case Tokens.NUMBER:
					Console.WriteLine ("NUMBER ({0})", scanner.yylval.num);
					break;
				case Tokens.IDENT:
					Console.WriteLine ("IDENT ({0})", scanner.yylval.name);
					break;
				case Tokens.WHILE:
					Console.WriteLine ("WHILE");
					break;
				case Tokens.GE:
					Console.WriteLine ("GE");
					break;
				case Tokens.EOF:
					Console.WriteLine ("EOF");
					break;
				#region Keywords
				case Tokens.ABSTRACT:
					Console.WriteLine ("ABSTRACT");
					break;
				case Tokens.ASSERT:
					Console.WriteLine ("ASSERT");
					break;
				case Tokens.BOOLEAN:
					Console.WriteLine ("BOOLEAN");
					break;
				case Tokens.BREAK:
					Console.WriteLine ("BREAK");
					break;
				case Tokens.BYTE:
					Console.WriteLine ("BYTE");
					break;
				case Tokens.CASE:
					Console.WriteLine ("CASE");
					break;
				case Tokens.CATCH:
					Console.WriteLine ("CATCH");
					break;
				case Tokens.CHAR:
					Console.WriteLine ("CHAR");
					break;
				case Tokens.CLASS:
					Console.WriteLine ("CLASS");
					break;
				case Tokens.CONST:
					Console.WriteLine ("CONST");
					break;
				case Tokens.CONTINUE:
					Console.WriteLine ("CONTINUE");
					break;
				case Tokens.DEFAULT:
					Console.WriteLine ("DEFAULT");
					break;
				case Tokens.DO:
					Console.WriteLine ("DO");
					break;
				case Tokens.DOUBLE:
					Console.WriteLine ("DOUBLE");
					break;
				case Tokens.ELSE:
					Console.WriteLine ("ELSE");
					break;
				case Tokens.ENUM:
					Console.WriteLine ("ENUM");
					break;
				case Tokens.EXTENDS:
					Console.WriteLine ("EXTENDS");
					break;
				case Tokens.FINAL:
					Console.WriteLine ("FINAL");
					break;
				case Tokens.FINALLY:
					Console.WriteLine ("FINALLY");
					break;
				case Tokens.FLOAT:
					Console.WriteLine ("FLOAT");
					break;
				case Tokens.FOR:
					Console.WriteLine ("FOR");
					break;
				case Tokens.GOTO:
					Console.WriteLine ("GOTO");
					break;
				case Tokens.IF:
					Console.WriteLine ("IF");
					break;
				case Tokens.IMPLEMENTS:
					Console.WriteLine ("IMPLEMENTS");
					break;
				case Tokens.IMPORT:
					Console.WriteLine ("IMPORT");
					break;
				case Tokens.INSTANCEOF:
					Console.WriteLine ("INSTANCEOF");
					break;
				case Tokens.INT:
					Console.WriteLine ("INT");
					break;
				case Tokens.INTERFACE:
					Console.WriteLine ("INTERFACE");
					break;
				case Tokens.LONG:
					Console.WriteLine ("LONG");
					break;
				case Tokens.NATIVE:
					Console.WriteLine ("NATIVE");
					break;
				case Tokens.NEW:
					Console.WriteLine ("NEW");
					break;
				case Tokens.PACKAGE:
					Console.WriteLine ("PACKAGE");
					break;
				case Tokens.PRIVATE:
					Console.WriteLine ("PRIVATE");
					break;
				case Tokens.PROTECTED:
					Console.WriteLine ("PROTECTED");
					break;
				case Tokens.PUBLIC:
					Console.WriteLine ("PUBLIC");
					break;
				case Tokens.RETURN:
					Console.WriteLine ("RETURN");
					break;
				case Tokens.SHORT:
					Console.WriteLine ("SHORT");
					break;
				case Tokens.STATIC:
					Console.WriteLine ("STATIC");
					break;
				case Tokens.STRICTFP:
					Console.WriteLine ("STRICTFP");
					break;
				case Tokens.SUPER:
					Console.WriteLine ("SUPER");
					break;
				case Tokens.SWITCH:
					Console.WriteLine ("SWITCH");
					break;
				case Tokens.SYNCHRONIZED:
					Console.WriteLine ("SYNCHRONIZED");
					break;
				case Tokens.THIS:
					Console.WriteLine ("THIS");
					break;
				case Tokens.THROW:
					Console.WriteLine ("THROW");
					break;
				case Tokens.THROWS:
					Console.WriteLine ("THROWS");
					break;
				case Tokens.TRANSIENT:
					Console.WriteLine ("TRANSIENT");
					break;
				case Tokens.TRY:
					Console.WriteLine ("TRY");
					break;
				case Tokens.VOID:
					Console.WriteLine ("VOID");
					break;
				case Tokens.VOLATILE:
					Console.WriteLine ("VOLATILE");
					break;
				case Tokens.INTERGER_LITERALS:
					Console.WriteLine ("INT");
					break;
				case Tokens.FLOATING_POINT_LITERALS:
					Console.WriteLine ("FLOAT");
					break;
				case Tokens.BOOLEAN_LITERALS:
					Console.WriteLine ("BOOL");
					break;
				case Tokens.NULL_LITERAL:
					Console.WriteLine ("NULL");
					break;
				default:
					Console.WriteLine ("'{0}'", token);
					break;
				#endregion
				}
			} while (token != Tokens.EOF);
			#endregion
		}
	}
}
