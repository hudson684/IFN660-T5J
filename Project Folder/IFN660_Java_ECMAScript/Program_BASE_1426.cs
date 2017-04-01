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
        #region Keywords
        // An code
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
        INSTANCE_OF = 294,
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
        #endregion

        // INTERGER_LITERALS = 318,
        FloatingPointLiteral = 358,
        DecimalIntegerLiteral = 318,
        HexIntegerLiteral = 319,
        OctalIntegerLiteral = 320,
        BinaryIntegerLiteral = 321,
        ELLIPSIS = 322,
        DOUBLE_COLON = 323,

        #region Operator
        // An code
        EQUAL = 324,
        GREATER_OR_EQUAL = 325,
        LESS_THAN_OR_EQUAL = 326,
        NOT_EQUAL = 327,
        LOGICAL_AND = 328,
        LOGICAL_OR = 329,
        LOGICAL_NOT = 330,
        INCREMENT = 331,
        DECREMENT = 332,
        LEFT_SHIFT = 333,
        SIGNED_RIGHT_SHIFT = 334,
        UNSIGNED_RIGHT_SHIFT = 335,
        ADDITION_ASSIGNMENT = 336,
        SUBTRACTION_ASSIGNMENT = 337,
        MULTIPLICATION_ASSIGNMENT = 338,
        DIVISION_ASSIGNMENT = 339,
        MODULUS_ASSIGNMENT = 340,
        BITWISE_AND_ASSIGNMENT = 341,
        BITWISE_OR_ASSIGNMENT = 342,
        BITWISE_XOR_ASSIGNMENT = 343,
        LEFT_SHIFT_ASSIGNMENT = 344,
        UNSIGNED_RIGHT_SHIFT_ASSIGNMENT = 345,
        SIGNED_RIGHT_SHIFT_ASSIGNMENT = 346,
        ARROW = 347,
        #endregion


        BooleanLiteral = 352,
        NullLiteral = 353,

        //Tri
        CHARACTER_LITERAL = 354,
        STRING_LITERAL = 355,
        OCTAL_ESCAPE = 356,
        ESCAPE_SEQUENCE = 399,

        //3.3 Unicode escapes Vivian
        UNICODE_ESCAPE = 360,
        UNICODE_INPUT_CHAR = 361,
        UNICODE_RAW_INPUT = 362,
        HEXDIGIT = 363,
        UNICODE_MARKER = 357,
    };

    public struct MyValueType
    {
        public int num;
        public string name;
    };

    public abstract class ScanBase
    {
        public MyValueType yylval;

        public abstract int yylex();

        protected virtual bool yywrap()
        {
            return true;
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                using (var input = System.IO.File.OpenRead(args[0]))
                {
                    Scanner scanner = new Scanner(input);
                    #region Tokens
                    Tokens token;
                    do
                    {
                        token = (Tokens)scanner.yylex();
                        switch (token)
                        {
                            case Tokens.NUMBER:
                                Console.WriteLine("NUMBER ({0})", scanner.yylval.num);
                                break;
                            case Tokens.IDENT:
                                Console.WriteLine("IDENT ({0})", scanner.yylval.name);
                                break;
                            case Tokens.WHILE:
                                Console.WriteLine("WHILE");
                                break;
                            case Tokens.GE:
                                Console.WriteLine("GE");
                                break;
                            case Tokens.EOF:
                                Console.WriteLine("EOF");
                                break;
                            #endregion
                            #region Keywords
                            // Code by An
                            case Tokens.ABSTRACT:
                                Console.WriteLine("ABSTRACT");
                                break;
                            case Tokens.ASSERT:
                                Console.WriteLine("ASSERT");
                                break;
                            case Tokens.BOOLEAN:
                                Console.WriteLine("BOOLEAN");
                                break;
                            case Tokens.BREAK:
                                Console.WriteLine("BREAK");
                                break;
                            case Tokens.BYTE:
                                Console.WriteLine("BYTE");
                                break;
                            case Tokens.CASE:
                                Console.WriteLine("CASE");
                                break;
                            case Tokens.CATCH:
                                Console.WriteLine("CATCH");
                                break;
                            case Tokens.CHAR:
                                Console.WriteLine("CHAR");
                                break;
                            case Tokens.CLASS:
                                Console.WriteLine("CLASS");
                                break;
                            case Tokens.CONST:
                                Console.WriteLine("CONST");
                                break;
                            case Tokens.CONTINUE:
                                Console.WriteLine("CONTINUE");
                                break;
                            case Tokens.DEFAULT:
                                Console.WriteLine("DEFAULT");
                                break;
                            case Tokens.DO:
                                Console.WriteLine("DO");
                                break;
                            case Tokens.DOUBLE:
                                Console.WriteLine("DOUBLE");
                                break;
                            case Tokens.ELSE:
                                Console.WriteLine("ELSE");
                                break;
                            case Tokens.ENUM:
                                Console.WriteLine("ENUM");
                                break;
                            case Tokens.EXTENDS:
                                Console.WriteLine("EXTENDS");
                                break;
                            case Tokens.FINAL:
                                Console.WriteLine("FINAL");
                                break;
                            case Tokens.FINALLY:
                                Console.WriteLine("FINALLY");
                                break;
                            case Tokens.FLOAT:
                                Console.WriteLine("FLOAT");
                                break;
                            case Tokens.FOR:
                                Console.WriteLine("FOR");
                                break;
                            case Tokens.GOTO:
                                Console.WriteLine("GOTO");
                                break;
                            case Tokens.IF:
                                Console.WriteLine("IF");
                                break;
                            case Tokens.IMPLEMENTS:
                                Console.WriteLine("IMPLEMENTS");
                                break;
                            case Tokens.IMPORT:
                                Console.WriteLine("IMPORT");
                                break;
                            case Tokens.INSTANCE_OF:
                                Console.WriteLine("INSTANCEOF");
                                break;
                            case Tokens.INT:
                                Console.WriteLine("INT");
                                break;
                            case Tokens.INTERFACE:
                                Console.WriteLine("INTERFACE");
                                break;
                            case Tokens.LONG:
                                Console.WriteLine("LONG");
                                break;
                            case Tokens.NATIVE:
                                Console.WriteLine("NATIVE");
                                break;
                            case Tokens.NEW:
                                Console.WriteLine("NEW");
                                break;
                            case Tokens.PACKAGE:
                                Console.WriteLine("PACKAGE");
                                break;
                            case Tokens.PRIVATE:
                                Console.WriteLine("PRIVATE");
                                break;
                            case Tokens.PROTECTED:
                                Console.WriteLine("PROTECTED");
                                break;
                            case Tokens.PUBLIC:
                                Console.WriteLine("PUBLIC");
                                break;
                            case Tokens.RETURN:
                                Console.WriteLine("RETURN");
                                break;
                            case Tokens.SHORT:
                                Console.WriteLine("SHORT");
                                break;
                            case Tokens.STATIC:
                                Console.WriteLine("STATIC");
                                break;
                            case Tokens.STRICTFP:
                                Console.WriteLine("STRICTFP");
                                break;
                            case Tokens.SUPER:
                                Console.WriteLine("SUPER");
                                break;
                            case Tokens.SWITCH:
                                Console.WriteLine("SWITCH");
                                break;
                            case Tokens.SYNCHRONIZED:
                                Console.WriteLine("SYNCHRONIZED");
                                break;
                            case Tokens.THIS:
                                Console.WriteLine("THIS");
                                break;
                            case Tokens.THROW:
                                Console.WriteLine("THROW");
                                break;
                            case Tokens.THROWS:
                                Console.WriteLine("THROWS");
                                break;
                            case Tokens.TRANSIENT:
                                Console.WriteLine("TRANSIENT");
                                break;
                            case Tokens.TRY:
                                Console.WriteLine("TRY");
                                break;
                            case Tokens.VOID:
                                Console.WriteLine("VOID");
                                break;
                            case Tokens.VOLATILE:
                                Console.WriteLine("VOLATILE");
                                break;
                            #endregion
                            #region Literals
                            // Code by Nathan & Sneha
                            case Tokens.DecimalIntegerLiteral:
                                Console.WriteLine("DecimalIntegerLiteral ({0})", scanner.yylval.name);
                                break;
                            case Tokens.HexIntegerLiteral:
                                Console.WriteLine("HexIntegerLiteral ({0})", scanner.yylval.name);
                                break;
                            case Tokens.OctalIntegerLiteral:
                                Console.WriteLine("OctalIntegerLiteral ({0})", scanner.yylval.name);
                                break;
                            case Tokens.BinaryIntegerLiteral:
                                Console.WriteLine("BinaryIntegerLiteral ({0})", scanner.yylval.name);
                                break;
                            // Code by Adon
                            case Tokens.FloatingPointLiteral:
                                Console.WriteLine("FloatingPointLiteral ({0})", scanner.yylval.name);
                                break;
                            //Code by Tri
                            case Tokens.CHARACTER_LITERAL:
                                Console.WriteLine("CharacterLiteral ({0})", scanner.yylval.name);
                                break;
                            case Tokens.STRING_LITERAL:
                                Console.WriteLine("StringLiteral ({0})", scanner.yylval.name);
                                break;
                            case Tokens.OCTAL_ESCAPE:
                                Console.WriteLine("OctalEscape ({0})", scanner.yylval.name);
                                break;
                            case Tokens.ESCAPE_SEQUENCE:
                                Console.WriteLine("EscapeSequence ({0})", scanner.yylval.name);
                                break;
                            // Code by Vivian
                            case Tokens.BooleanLiteral:
                             	Console.WriteLine ("Boolean Literal ({0})", scanner.yylval.name);
                             	break;

                            // Code by Josh
                            case Tokens.NullLiteral:
                             	Console.WriteLine ("Null Literal");
                             	break;
                            #endregion
                            #region Operators
                            // Code by An
                            case Tokens.ELLIPSIS:
                                Console.WriteLine("ELLIPSIS");
                                break;
                            case Tokens.DOUBLE_COLON:
                                Console.WriteLine("DOUBLE_COLON");
                                break;
                            case Tokens.EQUAL:
                                Console.WriteLine("EQUAL");
                                break;
                            case Tokens.GREATER_OR_EQUAL:
                                Console.WriteLine("GREATER_OR_EQUAL");
                                break;
                            case Tokens.LESS_THAN_OR_EQUAL:
                                Console.WriteLine("LESS_THAN_OR_EQUAL");
                                break;
                            case Tokens.NOT_EQUAL:
                                Console.WriteLine("NOT_EQUAL");
                                break;
                            case Tokens.ARROW:
                                Console.WriteLine("ARROW");
                                break;
                            case Tokens.LOGICAL_AND:
                                Console.WriteLine("LOGICAL_AND");
                                break;
                            case Tokens.LOGICAL_OR:
                                Console.WriteLine("LOGICAL_OR");
                                break;
                            case Tokens.LOGICAL_NOT:
                                Console.WriteLine("LOGICAL_NOT");
                                break;
                            case Tokens.INCREMENT:
                                Console.WriteLine("INCREMENT");
                                break;
                            case Tokens.DECREMENT:
                                Console.WriteLine("DECREMENT");
                                break;
                            case Tokens.LEFT_SHIFT:
                                Console.WriteLine("LEFT_SHIFT");
                                break;
                            case Tokens.SIGNED_RIGHT_SHIFT:
                                Console.WriteLine("SIGNED_RIGHT_SHIFT");
                                break;
                            case Tokens.UNSIGNED_RIGHT_SHIFT:
                                Console.WriteLine("UNSIGNED_RIGHT_SHIFT");
                                break;
                            case Tokens.ADDITION_ASSIGNMENT:
                                Console.WriteLine("ADDITION_ASSIGNMENT");
                                break;
                            case Tokens.SUBTRACTION_ASSIGNMENT:
                                Console.WriteLine("SUBTRACTION_ASSIGNMENT");
                                break;
                            case Tokens.MULTIPLICATION_ASSIGNMENT:
                                Console.WriteLine("MULTIPLICATION_ASSIGNMENT");
                                break;
                            case Tokens.DIVISION_ASSIGNMENT:
                                Console.WriteLine("DIVISION_ASSIGNMENT");
                                break;
                            case Tokens.MODULUS_ASSIGNMENT:
                                Console.WriteLine("MODULUS_ASSIGNMENT");
                                break;
                            case Tokens.BITWISE_AND_ASSIGNMENT:
                                Console.WriteLine("BITWISE_AND_ASSIGNMENT");
                                break;
                            case Tokens.BITWISE_OR_ASSIGNMENT:
                                Console.WriteLine("BITWISE_OR_ASSIGNMENT");
                                break;
                            case Tokens.BITWISE_XOR_ASSIGNMENT:
                                Console.WriteLine("BITWISE_XOR_ASSIGNMENT");
                                break;
                            case Tokens.LEFT_SHIFT_ASSIGNMENT:
                                Console.WriteLine("LEFT_SHIFT_ASSIGNMENT");
                                break;
                            case Tokens.UNSIGNED_RIGHT_SHIFT_ASSIGNMENT:
                                Console.WriteLine("UNSIGNED_RIGHT_SHIFT_ASSIGNMENT");
                                break;
                            case Tokens.SIGNED_RIGHT_SHIFT_ASSIGNMENT:
                                Console.WriteLine("SIGNED_RIGHT_SHIFT_ASSIGNMENT");
                                break;
                            #endregion


                            #region Unicode Escapes
                            //Unicode Escapes by Joshua Hudson and Vivan Lee
                            case Tokens.UNICODE_ESCAPE:
                                Console.WriteLine("UNICODE ESCAPE");
                                break;
                           case Tokens.UNICODE_INPUT_CHAR:
                                Console.WriteLine("UNICODE INPUT CHAR");
                                break;

                            case Tokens.UNICODE_RAW_INPUT:
                                Console.WriteLine("UNICODE RAW INPUT");
                                break;
                            case Tokens.HEXDIGIT:
                                Console.WriteLine("HEXDIGIT");
                                break;
                            case Tokens.UNICODE_MARKER:
                                Console.WriteLine("UNICODE MARKER");
                                break;
                            #endregion
                            default:
                                Console.WriteLine("'{0}'", token);
                                break;

                        }
                    } while (token != Tokens.EOF);
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }


            Console.Read();
        }
    }
}