using M4PL.Web.Tests.Common;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.IO;
using System.Threading;

namespace M4PL.Web.Tests.Customer
{
    [TestClass]
    public class CustomerTest
    {

        ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles");
        LoginTest login = new LoginTest();

        [TestMethod]
        public void Run()
        {

            LoginTest.loginToApplication("diksha", "12345", _chromeDriver);


            Add("CUSEDIT33", "Customer Automated M4PL", "CUSEDIT33", "Diksha", _chromeDriver);

            CustBusinessTermTest.Add("CBT01", "Business Terms Title", _chromeDriver);
            CustFinancialCalendarTest.Add("CFC_01", "Financial Calendar Details", _chromeDriver);
            CustContactTest.Add("CC_01", "Warehouse Manager", "Diksha", _chromeDriver);
            CustDCLocationTest.Add("DC_LOC", "WRMNGR", "Location Assistant Manager", "Tom ", _chromeDriver);
            CustDocReferenceTest.Add("CABC_M4PL", "Customer Document Details", _chromeDriver);

            Edit(_chromeDriver);
            Cancel(_chromeDriver);
            LoginTest.LogoutRun(_chromeDriver);
        }


        public void Add(String Code, String Title, String ToogleFilterSearchedCode, String CorpAddSearch, ChromeDriver driver)
        {

            driver.FindElementByXPath(CustomerXPath.CustomerDataViewScreen).Click();
            Thread.Sleep(3000);
            driver.FindElementById(CustomerXPath.NewRibbonBtn).Click();
            Thread.Sleep(5000);
            driver.FindElementById(CustomerXPath.CusCode).SendKeys(Code);
            driver.FindElementById(CustomerXPath.CusTitle).SendKeys(Title);
            //driver.FindElementByXpath().Click();
            //driver.FindElementByXpath(CusWorkAddress).SendKeys(WorkAddress);
            driver.FindElementById(CustomerXPath.CusSaveRbn).Click();
            Thread.Sleep(5000);
            driver.FindElementByXPath(CustomerXPath.CusSaveOkBtn).Click();
            Thread.Sleep(2000);
            driver.FindElementById(CustomerXPath.CusCancelBtn).Click();
            Thread.Sleep(2000);
            //Opting Toggle Filter to Search Code Details and Edit Customer Details
            driver.FindElementById(CustomerXPath.ToggleFilter).Click();
            Thread.Sleep(4000);
            driver.FindElementById(CustomerXPath.ToggleFilterCode).Click();
            driver.FindElementById(CustomerXPath.ToggleFilterCode).SendKeys(ToogleFilterSearchedCode);
            Thread.Sleep(5000);
            //Right Click on Grid to Opt Edit Option
            OpenQA.Selenium.Interactions.Actions action = new OpenQA.Selenium.Interactions.Actions(driver);
            IWebElement searchBox = driver.FindElement(By.Id(CustomerXPath.SearchedRow));
            action.ContextClick(searchBox).Perform();
            Thread.Sleep(3000);
            driver.FindElementById(CustomerXPath.EditIconRightClick).Click();
            Thread.Sleep(2000);
            //Opting Address Tab from Edit Customer Page
            driver.FindElementByXPath(CustomerXPath.CusAddress).Click();
            Thread.Sleep(5000);
            driver.FindElementById(CustomerXPath.AdrCorp).Click();
            driver.FindElement(By.Id(CustomerXPath.AdrCorp)).SendKeys(CorpAddSearch);
            Thread.Sleep(5000);
            driver.FindElementByXPath("//td[@id='CustCorporateAddressId_DDD_L_LBI0T0']").Click();
            Thread.Sleep(2000);
            //SelectElement CorpAdd = new SelectElement(driver.FindElement(By.XPath("//td[@id='CustCorporateAddressId_DDD_L_LBI0T0']")));
            //CorpAdd.SelectByText("Diksha  Bhargava");
            //  SelectElement dropdown = new SelectElement(driver.FindElement(By.XPath("//input[@id='CustCorporateAddressId_I']")));
            // Thread.Sleep(2000);
            // dropdown.SelectByIndex(1);

        }

        public void Edit(ChromeDriver driver)
        {
            driver.FindElementById(CustomerXPath.CusUpdateBtn).Click();
            Thread.Sleep(3000);
            driver.FindElementById(CustomerXPath.CusUpdateOkBtn).Click();
        }


        public void Cancel(ChromeDriver driver)
        {
            driver.FindElementById(CustomerXPath.CusCancelBtn).Click();
            Thread.Sleep(2000);

        }

    }
}
