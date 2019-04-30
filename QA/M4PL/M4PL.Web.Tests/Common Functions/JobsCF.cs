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
    public class JobsCF
    {
        public static void CreateJob(ChromeDriver driver, string cCCode)
        {
            var CCCode = driver.FindElement(By.Id(JobControls.CustomerSalesOrder));
            CCCode.Clear();
            CCCode.SendKeys(cCCode);
        }

        public static void SiteCode(ChromeDriver driver, string siteCode)
        {
            var SiteCode = driver.FindElement(By.Id(JobControls.SiteCode));
            SiteCode.Clear();
            SiteCode.SendKeys(siteCode);
        }

        public static void CustomerPurchaseOrder(ChromeDriver driver, string customerPurchaseOrder)
        {
            var CustomerPurchaseOrder = driver.FindElement(By.Id(JobControls.CustomerPurchaseOrder));
            CustomerPurchaseOrder.Clear();
            CustomerPurchaseOrder.SendKeys(customerPurchaseOrder);
        }

        public static void ConsigneeCode(ChromeDriver driver, string consigneeCode)
        {
            var ConsigneeCode = driver.FindElement(By.Id(JobControls.ConsigneeCode));
            ConsigneeCode.Clear();
            ConsigneeCode.SendKeys(consigneeCode);
        }

        public static void PlantCode(ChromeDriver driver, string plantCode)
        {
            var PlantCode = driver.FindElement(By.Id(JobControls.PlantCode));
            PlantCode.Clear();
            PlantCode.SendKeys(plantCode);
        }

        public static void CarrierId(ChromeDriver driver, string carrierId)
        {
            var CarrierId = driver.FindElement(By.Id(JobControls.CarrierId));
            CarrierId.Clear();
            CarrierId.SendKeys(carrierId);
        }

        public static void ManifestNo(ChromeDriver driver, string manifestNo)
        {
            var ManifestNo = driver.FindElement(By.Id(JobControls.ManifestNumber));
            ManifestNo.Clear();
            ManifestNo.SendKeys(manifestNo);
        }

        public static void BOL(ChromeDriver driver, string bol)
        {
            var BOL = driver.FindElement(By.Id(JobControls.BilingofLading));
            BOL.Clear();
            BOL.SendKeys(bol);
        }

        public static void BOLMaster(ChromeDriver driver, string bolMaster)
        {
            var BOLMaster = driver.FindElement(By.Id(JobControls.BilingofLadingMaster));
            BOLMaster.Clear();
            BOLMaster.SendKeys(bolMaster);
        }

        public static void BOLChild(ChromeDriver driver, string bolChild)
        {
            var BOLChild = driver.FindElement(By.Id(JobControls.BilingofLadingChild));
            BOLChild.Clear();
            BOLChild.SendKeys(bolChild);
        }

        public static void Brand(ChromeDriver driver, string brand)
        {
            var Brand = driver.FindElement(By.Id(JobControls.Brand));
            Brand.Clear();
            Brand.SendKeys(brand);
        }

        public static void UD1(ChromeDriver driver, string uD1)
        {
            var UD1 = driver.FindElement(By.Id(JobControls.UD1));
            UD1.Clear();
            UD1.SendKeys(uD1);
        }

        public static void UD2(ChromeDriver driver, string uD2)
        {
            var UD2 = driver.FindElement(By.Id(JobControls.UD2));
            UD2.Clear();
            UD2.SendKeys(uD2);
        }

        public static void UD3(ChromeDriver driver, string uD3)
        {
            var UD3 = driver.FindElement(By.Id(JobControls.UD3));
            UD3.Clear();
            UD3.SendKeys(uD3);
        }

        public static void UD4(ChromeDriver driver, string uD4)
        {
            var UD4 = driver.FindElement(By.Id(JobControls.UD4));
            UD4.Clear();
            UD4.SendKeys(uD4);
        }

        public static void UD5(ChromeDriver driver, string uD5)
        {
            var UD5 = driver.FindElement(By.Id(JobControls.UD5));
            UD5.Clear();
            UD5.SendKeys(uD5);
        }

        public static void JobGateway(ChromeDriver driver, string code, string type)
        {
            driver.FindElement(By.Id(JobControls.Code)).SendKeys(code);
            var Type = driver.FindElement(By.Id(JobControls.GtwType));
            Type.Clear();
            Type.SendKeys(type);
            Type.SendKeys(Keys.Enter);
            
        }

        public static void CreateJobCargo(ChromeDriver driver, string numberCode)
        {
            driver.FindElement(By.Id(JobControls.NumberCode)).SendKeys(numberCode);

        }

        public static void CreateDocument(ChromeDriver driver, string code)
        {
            driver.FindElement(By.Id(JobControls.DocCode)).SendKeys(code);
        }

        public static void CreateJobAttribute(ChromeDriver driver, string code, string quantity)
        {
            driver.FindElement(By.Id(JobControls.AttCode)).SendKeys(code);
            driver.FindElement(By.Id(JobControls.AttQty)).SendKeys(quantity);
        }
    }
}
