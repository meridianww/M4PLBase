using M4PL.Web.Tests.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Assert = NUnit.Framework.Assert;


namespace M4PL.Web.Tests.Contact
{       [TestClass]
    public class ValidateErrorMessage
    {
        
       
            ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
           LoginTest login = new LoginTest();
            [TestMethod]
            public void Run()
            {
              LoginTest.loginToApplication("diksha", "12345", _chromeDriver);
              ContactTest con = new ContactTest();
              con.Invalid("","","",_chromeDriver); 
            }


        
    }
    
}
