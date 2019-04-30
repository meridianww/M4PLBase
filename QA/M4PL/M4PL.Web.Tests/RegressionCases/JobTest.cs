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
    public class JobTest
    {
        LoginControls _loginControls;
        JobControls _jobControls;
        ChromeDriver _chromeDriver;
        ApplicationCommonFunction _applicationCF;
        JobsCF _jobsCF;
        ProgramCF _programCF;


        public JobTest()
        {
            _loginControls = new LoginControls();
            _jobControls = new JobControls();
            _applicationCF = new ApplicationCommonFunction();
            _chromeDriver = ApplicationCommonFunction.OpenChromeWindow();
            _jobsCF = new JobsCF();
            _programCF = new ProgramCF();
        }

        [TestMethod]
        public void CreateJob()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.JbsDVS);
                //Thread.Sleep(1000);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobTree))
                {

                    //ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobCust);
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobCusCodeArrow);
                    //ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobSearchPrg);
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobSearchPrg);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.New);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobId);
                    JobsCF.CreateJob(_chromeDriver, JobDetails.CustomerSalesOrder);
                    _func.Save(_chromeDriver);
                    _func.SaveOk(_chromeDriver);
                    _func.Cancel(_chromeDriver, JobControls.JobCancelbtn);

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
                _func.NavigateTo(_chromeDriver, LeftPanelControls.JbsDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobTree))
                {
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobCusCodeArrow);
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobSearchPrg);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.New);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobId);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.JobSave);
                    ApplicationCommonFunction.ErrorMessageByClass(_chromeDriver);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.JobCancelbtn);
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
        public void EditJobDetails()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.JbsDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobTree))
                {
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobCusCodeArrow);
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobSearchPrg);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.ToggleFilter);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.ToggleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, JobControls.CSOToggle, JobDetails.CSOSearch, JobControls.SearchedRow);
                    //ApplicationCommonFunction.RightClickGrid(_chromeDriver, JobControls.SearchedRow);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.FormViewBtn);
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
        public void JobDetailsUpdate()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.JbsDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobTree))
                {
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobCusCodeArrow);
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobSearchPrg);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.ToggleFilter);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.ToggleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, JobControls.CSOToggle, JobDetails.CSOSearch, JobControls.SearchedRow);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.FormViewBtn);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobId);
                    JobsCF.CustomerPurchaseOrder(_chromeDriver, JobDetails.CustomerPurchaseOrder);
                    JobsCF.PlantCode(_chromeDriver, JobDetails.PlantCode);
                    _func.Save(_chromeDriver);
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
        public void JobUserDefineOption()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.JbsDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobTree))
                {
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobCusCodeArrow);
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobSearchPrg);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.ToggleFilter);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.ToggleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, JobControls.CSOToggle, JobDetails.CSOSearch, JobControls.SearchedRow);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.FormViewBtn);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobId);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.UserDefinePanel);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.UD1);
                    JobsCF.UD2(_chromeDriver, JobDetails.UD2);
                    JobsCF.UD5(_chromeDriver, JobDetails.UD5);
                    _func.Save(_chromeDriver);
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
        public void JobGateway()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.JbsDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobTree))
                {
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobCusCodeArrow);
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobSearchPrg);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.ToggleFilter);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.ToggleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, JobControls.CSOToggle, JobDetails.CSOSearch, JobControls.SearchedRow);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.FormViewBtn);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobId);
                   // ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.JobGateways);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobGtwGatewayAllSelectedTab);
                   ApplicationCommonFunction.RightClickByXPath(_chromeDriver, JobControls.JobGatewaysAllEmpty);
                    
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
        public void JobCargo()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.JbsDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobTree))
                {
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobCusCodeArrow);
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobSearchPrg);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.ToggleFilter);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.ToggleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, JobControls.CSOToggle, JobDetails.CSOSearch, JobControls.SearchedRow);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.FormViewBtn);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobId);
                     ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.JobCargo);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JbCargoSelectedTab);
                    ApplicationCommonFunction.RightClickByXPath(_chromeDriver, JobControls.JobCargoGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.JobCargoNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.CargoId);
                    JobsCF.CreateJobCargo(_chromeDriver, JobDetails.NumberCode);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.JobCargoSave);
                    ApplicationCommonFunction.SaveOk(_chromeDriver);
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
        public void JobDocument()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.JbsDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobTree))
                {
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobCusCodeArrow);
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobSearchPrg);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.ToggleFilter);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.ToggleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, JobControls.CSOToggle, JobDetails.CSOSearch, JobControls.SearchedRow);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.FormViewBtn);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobId);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.JobDocument);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobDocByCategorySelected);
                    ApplicationCommonFunction.RightClickByXPath(_chromeDriver, JobControls.JobDocByCategoryGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.JobDocByCategoryNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.CargoId);
                    JobsCF.CreateDocument(_chromeDriver, JobDetails.DocCode);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.JobDocByCategorySave);
                    ApplicationCommonFunction.SaveOk(_chromeDriver);
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
        public void JobAttribute()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.JbsDVS);
                if (ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobTree))
                {
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobCusCodeArrow);
                    ApplicationCommonFunction.NavigateToXpath(_chromeDriver, JobControls.JobSearchPrg);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobGrid);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.ToggleFilter);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.ToggleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, JobControls.CSOToggle, JobDetails.CSOSearch, JobControls.SearchedRow);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, RibbonControls.FormViewBtn);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobId);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.JobDestinationPanel);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobDestinationTabSelected);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.JobAttributes);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.JobAttrbuteColumn0);
                    ApplicationCommonFunction.RightClickByXPath(_chromeDriver, JobControls.JobAttrbuteGridEmpty);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.JobAttrbuteNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, JobControls.AttId);
                    JobsCF.CreateJobAttribute(_chromeDriver, JobDetails.AttributeCode, JobDetails.AttributeQty);
                    ApplicationCommonFunction.NavigateTo(_chromeDriver, JobControls.JobAttrbuteSave);
                    ApplicationCommonFunction.SaveOk(_chromeDriver);
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