using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
 
    public class ClassDeclaration: Node
    {
        private Modifer[] classModifiers;
        private String className;
        

        public ClassDeclaration(String className, Modifer[] classModifiers)
        {
            this.className = className;
            this.classModifiers = classModifiers;
        }


    }
}
