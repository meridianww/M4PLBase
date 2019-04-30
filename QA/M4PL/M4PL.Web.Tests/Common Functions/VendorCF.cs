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
   public class VendorCF
    {
        public static void NavToVendDVS(ChromeDriver driver)
        {
            driver.FindElement(By.Id(LeftPanelControls.VenDVS)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var venStatusBar = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(VendorControls.VenStatusBar)));
        }

        public static void VenOnClickSave(ChromeDriver driver)
        {
            driver.FindElement(By.Id(VendorControls.VenSaveBtn)).Click();
        }

        public static void VenOnClickCancel(ChromeDriver driver)
        {
            driver.FindElement(By.Id(VendorControls.VenCancelBtn)).Click();
        }

        public static void CreateVendor(ChromeDriver driver, string vCode, string vTitle, string vType, string vWebPage)
        {
            driver.FindElement(By.Id(VendorControls.VendCode)).SendKeys(vCode);
            driver.FindElement(By.Id(VendorControls.VendTitle)).SendKeys(vTitle);
            var Vtype = driver.FindElement(By.Id(VendorControls.VendType));
            Vtype.Clear();
            Vtype.SendKeys(vType);
            SendKeys.SendWait(@"{Enter}");
            driver.FindElement(By.Id(VendorControls.VendWebPage)).SendKeys(vWebPage);
        }

        public void CreateVendorBusinessTerms(ChromeDriver driver, string code)
        {
            driver.FindElement(By.Id(VendorControls.VenBTCode)).SendKeys(code);
        }

        public void CreateVendorFinancialCalendar(ChromeDriver driver, string code)
        {
            driver.FindElement(By.Id(VendorControls.VenFCCode)).SendKeys(code);
            var PS = driver.FindElement(By.Id(VendorControls.VenFCPeriodStartIcon));
            PS.Click();
            var PSToday = driver.FindElement(By.Id(VendorControls.VenFCPeriodStartTodayIcn));
            PSToday.Click();
            var PE = driver.FindElement(By.Id(VendorControls.VenFCPeriodEndIcon));
            PE.Click();
            var PEToday = driver.FindElement(By.Id(VendorControls.VenFCPeriodEndTodayIcn));
            PEToday.Click();

        }

        public void CreateVendorContact(ChromeDriver driver, string code)
        {
            driver.FindElement(By.Id(VendorControls.VCCode)).SendKeys(code);

        }

        public void CreateVendorContactContact(ChromeDriver driver, string fName, string lName, string indEmail)
        {

            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
            var WaitFor = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(VendorControls.VCContactId)));
            var FName = driver.FindElement(By.Id(VendorControls.VCContactFirstName));
            FName.SendKeys(fName);
            var LName = driver.FindElement(By.Id(VendorControls.VCContactLastName));
            LName.SendKeys(lName);
            var IndEmail = driver.FindElement(By.Id(VendorControls.VCContactIndEmail));
            IndEmail.SendKeys(indEmail);
            var ContactCardSave = driver.FindElement(By.Id(VendorControls.VCContactSave));
            ContactCardSave.Click();
        }

        public void CreateVendorDCLocation(ChromeDriver driver, string code)
        {
            driver.FindElement(By.Id(VendorControls.VDCCode)).SendKeys(code);

        }

        public void CreateVendorDCLocationContact(ChromeDriver driver, string fName, string lName, string indEmail)
        {

            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
            var WaitFor = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(VendorControls.VCContactId)));
            var FName = driver.FindElement(By.Id(VendorControls.VDCContactFirstName));
            FName.SendKeys(fName);
            var LName = driver.FindElement(By.Id(VendorControls.VDCContactLastName));
            LName.SendKeys(lName);
            var IndEmail = driver.FindElement(By.Id(VendorControls.VDCContactIndEmail));
            IndEmail.SendKeys(indEmail);
            var ContactCardSave = driver.FindElement(By.Id(VendorControls.VDCContactSave));
            ContactCardSave.Click();
        }

        public void CreateVendorDocument(ChromeDriver driver, string code)
        {
            driver.FindElement(By.Id(VendorControls.VDCode)).SendKeys(code);

        }

        public void CreateVendorAddressWA(ChromeDriver driver, string fName, string lName, string indEmail)
        {
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
            var WaitFor = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(VendorControls.VWAContactId)));
            var FName = driver.FindElement(By.Id(VendorControls.VWAFirstName));
            FName.SendKeys(fName);
            var LName = driver.FindElement(By.Id(VendorControls.VWALastName));
            LName.SendKeys(lName);
            var IndEmail = driver.FindElement(By.Id(VendorControls.VWAIndEmail));
            IndEmail.SendKeys(indEmail);
            var ContactCardSave = driver.FindElement(By.Id(VendorControls.VWASave));
            ContactCardSave.Click();
        }

    }
}
