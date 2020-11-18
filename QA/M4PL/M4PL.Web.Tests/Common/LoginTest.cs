using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.IO;
using System.Threading;

namespace M4PL.Web.Tests.Common
{
    [TestClass]
    public class LoginTest
    {
        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        // LoginTest login = new LoginTest();
        [TestMethod]
        public void Run()
        {
            loginToApplication("diksha", "12345", _chromeDriver);
            //InvalidLogin("diksha", "",_chromeDriver);
        }



        public static void LogoutRun(ChromeDriver chromeDriver)
        {

            logoutToApplication(chromeDriver);
        }



        public static void loginToApplication(string UserName, string Password, ChromeDriver driver)
        {

            driver.Navigate().GoToUrl("http://172.30.255.53:2453/");
            driver.Manage().Window.Maximize();
            driver.FindElementById(Login.Email_Id).SendKeys(UserName);
            driver.FindElementById(Login.Password_Field).SendKeys(Password);
            driver.FindElementById(Login.Login_Btn).Click();
            String expectedText = "Welcome, Diksha";
            Assert.AreEqual("Welcome, Diksha", expectedText);
        }

        public static void InvalidLogin(string userName, string password, ChromeDriver driver)
        {
            driver.Navigate().GoToUrl("http://172.30.244.22:2453/");
            Thread.Sleep(1000);
            driver.Manage().Window.Maximize();
            driver.FindElementById(Login.Email_Id).SendKeys(userName);
            Thread.Sleep(2000);
            driver.FindElementById(Login.Password_Field).SendKeys(password);
            Thread.Sleep(2000);
            driver.FindElementById(Login.Login_Btn).Click();
            Thread.Sleep(6000);
            if (!string.IsNullOrWhiteSpace(userName) && !string.IsNullOrWhiteSpace(password))
            {
                string expectedTxt = "   Account does not exist ";
                Assert.AreEqual("   Account does not exist ", expectedTxt);
            }
            else
            {
                string invalidtxt = "   User name or password incorrect ";
                Assert.AreEqual("   User name or password incorrect ", invalidtxt);
            }

         }

        public static void logoutToApplication(ChromeDriver driver)
        {
            driver.FindElementById(LoginXPath.Arrow_Btn).Click();
            driver.FindElementById(LoginXPath.Logout_Btn).Click();
            Thread.Sleep(2000);

        }

    }
}
