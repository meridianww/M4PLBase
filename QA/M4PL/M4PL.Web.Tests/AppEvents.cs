using M4PL.Web.Tests.Controls;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Interactions;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using _commonUtils = M4PL.Web.Tests.Common_Functions.CommonUtils;

namespace M4PL.Web.Tests
{
    public class AppEvents
    {
        public static bool ClickById(ChromeDriver driver, string id)
        {
            bool hitClick = true;
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(5));
            while (hitClick)
            {
                try
                {

                    bool isDisplayed = driver.FindElement(By.Id(id)).Displayed;

                    if (isDisplayed)
                    {
                        var itemToClick = wait.Until(ExpectedConditions.ElementToBeClickable(By.Id(id)));
                        if (itemToClick.Displayed)
                        {
                            itemToClick.Click();
                            hitClick = false;
                        }
                    }

                }
                catch (Exception e)
                {
                    _commonUtils.WriteToLog(e.ToString());
                    hitClick = true;
                }
            }

            return hitClick;
        }

        public static bool RightClickById(ChromeDriver driver, string id)
        {
            bool hitClick = true;
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(5));
            while (hitClick)
            {
                try
                {
                    bool isDisplayed = driver.FindElement(By.Id(id)).Displayed;

                    if (isDisplayed)
                    {
                        var itemToClick = wait.Until(ExpectedConditions.ElementToBeClickable(By.Id(id)));
                        if (itemToClick.Displayed)
                        {
                            Actions action = new Actions(driver);
                            action.ContextClick(itemToClick).Perform();
                            hitClick = false;
                        }
                    }

                }
                catch (Exception e)
                {
                    _commonUtils.WriteToLog(e.ToString());
                    hitClick = true;
                }
            }

            return hitClick;
        }

        public static bool ClickByXPath(ChromeDriver driver, string xpath)
        {
            bool hitClick = true;
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(5));
            while (hitClick)
            {
                try
                {

                    bool isDisplayed = driver.FindElement(By.XPath(xpath)).Displayed;

                    if (isDisplayed)
                    {
                        var itemToClick = wait.Until(ExpectedConditions.ElementToBeClickable(By.XPath(xpath)));
                        if (itemToClick.Displayed)
                        {
                            itemToClick.Click();
                            hitClick = false;
                        }
                    }

                }
                catch (Exception e)
                {
                    _commonUtils.WriteToLog(e.ToString());
                    hitClick = true;
                }
            }

            return hitClick;
        }

        public static bool RightClickByXPath(ChromeDriver driver, string xpath)
        {
            bool hitClick = true;
            WebDriverWait wait = new WebDriverWait(driver, TimeSpan.FromSeconds(5));
            while (hitClick)
            {
                try
                {
                    bool isDisplayed = driver.FindElement(By.XPath(xpath)).Displayed;

                    if (isDisplayed)
                    {
                        var itemToClick = wait.Until(ExpectedConditions.ElementToBeClickable(By.XPath(xpath)));
                        if (itemToClick.Displayed)
                        {
                            Actions action = new Actions(driver);
                            action.ContextClick(itemToClick).Perform();
                            hitClick = false;
                        }
                    }

                }
                catch (Exception e)
                {
                    _commonUtils.WriteToLog(e.ToString());
                    hitClick = true;
                }
            }

            return hitClick;
        }
    }
}
