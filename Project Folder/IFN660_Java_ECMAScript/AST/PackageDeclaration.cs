﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
    public class  PackageDeclarationStatement : Statement
    {
        public override bool ResolveNames(LexicalScope scope)
        {
            return true;
        }
    }
}
