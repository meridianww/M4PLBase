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
    public class OrganizationCF
    {
       /* public static void NavToOrgDVS(ChromeDriver driver)
        {
            driver.FindElement(By.Id(LeftPanelControls.OrgDVS)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(5));
            var orgStatusBar = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(OrganizationControls.StatusBar)));

        }*/

        public static void OrgOnClickSave(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgSave)).Click();
        }

        public static void OrgOnClickCancel(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgCancel)).Click();
        }

        public static void OrgRtNew(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgNew)).Click();
        }

        public static void OrgRtEdit(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgEdit)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var orgSaveIcn = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(OrganizationControls.OrgSave)));

        }

        public static void OrgRtChooseColumn(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgChooseColumn));
        }

        public static void NavOrgPOC(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgPOCTab)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(5));
            var pocStatusBar = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(OrganizationControls.OrgPOCStatusBar)));
        }

        public static void OrgPOCNew(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgPOCNew)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(5));
            var pocId = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(OrganizationControls.OrgPOCId)));
        }

        public static void OrgPOCEdit(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgPOCEdit)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(5));
            var pocId = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(OrganizationControls.OrgPOCId)));
        }

        public static void OrgPOCChooseColumn(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgPOCChooseColumn));
        }

        public static void OrgPOCSave(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgPOCSave));
        }

        public static void OrgPOCCancel(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgPOCCancel));
        }

        public static void NavOrgCred(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgCredTab)).Click();
        }

        public static void OrgCredNew(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgCredNew)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var credId = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(OrganizationControls.OrgCredId)));
        }

        public static void OrgCredEdit(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgCredEdit)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var credId = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(OrganizationControls.OrgCredId)));
        }

        public static void OrgCredChooseColumn(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgCredChooseColumn));
        }

        public static void OrgCredSave(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgCredSave));
        }

        public static void OrgCredCancel(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgCredCancel));
        }

        public static void NavOrgRolesResp(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgRoleResTab)).Click();
        }

        /*public static void OrgRoleRespEdit(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.)).Click();
        }

        public static void OrgRoleRespChooseColumn(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.));
        }

        public static void OrgRoleRespSave(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgCredSave));
        }

        public static void OrgRoleRespCancel(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgCredCancel));
        }*/

        public static void NavToOrgActRole(ChromeDriver driver)
        {
            driver.FindElement(By.Id(LeftPanelControls.OrgActRole)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var orgARStatusBar = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(OrganizationControls.OrgActRolStatusBar)));
        }

        public static void OrgAROnClickSave(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgRRSave)).Click();
        }

        public static void OrgAROnClickCancel(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgRRCancel)).Click();
        }

        public static void OrgNavActSecurity(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgActRolSecurity)).Click();
        }

        public static void NavToOrgRefRole(ChromeDriver driver)
        {
            driver.FindElement(By.Id(LeftPanelControls.OrgRefRole)).Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(2));
            var orgRRStatusBar = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(OrganizationControls.OrgRefRolStatusBar)));
        }

        public static void OrgrROnClickSave(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgRefRolSave)).Click();
        }

        public static void OrgRROnClickCancel(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgRefRolCancel)).Click();
        }

        public static void OrgNavRRecurity(ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgRefRolSecurity)).Click();
        }

        public static void createPOC(string POCCode, string POCTitle, ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgPOCCode)).SendKeys(POCCode);
            driver.FindElement(By.Id(OrganizationControls.OrgPOCTitle)).SendKeys(POCTitle);

        }

        public static void createCred(string CredCode, string CredTitle, ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgCredCode)).SendKeys(CredCode);
            driver.FindElement(By.Id(OrganizationControls.OrgCredTitle)).SendKeys(CredTitle);

        }

        public static void createRefRole(string rRCode, string rRTitle, ChromeDriver driver)
        {
            driver.FindElement(By.Id(OrganizationControls.OrgRefRolCode)).SendKeys(rRCode);
            driver.FindElement(By.Id(OrganizationControls.OrgRefRolTitle)).SendKeys(rRTitle);
        }

        public static void ContactCardRefRol(ChromeDriver driver, string contactCardId, string waitFor, string fName, string lName, string indEmail)
        {
            var ContactCardId = driver.FindElement(By.Id(contactCardId));
            ContactCardId.Click();
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
            var WaitFor = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(waitFor)));
            var FName = driver.FindElement(By.Id(OrganizationControls.OrgRRConFN));
            FName.SendKeys(fName);
            var LName = driver.FindElement(By.Id(OrganizationControls.OrgRRConLN));
            LName.SendKeys(lName);
            var IndEmail = driver.FindElement(By.Id(OrganizationControls.OrgRRConIndEml));
            IndEmail.SendKeys(indEmail);
            //var BusinessPhone = driver.FindElement(By.Id(OrganizationControls.OrgRRBusinessPhn));
            //BusinessPhone.SendKeys(businessPhone);
        }
    }
}
