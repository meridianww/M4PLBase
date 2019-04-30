using M4PL.Web.Tests.Controls;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Common_Functions
{
    public class ProgramCF
    {
        public static void NavToPrgDVS(ChromeDriver driver)
        {
            driver.FindElement(By.Id(LeftPanelControls.PrgDVS)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var prgNewBtn = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(ProgramControls.PrgNewBtn)));
        }

        public static void PrgOnClickSave(ChromeDriver driver)
        {
            driver.FindElement(By.Id(ProgramControls.PrgSave)).Click();
        }

        public static void PrgOnClickCancel(ChromeDriver driver)
        {
            driver.FindElement(By.Id(ProgramControls.PrgCancel)).Click();
        }

       public static void CustomerSearch(ChromeDriver driver, string customerSearch)
        {
            driver.FindElement(By.XPath(customerSearch)).Click();
           
        }

        public static void CreateProgram(ChromeDriver driver, string programCode)
        {
            driver.FindElement(By.Id(ProgramControls.PrgCode)).SendKeys(programCode);
            
        }

        public static void CreateGateway(ChromeDriver driver, string code, string title, string duration)
        {
            driver.FindElement(By.Id(ProgramControls.PrgGtwCode)).SendKeys(code);
            driver.FindElement(By.Id(ProgramControls.PrgGtwTitle)).SendKeys(title);
            driver.FindElement(By.Id(ProgramControls.PrgGtwDuration)).SendKeys(duration);
            driver.FindElement(By.Id(ProgramControls.PrgGtwDefault)).Click();
        }

        public static void CreatePriceCode(ChromeDriver driver, string code, string title, string billablePrice)
        {
            driver.FindElement(By.Id(ProgramControls.PrgPCCode)).SendKeys(code);
            driver.FindElement(By.Id(ProgramControls.PrgPCTitle)).SendKeys(title);
            driver.FindElement(By.Id(ProgramControls.PrgPCBillablePrice)).SendKeys(billablePrice);
        }

        public static void CreateCostCode(ChromeDriver driver, string code, string title, string costRate)
        {
            driver.FindElement(By.Id(ProgramControls.PrgCCCode)).SendKeys(code);
            driver.FindElement(By.Id(ProgramControls.PrgCCTitle)).SendKeys(title);
            var CostRate= driver.FindElement(By.Id(ProgramControls.PrgCCCostRate));
            CostRate.Clear();
            CostRate.SendKeys(costRate);
        }

        public static void CreateReasonCode(ChromeDriver driver, string reasonCode)
        {
            driver.FindElement(By.Id(ProgramControls.PrgRCReasonCode)).SendKeys(reasonCode);
        }

        public static void CreateApptRsnCode(ChromeDriver driver, string apptReasonCode)
        {
            driver.FindElement(By.Id(ProgramControls.PrgACReasonCode)).SendKeys(apptReasonCode);
        }

        public static void CreateAttribute(ChromeDriver driver, string code, string quantity)
        {
            driver.FindElement(By.Id(ProgramControls.PrgAttCode)).SendKeys(code);
            driver.FindElement(By.Id(ProgramControls.PrgAttQty)).SendKeys(quantity);
            driver.FindElement(By.Id(ProgramControls.PrgAttDefault)).Click();
        }

        public static bool MapVendor(ChromeDriver driver, string waitFor, string searchedVendor)
        {
            //driver.FindElement(By.Id(ProgramControls.PrgVendorMap)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
            var WaitFor = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(waitFor)));
            var SearchedVendor = driver.FindElement(By.XPath(searchedVendor));
            SearchedVendor.Click();
            driver.FindElement(By.Id(ProgramControls.PrgVendorMapAssign)).Click();
            driver.FindElement(By.Id(ProgramControls.PrgVendorMapCancel)).Click();
            return WaitFor.Displayed;
        }

        public static void CreateCJ(ChromeDriver driver, string surveyCode, string surveyTitle)
        {
            driver.FindElement(By.Id(ProgramControls.PrgMVOCSurvCode)).SendKeys(surveyCode);
            driver.FindElement(By.Id(ProgramControls.PrgMVOCSurvTitle)).SendKeys(surveyTitle);
        }

        public static void SelectPPP(ChromeDriver driver, string element)
        {
            var Element = new SelectElement(driver.FindElement(By.XPath(element)));
            Element.SelectByText(element);
        }

        public static void CreateProject(ChromeDriver driver, string projectCode)
        {
            driver.FindElement(By.Id(ProgramControls.ProjectCode)).SendKeys(projectCode);
        }

        public static void CreatePhase(ChromeDriver driver, string phaseCode)
        {
            driver.FindElement(By.Id(ProgramControls.PhaseCode)).SendKeys(phaseCode);
        }
    }
}
