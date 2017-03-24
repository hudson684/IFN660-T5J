using System;
using System.IO;

namespace IFN660_Java_ECMAScript
{
    class Program
    {
        static void Main(string[] args)
        {
            Scanner scanner = new Scanner(
                new FileStream(args[0], FileMode.Open));
            Parser parser = new Parser(scanner);
            parser.Parse();

            Console.Read();
        }
    }
}
