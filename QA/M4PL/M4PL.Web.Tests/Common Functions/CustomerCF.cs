using M4PL.Web.Tests.Controls;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace M4PL.Web.Tests.Common_Functions
{
    public class CustomerCF
    {
        public static void NavToCusDVS(ChromeDriver driver)
        {
            driver.FindElement(By.Id(LeftPanelControls.CusDVS)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var cusStatusBar = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(CustomerControls.CusStatusBar)));
        }

        public static void CusOnClickSave(ChromeDriver driver)
        {
            driver.FindElement(By.Id(CustomerControls.CusSaveBtn)).Click();
        }

        public static void CusOnClickCancel(ChromeDriver driver)
        {
            driver.FindElement(By.Id(CustomerControls.CusCancelBtn)).Click();
        }

        public void CreateCustomer(ChromeDriver driver, string code, string title)
        {
            driver.FindElement(By.Id(CustomerControls.CusCode)).SendKeys(code);
            driver.FindElement(By.Id(CustomerControls.CusTitle)).SendKeys(title);
        }

        public void CreateBusinessTerms(ChromeDriver driver, string code)
        {
            driver.FindElement(By.Id(CustomerControls.BTCode)).SendKeys(code);
        }

        public void EditBusinessTerms(ChromeDriver driver, string title, string type, string activeDate, string value)
        {
            driver.FindElement(By.Id(CustomerControls.BTTitle)).SendKeys(title);
            var Type = driver.FindElement(By.Id(CustomerControls.BTType));
            Type.SendKeys(type);
            var ActiveDate = driver.FindElement(By.Id(CustomerControls.BTActiveDate));
            ActiveDate.SendKeys(activeDate);
            driver.FindElement(By.Id(CustomerControls.BTValue));
        }


        public void CreateFinancialCalendar(ChromeDriver driver, string code)
        {
            driver.FindElement(By.Id(CustomerControls.FCCode)).SendKeys(code);
            var PS = driver.FindElement(By.Id(CustomerControls.FCPeriodStartIcon));
            PS.Click();
            var PSToday = driver.FindElement(By.Id(CustomerControls.FCPeriodStartTodayIcn));
            PSToday.Click();
            var PE = driver.FindElement(By.Id(CustomerControls.FCPeriodEndIcon));
            PE.Click();
            var PEToday = driver.FindElement(By.Id(CustomerControls.FCPeriodEndTodayIcn));
            PEToday.Click();

        }

        public void EditFC(ChromeDriver driver, string title, string startDate, string endDate, string type, string status)
        {
            driver.FindElement(By.Id(CustomerControls.FCTitle)).SendKeys(title);
            driver.FindElement(By.Id(CustomerControls.FCPeriodStart)).SendKeys(startDate);
            driver.FindElement(By.Id(CustomerControls.FCPeriodEnd)).SendKeys(endDate);
            var Type = driver.FindElement(By.Id(CustomerControls.FCType));
            Type.Clear();
            Type.SendKeys(type);
            SendKeys.SendWait(@"{Enter}");
            var Status = driver.FindElement(By.Id(CustomerControls.FCStatus));
            Status.Clear();
            Status.SendKeys(type);
            SendKeys.SendWait(@"{Enter}");


        }

        public void CreateCustomerContact(ChromeDriver driver, string code)
        {
            driver.FindElement(By.Id(CustomerControls.CCCode)).SendKeys(code);

        }

        public void CreateCustomerContactContact(ChromeDriver driver, string fName, string lName, string indEmail)
        {
            
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
            var WaitFor = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(CustomerControls.CCContactId)));
            var FName = driver.FindElement(By.Id(CustomerControls.CCContactFirstName));
            FName.SendKeys(fName);
            var LName = driver.FindElement(By.Id(CustomerControls.CCContactLastName));
            LName.SendKeys(lName);
            var IndEmail = driver.FindElement(By.Id(CustomerControls.CCContactIndEmail));
            IndEmail.SendKeys(indEmail);
            var ContactCardSave = driver.FindElement(By.Id(CustomerControls.CCContactSave));
            ContactCardSave.Click();
        }

        public void CreateDCLocation(ChromeDriver driver, string code)
        {
            driver.FindElement(By.Id(CustomerControls.DCCode)).SendKeys(code);

        }

        public void CreateDCLocationContact(ChromeDriver driver, string fName, string lName, string indEmail)
        {
            
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
            var WaitFor = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(CustomerControls.CCContactId)));
            var FName = driver.FindElement(By.Id(CustomerControls.CDCContactFirstName));
            FName.SendKeys(fName);
            var LName = driver.FindElement(By.Id(CustomerControls.CDCContactLastName));
            LName.SendKeys(lName);
            var IndEmail = driver.FindElement(By.Id(CustomerControls.CDCContactIndEmail));
            IndEmail.SendKeys(indEmail);
            var ContactCardSave = driver.FindElement(By.Id(CustomerControls.CDCContactSave));
            ContactCardSave.Click();
        }

        public void CreateDocument(ChromeDriver driver, string code)
        {
            driver.FindElement(By.Id(CustomerControls.CDCode)).SendKeys(code);

        }

        public void CreateCAddressWA(ChromeDriver driver, string fName, string lName, string indEmail)
        {
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
            var WaitFor = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(CustomerControls.CAWAContactId)));
            var FName = driver.FindElement(By.Id(CustomerControls.CAWAFirstName));
            FName.SendKeys(fName);
            var LName = driver.FindElement(By.Id(CustomerControls.CAWALastName));
            LName.SendKeys(lName);
            var IndEmail = driver.FindElement(By.Id(CustomerControls.CAWAIndEmail));
            IndEmail.SendKeys(indEmail);
            var ContactCardSave = driver.FindElement(By.Id(CustomerControls.CAWASave));
            ContactCardSave.Click();
        }

        public void CustomerEdit(ChromeDriver driver, string typeCode, string webPage , string cusStatus)
        {
            var CusType = driver.FindElement(By.Id(CustomerControls.CusType));
            CusType.Clear();
            CusType.SendKeys(typeCode);
            SendKeys.SendWait(@"{Enter}");
            driver.FindElement(By.Id(CustomerControls.CusWebPage)).SendKeys(webPage);
            var CusStatus = driver.FindElement(By.Id(CustomerControls.CusStatus));
            CusStatus.Clear();
            CusStatus.SendKeys(cusStatus);
            SendKeys.SendWait(@"{Enter}");
        }
        
    }
}
