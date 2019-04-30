using M4PL.Web.Tests.Organization;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace M4PL.Web.Tests.Common
{
    public static class ImageUpload
    {
        /// <summary> 
        /// Image Upload Function 
        /// </summary>
        /// <param name="driver">Instance for ChromeDriver</param> 
        /// <param name="imagePath">Image Path </param>
        /// <param name="idPath">Path for Image Upload Icon</param>
        public static void FileUpload(ChromeDriver driver, string imagePath, string idPath)

        {
            var button = driver.FindElement(By.Id(imagePath));

            button.Click();
            Thread.Sleep(3000); //simple wait method

            SendKeys.SendWait(@idPath); //this code sends the path to the file upload dialog
            Thread.Sleep(5000);//simple wait method

            SendKeys.SendWait(@"{Enter}"); //simulates pressing enter button 

        }

    }
}
