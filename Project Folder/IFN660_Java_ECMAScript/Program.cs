namespace IFN660_Java_ECMAScript.AST
{
    class Program
    {
        static void Main(string[] args)
        {

            //var xExpres = new Exception { }
            Modifier[] mods = { Modifier.PUBLIC, Modifier.STATIC };
            Modifier[] classMods = { Modifier.PUBLIC };
            var method = new MethodDeclaration("Main", mods, "VOID");
            var pro = new ClassDeclaration("Hello World", classMods, method);
            pro.DumpValue(1);
        }
    }
}
