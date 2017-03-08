﻿using System;

namespace IFN660_Java_ECMAScript
{
    public enum Tokens
    {
        IF = 260,
        ELSE = 261,
        INT = 262,
        BOOL = 263,
        EOF = 264,
        WHILE = 265,
        IDENT = 266,
        GE = 267,
        NUMBER = 268

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
        protected virtual bool yywrap() { return true; }
    }

        class Program
    {
        static void Main(string[] args)
        {
            Scanner scanner = new Scanner(
                new System.IO.FileStream(args[0], System.IO.FileMode.Open));

            Tokens token;
            do
            {
                token = (Tokens)scanner.yylex();
                switch (token)
                {
                    case Tokens.NUMBER:
                        Console.WriteLine("NUMBER ({0})", scanner.yylval.name);
                        break;
                    case Tokens.IDENT:
                        Console.WriteLine("IDENT ({0})", scanner.yylval.name);
                        break;
                    case Tokens.IF:
                        Console.WriteLine("IF");
                        break;
                    case Tokens.ELSE:
                        Console.WriteLine("ELSE");
                        break;
                    case Tokens.INT:
                        Console.WriteLine("INT");
                        break;
                    case Tokens.WHILE:
                        Console.WriteLine("WHILE");
                        break;
                    case Tokens.BOOL:
                        Console.WriteLine("BOOL");
                        break;
                    case Tokens.GE:
                        Console.WriteLine("GE");
                        break;
                    case Tokens.EOF:
                        Console.WriteLine("EOF");
                        break;
                    default:
                        Console.WriteLine("'{0}'", (char) token);
                        break;
                }
            }
            while (token != Tokens.EOF);
            Console.ReadLine();
        }
    }
}
