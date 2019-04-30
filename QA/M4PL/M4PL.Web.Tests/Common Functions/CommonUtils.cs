using OpenQA.Selenium;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;

namespace M4PL.Web.Tests.Common_Functions
{
    public class CommonUtils
    {

        public static void Screenshot(IWebDriver driver)
        {
            String FilePathAndName = string.Format("{0}{1}" + "ScreenShot" + "_{2:yyyy-MM-dd_hh-mm-ss}.jpeg", (Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())) + @"\ScreenShots", Path.DirectorySeparatorChar, DateTime.Now);
            ITakesScreenshot screenshotDriver = driver as ITakesScreenshot;
            Screenshot screenshot = screenshotDriver.GetScreenshot();
            screenshot.SaveAsFile(FilePathAndName, ScreenshotImageFormat.Png);

        }

        public static void WriteToLog(String error)
        {
            String FilePathAndName = string.Format("{0}{1}" + "TestLog" + "_{2:yyyy-MM-dd_hh-mm-ss}.txt", (Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())) + @"\Logs", Path.DirectorySeparatorChar, DateTime.Now);
            System.IO.File.AppendAllText(FilePathAndName, DateTime.Now.ToString() + Environment.NewLine);
            System.IO.File.AppendAllText(FilePathAndName, "*************************************************************************" + "TestLog" + "**************************************************************************" + Environment.NewLine + error.ToString());

        }
    }
}
