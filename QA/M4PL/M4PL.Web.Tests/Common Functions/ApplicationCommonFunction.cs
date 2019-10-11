using ExcelDataReader;
using M4PL.Web.Tests.Controls;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using _events = M4PL.Web.Tests.AppEvents;

namespace M4PL.Web.Tests.Common_Functions
{
    public class ApplicationCommonFunction

    {
        //Opening ChromeDriver and Navigation to CCNET Url
        public static ChromeDriver OpenChromeWindow()
        {
            ChromeDriver _chromeDriver = new ChromeDriver((Directory.GetParent((Directory.GetParent(Environment.CurrentDirectory)).ToString())).ToString() + @"\Utilities\ExternalFiles"); ;
            _chromeDriver.Navigate().GoToUrl(M4PLResources.CCNETURL);
            _chromeDriver.Manage().Window.Maximize();
            return _chromeDriver; 

        }

        public static void Login(string userName, string password, ChromeDriver driver, LoginControls loginControls)
        {
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(5));
            var txtBoxEmailId = wait.Until(ExpectedConditions.ElementIsVisible(By.Id(LoginControls.Email_Id)));
            txtBoxEmailId.SendKeys(userName);
            driver.FindElement(By.Id(LoginControls.Password_Field)).SendKeys(password);
            driver.FindElement(By.Id(LoginControls.Login_Btn)).Click();
            //driver.Manage().Timeouts().ImplicitWait = TimeSpan.FromSeconds(10);
        }

        public static void Logout(ChromeDriver driver)
        {

        }

        public static void WaitForElementLoad(ChromeDriver driver, By by, int timeoutInSeconds)
        {
            //string name = "TEST";
            if (timeoutInSeconds > 0)
            {
                WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(timeoutInSeconds));
                // var clickEvent = wait.Until(ExpectedConditions.ElementToBeClickable(by));
                //clickEvent.Click();

            }
        }


        public static void RightClickGrid(ChromeDriver driver, string gridPath)
        {
            //var GridPath = driver.FindElement(By.XPath(gridPath));
            //Actions action = new Actions(driver);
            //action.ContextClick(GridPath).Perform();
            //WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(5));
            _events.RightClickById(driver, gridPath);
        }

        public static void RightClickByXPath(ChromeDriver driver, string xpath)
        {
            _events.RightClickByXPath(driver, xpath);
        }



        #region Ribbon
        public static void FormView(ChromeDriver driver)
        {

            _events.ClickById(driver, RibbonControls.FormViewBtn);
        }

        public static void DataSheetView(ChromeDriver driver)
        {
            driver.FindElement(By.Id(RibbonControls.DataShtViewBtn)).Click();
        }

        public static void ChooseColumn(ChromeDriver driver)
        {
            driver.FindElement(By.Id(RibbonControls.ChooseColumn)).Click();
        }

        public static void ToggleFilter(ChromeDriver driver)
        {
            _events.ClickById(driver, RibbonControls.ToggleFilter);
        }

        public static void New(ChromeDriver driver)
        {
            _events.ClickById(driver, RibbonControls.New);

        }

        public static void Save(ChromeDriver driver)
        {
            _events.ClickById(driver, RibbonControls.Save);
        }

        public static void SaveOk(ChromeDriver driver)
        {
            _events.ClickById(driver, RibbonControls.SaveOkbtn);
        }
        #endregion Ribbon

        public static void NavigateTo(ChromeDriver driver, string toPageId)
        {
            //WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(50));
            //wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(toPage)));
            //var ToPage = driver.FindElement(By.Id(toPage));
            //Actions action = new Actions(driver);
            //action.Click(ToPage).Perform();
            _events.ClickById(driver, toPageId);

        }

        public static void NavigateToXpath(ChromeDriver driver, string elementXPath)
        {
            _events.ClickByXPath(driver, elementXPath);
        }


        public static bool ToggleSearch(ChromeDriver driver, string searchPath, string value, string waitFor)
        {
            var SearchPath = driver.FindElementById(searchPath);
             SearchPath.SendKeys(value);
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
            var WaitFor = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(waitFor)));
            return WaitFor.Displayed;
        }

       

        public static void DoubleClick(ChromeDriver driver, string onElement)
        {

            new Actions(driver).DoubleClick(driver.FindElement(By.XPath(onElement))).Perform();
        }

        public static bool WaitForElement(ChromeDriver driver, string waitFor)
        {
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(20));
            var WaitFor = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.Id(waitFor)));
            return WaitFor.Displayed;
        }



        public static bool WaitForElementByClass(ChromeDriver driver, string waitFor)
        {
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(5));
            var WaitFor = wait.Until(SeleniumExtras.WaitHelpers.ExpectedConditions.ElementIsVisible(By.ClassName(waitFor)));
            return WaitFor.Displayed;
        }

        public static void WaitForLoad(IWebDriver driver, int timeoutSec = 30)
        {
            IJavaScriptExecutor js = (IJavaScriptExecutor)driver;
            WebDriverWait wait = new WebDriverWait(driver, new TimeSpan(0, 0, timeoutSec));
            wait.Until(wd => js.ExecuteScript("return document.readyState").ToString() == "complete");
        }

        public static void SaveIcn(ChromeDriver driver, string saveIcn)
        {
            var SaveIcn = driver.FindElement(By.Id(saveIcn));
            Actions action = new Actions(driver);
            action.Click(SaveIcn).Perform();

        }

        public static void SaveOkPopUp(ChromeDriver driver, string save)
        {

            var Save = driver.FindElement(By.Id(save));
            Actions action = new Actions(driver);
            action.Click(Save).Perform();

        }

        public static void SaveButtonFormView(ChromeDriver driver, string save)
        {
            var Save = driver.FindElement(By.Id(save));
            Actions action = new Actions(driver);
            action.Click(Save).Perform();
        }

        public static void Cancel(ChromeDriver driver, string cancelPath)
        {
            var CancelPath = driver.FindElement(By.Id(cancelPath));
            CancelPath.Click();
        }
 
       
        public static void FileUpload(ChromeDriver driver, string imagePath, string idPath)
         {
            var button = driver.FindElement(By.Id(imagePath));

            button.Click();
            Thread.Sleep(3000); //simple wait method

            SendKeys.SendWait(@idPath); //this code sends the path to the file upload dialog
            Thread.Sleep(5000);//simple wait method

            SendKeys.SendWait(@"{Enter}"); //simulates pressing enter button 
            Thread.Sleep(2000);
        }


        public static string GetColumnIdFromChooseColumn(ChromeDriver driver,string columnName)
        {
            int i = 0;
            string columnXPath = String.Empty;
            //Below hard coded value is choose column XPath
            List<IWebElement> table = new List<IWebElement>(driver.FindElements(By.XPath("//table[@id='lblShowColumns_LBT']//tbody")));

            foreach (var item in table)
            {
                if (item.Text == columnName)
                {
                    columnXPath = "//table[@id='lblShowColumns_LBT" + i.ToString() + "T0" + "']//tbody";
                }

                i++;
            }
            return columnXPath;
           

        }

        public static void Send(ChromeDriver driver, string columnXPath)
        {
            IWebElement element = driver.FindElement(By.XPath(columnXPath));
            element.SendKeys(columnXPath);

        }

        //public static DataTable GetDataTabletFromExcel(ChromeDriver driver, string filePath)
        //{
        //    FileStream fileStream = File.Open(filePath, FileMode.Open, FileAccess.Read);
        //    IExcelDataReader dataReader = null;

        //    if (filePath.EndsWith(".xls"))
        //    {
        //        dataReader = ExcelReaderFactory.CreateBinaryReader(fileStream);
        //    }
        //    else if (filePath.EndsWith(".xlsx"))
        //    {
        //        dataReader = ExcelReaderFactory.CreateOpenXmlReader(fileStream);
        //    }
        //    var dataSet = dataReader.AsDataSet(new ExcelDataSetConfiguration
        //    {
        //        ConfigureDataTable = _ => new ExcelDataTableConfiguration
        //        {
        //            UseHeaderRow = true // Use first row is ColumnName here :D
        //        }
        //    });
        //    if (dataSet.Tables.Count > 0)
        //    {
        //        return dataSet.Tables[0];
        //        // Do Something

        //    }
        //    return null;
        //}

        ////Function to read the extracted csv data into a dictionary
        //public static Dictionary<string, string> GetCsvDataToDictionary(ChromeDriver driver, string filePath)
        //{
        //    Dictionary<string, string> result = new Dictionary<string, string>();
        //    DataTable dt = GetDataTabletFromExcel(driver, filePath);
        //    for (int i = 0; dt.Rows.Count > i; i++)
        //    {
        //        result.Add(dt.Rows[i][0].ToString(), dt.Rows[i][1].ToString());

        //        //@"C:\Users\admin\Desktop\Ranorex\ShipItSmokeTests\ExcelSheets\ShipmentDetails.csv"
        //    }
        //    return result;
        //}

        ////Function to Extract the value from dictionary when a key is provided 
        //public static String GetValueByKey(ChromeDriver driver, string filePath, string key)
        //{
        //    Dictionary<string, string> value = GetCsvDataToDictionary(driver, filePath);
        //    return value[key];
        //}

        public static void ErrorMessageByClass(ChromeDriver driver)
        {
            var errorMsg = driver.FindElementByClassName("errorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsg) ? errorMsg : "Succeeded");
        }

        public static void ErrorMessageByClassPopUp(ChromeDriver driver)
        {
            var errorMsg = driver.FindElementByClassName("recordPopupErrorMessages").Text;
            System.Diagnostics.Debug.WriteLine(!string.IsNullOrWhiteSpace(errorMsg) ? errorMsg : "Succeeded");
        }
    }
}



