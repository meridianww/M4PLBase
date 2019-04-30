using System;
using System.IO;

namespace M4PL.Web.Tests.Utilities
{
    public class ErrorLog
    {
        public static void SaveException(Exception ex)
        {
            string filePath = @"C:\M4PLTest\M4PL.Web.Tests\Utilities\Error.txt";

            using (StreamWriter writer = new StreamWriter(filePath, true))
            {
                writer.WriteLine("Message :" + ex.Message + "<br/>" + Environment.NewLine + "StackTrace :" + ex.StackTrace +
                   "" + Environment.NewLine + "Date :" + DateTime.Now.ToString());
                writer.WriteLine(Environment.NewLine + "-------------------------------" + Environment.NewLine);
            }

        }
    }
}
