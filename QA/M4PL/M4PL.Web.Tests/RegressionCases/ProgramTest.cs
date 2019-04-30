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
using M4PL.Web.Tests.Controls;
using M4PL.Web.Tests.Common_Functions;
using M4PL.Web.Tests.ResourceFile;

namespace M4PL.Web.Tests.RegressionCases
{
    [TestClass]
    public class ProgramTest

    {
        LoginControls _loginControls;
        CustomerControls _customerControls;
        ChromeDriver _chromeDriver;
        ApplicationCommonFunction _applicationCF;
        ProgramCF _programCF;


        public ProgramTest()
        {
            _loginControls = new LoginControls();
            _customerControls = new CustomerControls();
            _applicationCF = new ApplicationCommonFunction();
            _chromeDriver = ApplicationCommonFunction.OpenChromeWindow();
            _programCF = new ProgramCF();
        }


        [TestMethod]
        public void CreateProgram()
        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.PrgDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgNewBtn))
                {
                    ProgramCF.CustomerSearch(_chromeDriver, ProgramControls.SearchedCustomer);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgNewBtn);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgID);
                    ProgramCF.CreateProgram(_chromeDriver, ProgramDetails.ProgramCode);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgSave);
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
        public void VerificationOfErrrorMessage()
        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.PrgDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgNewBtn))
                {
                    ProgramCF.CustomerSearch(_chromeDriver, ProgramControls.SearchedCustomer);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgNewBtn);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgID);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgSave);
                    ApplicationCommonFunction.ErrorMessageByClass(_chromeDriver);
                    _func.NavigateTo(_chromeDriver,ProgramControls.PrgCancel);
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
        public void CreateProgramGtwy()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.PrgDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgNewBtn))
                {
                    ApplicationCommonFunction.DoubleClick(_chromeDriver, ProgramControls.SearchedCustomer);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgID);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgGateways);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgGtwGrid);
                    ApplicationCommonFunction.RightClickGrid(_chromeDriver, ProgramControls.PrgGtwGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgGtwNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgGtwId);
                    ProgramCF.CreateGateway(_chromeDriver, ProgramDetails.PrgGtwCode, ProgramDetails.PrgGtwTitle, ProgramDetails.PrgGtwDuration);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgGtwSave);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgGtwSaveOk);
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
        public void CreateProgramReasonCode()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.PrgDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgNewBtn))
                {
                    ApplicationCommonFunction.DoubleClick(_chromeDriver, ProgramControls.SearchedCustomer);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgID);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgRsnCode);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgRCGrid);
                    ApplicationCommonFunction.RightClickGrid(_chromeDriver, ProgramControls.PrgRCGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgRCNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgRCId);
                    ProgramCF.CreateReasonCode(_chromeDriver, ProgramDetails.ReasonCode);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgRCSave);
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
        public void CreateProgramAppointmentCode()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.PrgDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgNewBtn))
                {
                    ApplicationCommonFunction.DoubleClick(_chromeDriver, ProgramControls.SearchedCustomer);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgID);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgApptCode);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgACGrid);
                    ApplicationCommonFunction.RightClickGrid(_chromeDriver, ProgramControls.PrgACGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgACNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgACId);
                    ProgramCF.CreateApptRsnCode(_chromeDriver, ProgramDetails.ApptCode);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgACSave);
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
        public void CreateProgramAttribute()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.PrgDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgNewBtn))
                {
                    ApplicationCommonFunction.DoubleClick(_chromeDriver, ProgramControls.SearchedCustomer);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgID);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgAttribute);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgAttGrid);
                    ApplicationCommonFunction.RightClickGrid(_chromeDriver, ProgramControls.PrgAttGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgAttNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgAttId);
                    ProgramCF.CreateAttribute(_chromeDriver, ProgramDetails.AttCode, ProgramDetails.AttQty);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgAttSave);
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
        public void CreateCustomerJourney()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.PrgDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgNewBtn))
                {
                    ApplicationCommonFunction.DoubleClick(_chromeDriver, ProgramControls.SearchedCustomer);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgID);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgCustJourney);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgMVOCGrid);
                    ApplicationCommonFunction.RightClickGrid(_chromeDriver, ProgramControls.PrgMVOCGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgMVOCNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgMVOCId);
                    ProgramCF.CreateCJ(_chromeDriver, ProgramDetails.CJCode, ProgramDetails.CJTitle);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgMVOCSave);
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
        public void ProgramMapVendor()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.PrgDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgNewBtn))
                {
                    ApplicationCommonFunction.DoubleClick(_chromeDriver, ProgramControls.SearchedCustomer);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgID);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgVendors);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgVendorGrid);
                    ApplicationCommonFunction.RightClickGrid(_chromeDriver, ProgramControls.PrgVendorGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgVendorMap);
                    //ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgVendorMapAssign);
                    ProgramCF.MapVendor(_chromeDriver, ProgramControls.PrgVendorMapAssign, ProgramControls.SearchedVendor);
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
        public void CreateProject()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.PrgDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.PrgNewBtn))
                {
                    ApplicationCommonFunction.DoubleClick(_chromeDriver, ProgramControls.SearchedCustomer);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.SearchedProgram);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, ProgramControls.ProjectCode);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, ProgramControls.PrgNewBtn);
                    ProgramCF.CreateProject(_chromeDriver, ProgramDetails.ProjectCode);
                    ApplicationCommonFunction.Save(_chromeDriver);
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
