using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace IFN660_Java_ECMAScript.AST
{
    public class CodeGen
    {
        /// <summary>
        /// Use Stringbuider to append all the text rather then invoke I/O read/write
        /// </summary>
        /// <param name="sb"> Current StringBuidler object</param>
        /// <param name="fmt">String with format i.e "X = {0}",x</param>
        /// <param name="args">
        /// params allow use to have variable number of parameter
        /// We use object[] so we dont need to think about type
        /// https://msdn.microsoft.com/en-us/library/ms229008(v=vs.100).aspx
        /// </param>
        internal void emit(StringBuilder sb, string fmt, params object[] args)
        {
            sb.AppendFormat(fmt, args);
            //sb.Write(Environment.NewLine);
        }
        public void EmitInt(StringBuilder sb, int i)
        {
            switch (i)
            {
                case -1:
                    emit(sb, "\tldc.i4.m1\n");
                    break;
                case 0:
                    emit(sb, "\tldc.i4.0\n");
                    break;
                case 1:
                    emit(sb, "\tldc.i4.1\n");
                    break;
                case 2:
                    emit(sb, "\tldc.i4.2\n");
                    break;
                case 3:
                    emit(sb, "\tldc.i4.3\n");
                    break;
                case 4:
                    emit(sb, "\tldc.i4.4\n");
                    break;
                case 5:
                    emit(sb, "\tldc.i4.5\n");
                    break;
                case 6:
                    emit(sb, "\tldc.i4.6\n");
                    break;
                case 7:
                    emit(sb, "\tldc.i4.7\n");
                    break;
                case 8:
                    emit(sb, "\tldc.i4.8\n");
                    break;
                default:
                    if (i >= -128 && i <= 127)
                    {
                        emit(sb, "\tldc.i4.s\t{0}\n", (sbyte)i);
                    }
                    else
                        emit(sb, "\tldc.i4\t{0}\n", i);
                       
                    break;
            }
        }
        public void EmitLong(StringBuilder sb, long l)
        {
            if (l >= int.MinValue && l <= int.MaxValue)
            {
                EmitInt(sb, (int)l);
            }
            else
            {
                emit(sb, "\tldc.i8\t{0}\n", l);
            }
        }

        public void EmitFloat(StringBuilder sb, float l)
        {
            emit(sb, "\tldc.r4\t{0}\n", l);
        }

        public void EmitDouble(StringBuilder sb, double l)
        {
            if (l >= float.MinValue && l <= float.MaxValue)
            {
                EmitFloat(sb, (float)l);
            }
            else
            {
                emit(sb, "\tldc.r8\t{0}\n", l);
            }
        }
        public void EmitNull(StringBuilder sb)
        {
            emit(sb, "\tldnull\n");
        }
    }
}
