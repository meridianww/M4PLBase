using M4PL.Web.Tests.Common_Functions;
using M4PL.Web.Tests.Controls;
using M4PL.Web.Tests.ResourceFile;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using System;
using _func = M4PL.Web.Tests.Common_Functions.ApplicationCommonFunction;
using _commonUtils = M4PL.Web.Tests.Common_Functions.CommonUtils;


namespace M4PL.Web.Tests.RegressionCases
{
    [TestClass]
    public class ContactTest

    {
        LoginControls _loginControls;
        ContactControls _contactControls;
        ChromeDriver _chromeDriver;
        ApplicationCommonFunction _applicationLogin;
        ContactCF _contactCF;


        public ContactTest()
        {
            _loginControls = new LoginControls();
            _contactControls = new ContactControls();
            _applicationLogin = new ApplicationCommonFunction();
            _chromeDriver = ApplicationCommonFunction.OpenChromeWindow();
            _contactCF = new ContactCF();
        }


        [TestMethod]
        public void CreateContact()
        {
            try
            {

                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                 _func.NavigateTo(_chromeDriver, LeftPanelControls.ConDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, ContactControls.ContactGridFocussed))
                {
                    _chromeDriver.Navigate().Refresh();
                     _func.New(_chromeDriver);
                    WebDriverWait wait = new WebDriverWait(_chromeDriver, TimeSpan.FromSeconds(15));
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ContactControls.conTitle);
                    ContactCF.CreateContact(_chromeDriver, ContactDetails.FirstName, ContactDetails.LastName, ContactDetails.WorkEmail);
                    _func.Save(_chromeDriver);
                    WebDriverWait wait1 = new WebDriverWait(_chromeDriver, TimeSpan.FromSeconds(20));
                    _func.SaveOk(_chromeDriver);
                }
            }

        catch (Exception e)
            {
                _commonUtils.Screenshot(_chromeDriver);
                _commonUtils.WriteToLog(e.ToString());
                NUnit.Framework.Assert.Fail();

            }
        }

        [TestMethod]

          public void EditContact()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.ConDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, ContactControls.ContactGridFocussed))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ContactControls.ContactToggleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, ContactControls.ConFirstNameSearch, ContactDetails.SearchedFN, ContactControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, ContactControls.ConToggleFilterRow0);
                    _func.NavigateTo(_chromeDriver, ContactControls.ConEdit);
                    _func.WaitForElement(_chromeDriver, ContactControls.conTitle);
                    ContactCF.EditContact(_chromeDriver, ContactDetails.middleName, ContactDetails.indEmail);
                    _func.NavigateTo(_chromeDriver, ContactControls.conSave);
                    _func.SaveOk(_chromeDriver);
                }

                }

            catch (Exception e)
            {
                _commonUtils.Screenshot(_chromeDriver);
                _commonUtils.WriteToLog(e.ToString());
                NUnit.Framework.Assert.Fail();

            }
        }

        [TestMethod]
        public void VerificationForErrorMessage()
        {
            {
                try
                {
                    ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                    _func.NavigateTo(_chromeDriver, LeftPanelControls.ConDVS);
                    if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, ContactControls.ContactGridFocussed))
                    {
                        _chromeDriver.Navigate().Refresh();
                        _func.New(_chromeDriver);
                        WebDriverWait wait = new WebDriverWait(_chromeDriver, TimeSpan.FromSeconds(15));
                        ApplicationCommonFunction.WaitForElement(_chromeDriver, ContactControls.conTitle);
                        _func.NavigateTo(_chromeDriver, ContactControls.conSave);
                        ApplicationCommonFunction.ErrorMessageByClass(_chromeDriver);
                        ApplicationCommonFunction.Cancel(_chromeDriver, ContactControls.conCancel);

                    }

                }

                catch (Exception e)
                {
                    _commonUtils.Screenshot(_chromeDriver);
                    _commonUtils.WriteToLog(e.ToString());
                    NUnit.Framework.Assert.Fail();

                }
            }
        }

        //[TestMethod]
        //public void CreateContactUsingExcel()
        //{
        //     try
        //    {

        //        ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
        //         _func.NavigateTo(_chromeDriver, LeftPanelControls.ConDVS);
        //        if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, ContactControls.ContactGridFocussed))
        //        {
        //            _chromeDriver.Navigate().Refresh();
        //             _func.New(_chromeDriver);
        //            WebDriverWait wait = new WebDriverWait(_chromeDriver, TimeSpan.FromSeconds(15));
        //            ApplicationCommonFunction.WaitForElement(_chromeDriver, ContactControls.conTitle);
        //            //ContactCF.CreateContact(_chromeDriver, ContactDetails.FirstName, ContactDetails.LastName, ContactDetails.WorkEmail);
        //            ApplicationCommonFunction.GetValueByKey(_chromeDriver, @"C: \Users\diksha.bhargava\Desktop\Contact.xlsx", "First Name");
        //            _func.Save(_chromeDriver);
        //            WebDriverWait wait1 = new WebDriverWait(_chromeDriver, TimeSpan.FromSeconds(20));
        //            _func.SaveOk(_chromeDriver);
        //        }   
        //    }

        //catch (Exception e)
        //    {
        //        _commonUtils.Screenshot(_chromeDriver);
        //        _commonUtils.WriteToLog(e.ToString());
        //        NUnit.Framework.Assert.Fail();

        //    }
        //}

    }

}


