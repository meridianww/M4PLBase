using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestM4PLApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            string strCmdText;
            strCmdText = "/C notepad.exe";
            System.Diagnostics.Process.Start("CMD.exe", strCmdText);
        }
    }
}
