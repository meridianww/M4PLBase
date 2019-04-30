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
    public class VendorTest

    {
        LoginControls _loginControls;
        VendorControls _vendorControls;
        ChromeDriver _chromeDriver;
        ApplicationCommonFunction _applicationLogin;
        VendorCF _vendorCF;


        public VendorTest()
        {
            _loginControls = new LoginControls();
            _vendorControls = new VendorControls();
            _applicationLogin = new ApplicationCommonFunction();
            _chromeDriver = ApplicationCommonFunction.OpenChromeWindow();
            _vendorCF = new VendorCF();
        }


        [TestMethod]
        public void CreateVendor()
        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.VenDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, VendorControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.New(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VendId);
                    VendorCF.CreateVendor(_chromeDriver, VendorDetails.Code, VendorDetails.Title, VendorDetails.Type, VendorDetails.WebPage);
                    ApplicationCommonFunction.FileUpload(_chromeDriver, VendorControls.VendLogo, VendorDetails.Logo);
                    _func.Save(_chromeDriver);
                    _func.SaveOk(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, VendorControls.VendCancelBtn);
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
                _func.NavigateTo(_chromeDriver, LeftPanelControls.VenDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, VendorControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.New(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VendId);
                    ApplicationCommonFunction.ErrorMessageByClass(_chromeDriver);
                    _func.NavigateTo(_chromeDriver,VendorControls.VendSaveBtn);
                    ApplicationCommonFunction.Cancel(_chromeDriver, VendorControls.VendCancelBtn);
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
        public void EditVendor()
        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.VenDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, VendorControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VendorToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, VendorControls.VenCodeToggleFilterPath, VendorDetails.SearchedCodeValue, VendorControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, VendorControls.VenSearchedRow0);
                    _func.NavigateTo(_chromeDriver, VendorControls.VendEdit);
                    _func.WaitForElement(_chromeDriver, VendorControls.VendId);
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
        public void CreateVendorWA()
        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.VenDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, VendorControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VendorToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, VendorControls.VenCodeToggleFilterPath, VendorDetails.SearchedCodeValue, VendorControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, VendorControls.VenSearchedRow0);
                    _func.NavigateTo(_chromeDriver, VendorControls.VendEdit);
                    _func.WaitForElement(_chromeDriver, VendorControls.VendId);
                   _func.NavigateTo(_chromeDriver, VendorControls.VenAddress);
                    _func.NavigateTo(_chromeDriver, VendorControls.VenWAContactCard);
                    _func.WaitForElement(_chromeDriver, VendorControls.VWAContactId);
                    _vendorCF.CreateVendorAddressWA(_chromeDriver, VendorDetails.VenWAFN, VendorDetails.VenWALN, VendorDetails.VenWAIE);
                    _func.Save(_chromeDriver);
                    _func.SaveOk(_chromeDriver);
                    _func.Cancel(_chromeDriver, VendorControls.VenCancelBtn);
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
        public void CreateBusinessTermsVenSearch()

        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.VenDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, VendorControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VendorToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, VendorControls.VenCodeToggleFilterPath, VendorDetails.SearchedCodeValue, VendorControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, VendorControls.VenSearchedRow0);
                    _func.NavigateTo(_chromeDriver, VendorControls.VendEdit);
                    _func.WaitForElement(_chromeDriver, VendorControls.VendId);
                    _func.NavigateTo(_chromeDriver, VendorControls.VenBTTab);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VenBTEmptyRow);
                    _func.RightClickGrid(_chromeDriver, VendorControls.VenBTEmptyRow);
                    _func.NavigateTo(_chromeDriver, VendorControls.VenBTNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VenBTItem);
                    _vendorCF.CreateVendorBusinessTerms(_chromeDriver, VBusinessTerms.Code);
                    _func.NavigateTo(_chromeDriver, VendorControls.VenBTSavebtn);
                    _func.SaveOk(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, VendorControls.VenCancelBtn);



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
        public void CreateFinancialCalVenSearch()

        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.VenDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, VendorControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VendorToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, VendorControls.VenCodeToggleFilterPath, VendorDetails.SearchedCodeValue, VendorControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, VendorControls.VenSearchedRow0);
                    _func.NavigateTo(_chromeDriver, VendorControls.VendEdit);
                    _func.WaitForElement(_chromeDriver, VendorControls.VendId);
                    _func.NavigateTo(_chromeDriver, VendorControls.VenFCTab);
                   // ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VenFCEmptyRow);
                    _func.RightClickByXPath(_chromeDriver, VendorControls.VenFCEmptyRow);
                    _func.NavigateTo(_chromeDriver, VendorControls.VenFCNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VenFCId);
                    _vendorCF.CreateVendorFinancialCalendar(_chromeDriver, VFCDetails.Code);
                    _func.NavigateTo(_chromeDriver, VendorControls.VenFCSave);
                    _func.SaveOk(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, VendorControls.VenCancelBtn);



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
        public void CreateVenContactCusSearch()

        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.VenDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, VendorControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VendorToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, VendorControls.VenCodeToggleFilterPath, VendorDetails.SearchedCodeValue, VendorControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, VendorControls.VenSearchedRow0);
                    _func.NavigateTo(_chromeDriver, VendorControls.VendEdit);
                    _func.WaitForElement(_chromeDriver, VendorControls.VendId);
                    _func.NavigateTo(_chromeDriver, VendorControls.VenVCTab);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VCEmptyRow);
                    _func.RightClickGrid(_chromeDriver, VendorControls.VCEmptyRow);
                    _func.NavigateTo(_chromeDriver, VendorControls.VCNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VCId);
                    _vendorCF.CreateVendorContact(_chromeDriver, VenContactDetails.Code);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VCContactCardIcon);
                    _func.NavigateTo(_chromeDriver, VendorControls.VCContactCardIcon);
                    _vendorCF.CreateVendorContactContact(_chromeDriver, VenContactDetails.VCFN, VenContactDetails.VCLN, VenContactDetails.VCIE);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VCContactXIcon);
                    _func.NavigateTo(_chromeDriver, VendorControls.VCSaveIcn);
                    _func.SaveOk(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, VendorControls.VenCancelBtn);

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
        public void CreateVenDCLocationSearch()

        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.VenDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, VendorControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VendorToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, VendorControls.VenCodeToggleFilterPath, VendorDetails.SearchedCodeValue, VendorControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, VendorControls.VenSearchedRow0);
                    _func.NavigateTo(_chromeDriver, VendorControls.VendEdit);
                    _func.WaitForElement(_chromeDriver, VendorControls.VendId);
                    _func.NavigateTo(_chromeDriver, VendorControls.VenDCLocTab);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VDCEmptyRow);
                    _func.RightClickGrid(_chromeDriver, VendorControls.VDCEmptyRow);
                    _func.NavigateTo(_chromeDriver, VendorControls.VDCNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VDCId);
                    _vendorCF.CreateVendorDCLocation(_chromeDriver, VDCDetails.VDCCode);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VDCContactCardIcon);
                    _func.NavigateTo(_chromeDriver, VendorControls.VDCContactCardIcon);
                    _vendorCF.CreateVendorDCLocationContact(_chromeDriver, VDCDetails.VDCFN, VDCDetails.VDCLN, VDCDetails.VDCIE);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VDContactXIcon);
                    _func.NavigateTo(_chromeDriver, VendorControls.VDCSaveIcon);
                    _func.SaveOk(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, VendorControls.VenCancelBtn);
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
        public void CreateVenDocumentSearch()

        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.VenDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, VendorControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VendorToogleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, VendorControls.VenCodeToggleFilterPath, VendorDetails.SearchedCodeValue, VendorControls.FilterBoxChecked);
                    _func.RightClickByXPath(_chromeDriver, VendorControls.VenSearchedRow0);
                    _func.NavigateTo(_chromeDriver, VendorControls.VendEdit);
                    _func.WaitForElement(_chromeDriver, VendorControls.VendId);
                    _func.NavigateTo(_chromeDriver, VendorControls.VenDocTab);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VDocEmptyRow);
                    _func.RightClickGrid(_chromeDriver, VendorControls.VDocEmptyRow);
                    _func.NavigateTo(_chromeDriver, VendorControls.VDNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VDId);
                    _vendorCF.CreateVendorDocument(_chromeDriver, VDocumentDetails.VDCODE);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, VendorControls.VDSaveIcn);
                    _func.NavigateTo(_chromeDriver, VendorControls.VDSaveIcn);
                    _func.SaveOk(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, VendorControls.VenCancelBtn);
                    
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
