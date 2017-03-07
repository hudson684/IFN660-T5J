using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GPLexTutorial
{
    public enum Tokens
    {
        NUMBER = 258,
        IDENT = 259,
        IF = 260,
        ELSE = 261,
        INT = 262,
        BOOL = 263,
        EOF = 264
    };


    public abstract class ScanBase
    {
        public abstract int yylex();
        protected virtual bool yywrap() { return true; }
    }


    class Program
    {
        static void Main(string[] args)
        {
            Scanner scanner = new Scanner(Console.OpenStandardInput());
            Tokens token;
            do
            {
                token = (Tokens)scanner.yylex();
                Console.WriteLine("token {0}", token);
            }
            while (token != Tokens.EOF);
        }
    }
}

