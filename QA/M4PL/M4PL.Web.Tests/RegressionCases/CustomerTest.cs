using M4PL.Web.Tests.Common_Functions;
using M4PL.Web.Tests.Controls;
using M4PL.Web.Tests.ResourceFile;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using _func = M4PL.Web.Tests.Common_Functions.ApplicationCommonFunction;
using _commonUtils = M4PL.Web.Tests.Common_Functions.CommonUtils;
using Assert = NUnit.Framework.Assert;

namespace M4PL.Web.Tests.RegressionCases
{
    [TestClass]
    public class CustomerTest

    {
        LoginControls _loginControls;
        CustomerControls _customerControls;
        ChromeDriver _chromeDriver;
        ApplicationCommonFunction _applicationLogin;
        CustomerCF _customerCF;


        public CustomerTest()
        {
            _loginControls = new LoginControls();
            _customerControls = new CustomerControls();
            _applicationLogin = new ApplicationCommonFunction();
            _chromeDriver = ApplicationCommonFunction.OpenChromeWindow();
            _customerCF = new CustomerCF();
        }


        [TestMethod]
        public void CreateCustomer()

        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.New(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _customerCF.CreateCustomer(_chromeDriver, CustomerDetails.Code, CustomerDetails.Title);
                    _func.Save(_chromeDriver);
                    _func.SaveOk(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);


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
        public void EditCustomer()

        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _customerCF.CustomerEdit(_chromeDriver, CustomerDetails.CusType, CustomerDetails.WebPage, CustomerDetails.Status);
                    ApplicationCommonFunction.FileUpload(_chromeDriver, CustomerControls.CusLogo, CustomerDetails.ImagePath);
                    ApplicationCommonFunction.SaveButtonFormView(_chromeDriver, CustomerControls.CusSaveBtn);
                    _func.SaveOk(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);
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
        public void VerificationOfErrorMessage()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.New(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusSaveBtn);
                    ApplicationCommonFunction.ErrorMessageByClass(_chromeDriver);
                    _func.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);
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
        public void CreateWorkAddressContact()

        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusAddress);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CWorkAddressContactIcon);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CWorkAddressContactIcon);
                    _customerCF.CreateCAddressWA(_chromeDriver, CustomerDetails.WAFirstName, CustomerDetails.WALastName, CustomerDetails.WAIndEmail);
                    _func.Save(_chromeDriver);
                    _func.SaveOk(_chromeDriver);
                    _func.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);

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
        public void CreateBusinessTermsCusSearch()

        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.BTTab);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.BTEmptyRow);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.BTEmptyRow);
                    _func.NavigateTo(_chromeDriver, CustomerControls.BTNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.BTItem);
                    _customerCF.CreateBusinessTerms(_chromeDriver, CBusinessTermsDetails.Code);
                    _func.NavigateTo(_chromeDriver, CustomerControls.BTSavebtn);
                    _func.SaveOk(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);



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
        public void CreateFinancialCalendarCusSearch()

        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.FCTab);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.FCEmptyRow);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.FCEmptyRow);
                    _func.NavigateTo(_chromeDriver, CustomerControls.FCNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.FCId);
                    _customerCF.CreateFinancialCalendar(_chromeDriver, CFinancialCalendarDetails.Code);
                    _func.NavigateTo(_chromeDriver, CustomerControls.FCSave);
                    _func.SaveOk(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);



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
        public void CFCValidationMessages()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.FCTab);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.FC0Row);
                    _func.NavigateTo(_chromeDriver, CustomerControls.FCNew);
                    _func.WaitForElement(_chromeDriver, CustomerControls.FCPeriodOrder);
                    _func.NavigateTo(_chromeDriver, CustomerControls.FCSave);
                    ApplicationCommonFunction.ErrorMessageByClass(_chromeDriver);
                    _func.NavigateTo(_chromeDriver, CustomerControls.FCCancel);
                    _func.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);

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
        public void CreateCustomerContactCusSearch()

        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CCTab);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CCEmptyRow);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.CCEmptyRow);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CCNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CCId);
                    _customerCF.CreateCustomerContact(_chromeDriver, CCustomerContactDetails.Code);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CCContactCardIcon);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CCContactCardIcon);
                    _customerCF.CreateCustomerContactContact(_chromeDriver, CCustomerContactDetails.fName, CCustomerContactDetails.lName, CCustomerContactDetails.indEmail);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CCSaveIcn);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CCSaveIcn);
                    _func.SaveOk(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);



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
        public void CustomerContactValidationMessages()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CCTab);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.CC0Row);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CCNew);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CCId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CCSaveIcn);
                    ApplicationCommonFunction.ErrorMessageByClass(_chromeDriver);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CCCancelIcn);
                    _func.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);

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
        public void CreateDCLocationCusSearch()

        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CDCLoc);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.DCEmptyRow);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.DCEmptyRow);
                    _func.NavigateTo(_chromeDriver, CustomerControls.DCNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.DCId);
                    _customerCF.CreateDCLocation(_chromeDriver, CDClocationDetails.Code);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.DCContactCardIcon);
                    _func.NavigateTo(_chromeDriver, CustomerControls.DCContactCardIcon);
                    _customerCF.CreateDCLocationContact(_chromeDriver, CDClocationDetails.fName, CDClocationDetails.lName, CDClocationDetails.indEmail);
                     ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.DCContactxIcon);
                    _func.NavigateTo(_chromeDriver, CustomerControls.DCSaveIcon);
                    _func.SaveOk(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);

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
        public void CDCValidationMessages()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CDCLoc);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.DC0Row);
                    _func.NavigateTo(_chromeDriver, CustomerControls.DCNew);
                    _func.WaitForElement(_chromeDriver, CustomerControls.DCId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.DCSaveIcon);
                    ApplicationCommonFunction.ErrorMessageByClass(_chromeDriver);
                    _func.NavigateTo(_chromeDriver, CustomerControls.DCCancel);
                    _func.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);

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
        public void CreateDocumentCusSearch()

        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                   
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusDoc);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.DocEmptyRow);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.DocEmptyRow);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CDNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CDId);
                    _customerCF.CreateDocument(_chromeDriver, CDocumentDetails.Code);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CDSaveIcn);
                    _func.SaveOk(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);
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
        public void CDocValidationMessages()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusDoc);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.CD0Row);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CDNew);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CDId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CDSaveIcn);
                    ApplicationCommonFunction.ErrorMessageByClass(_chromeDriver);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CDCancelIcn);
                    _func.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);

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
        public void EditBusinessTermsTF()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.BTTab);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.BT0Row);
                    _func.NavigateTo(_chromeDriver, CustomerControls.BTToggleFilter);
                     _func.WaitForElement(_chromeDriver, CustomerControls.BTToggleFilterRow);
                    _func.ToggleSearch(_chromeDriver, CustomerControls.BTSearchedColumnCode, CBusinessTermsDetails.SearchValue, CustomerControls.FilterBoxCheckedBT);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.BT0Row);
                    _func.NavigateTo(_chromeDriver, CustomerControls.BTEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.BTItem);
                    _customerCF.EditBusinessTerms(_chromeDriver, CBusinessTermsDetails.Title, CBusinessTermsDetails.Type, CBusinessTermsDetails.ActiveDate, CBusinessTermsDetails.Value);
                    //_func.NavigateTo(_chromeDriver,CustomerControls.BTAttachmentPanel);
                    //_func.WaitForElement(_chromeDriver,CustomerControls.BTAttachmentHeaderRow);
                    //_func.NavigateTo(_chromeDriver, CustomerControls.BTAttachmentNew);
                   // ApplicationCommonFunction.FileUpload(_chromeDriver,CBusinessTermsDetails.ImagePath, CustomerControls.BTAttachmentBrowse);
                   // _func.WaitForElement(_chromeDriver, CustomerControls.BTAttachmentGridStatusBarFooter);
                   // _func.NavigateTo(_chromeDriver, CustomerControls.BTAttachmentSaveChanges);
                   // _func.WaitForElement(_chromeDriver, CustomerControls.BTAttachmentPageHeader);
                    _func.NavigateTo(_chromeDriver, CustomerControls.BTSavebtn);
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
        public void CBTValidationMessages()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.BTTab);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.BT0Row);
                    _func.NavigateTo(_chromeDriver, CustomerControls.BTNew);
                    _func.WaitForElement(_chromeDriver, CustomerControls.BTItem);
                    _func.NavigateTo(_chromeDriver, CustomerControls.BTSavebtn);
                    ApplicationCommonFunction.ErrorMessageByClass(_chromeDriver);
                    _func.NavigateTo(_chromeDriver, CustomerControls.BTCancel);
                    _func.Cancel(_chromeDriver, CustomerControls.CusCancelBtn);

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
        public void EditFC()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.CusDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, CustomerControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, CustomerControls.CustomerToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, CustomerControls.CusCodeToggleFilterPath, CustomerDetails.SearchedCodeValue, CustomerControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, CustomerControls.SearchedRow0);
                    _func.NavigateTo(_chromeDriver, CustomerControls.CusEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.CustomerId);
                    _func.NavigateTo(_chromeDriver, CustomerControls.FCTab);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.FC0Row);
                    _func.NavigateTo(_chromeDriver, CustomerControls.FCToggleFilter);
                    _func.WaitForElement(_chromeDriver, CustomerControls.FCToggleFilterRow);
                    _func.ToggleSearch(_chromeDriver, CustomerControls.FCSearchedColumnCode, CFinancialCalendarDetails.SearchValue, CustomerControls.FilterBoxCheckedFC);
                    _func.RightClickGrid(_chromeDriver, CustomerControls.FC0Row);
                    _func.NavigateTo(_chromeDriver, CustomerControls.FCEdit);
                    _func.WaitForElement(_chromeDriver, CustomerControls.FCPeriodOrder);
                    _customerCF.EditFC(_chromeDriver, CFinancialCalendarDetails.Title, CFinancialCalendarDetails.StartDate, CFinancialCalendarDetails.EndDate, CFinancialCalendarDetails.Type, CFinancialCalendarDetails.Status );
                   _func.NavigateTo(_chromeDriver, CustomerControls.FCSave);
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


    }
}
