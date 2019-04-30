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
    public class OrganizationTest

    {
        LoginControls _loginControls;
        OrganizationControls _organizationControls;
        ChromeDriver _chromeDriver;
        ApplicationCommonFunction _applicationLogin;
        OrganizationCF _orgCF;


        public OrganizationTest()
        {
            _loginControls = new LoginControls();
            _organizationControls = new OrganizationControls();
            _applicationLogin = new ApplicationCommonFunction();
            _chromeDriver = ApplicationCommonFunction.OpenChromeWindow();
            _orgCF = new OrganizationCF();
        }


        [TestMethod]
        public void OrganizationPOCCreate()
        {
            try
            {


                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.OrgDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, OrganizationControls.GridFocusedRowClass))
                {
                    _func.FormView(_chromeDriver);
                    _func.NavigateTo(_chromeDriver, OrganizationControls.OrgPOCTab);
                   _func.RightClickGrid(_chromeDriver, OrganizationControls.OrgPOCGridEmptyRow);
                    _func.NavigateTo(_chromeDriver, OrganizationControls.OrgPOCNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, OrganizationControls.OrgPOCId);
                    OrganizationCF.createPOC(POCDetails.Code, POCDetails.Title, _chromeDriver);
                    ApplicationCommonFunction.SaveIcn(_chromeDriver, OrganizationControls.OrgPOCSave);
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

        public void OrganizationCredCreate()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.OrgDVS);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, OrganizationControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.FormView(_chromeDriver);
                    _func.NavigateTo(_chromeDriver, OrganizationControls.OrgCredTab);
                    _func.RightClickGrid(_chromeDriver, OrganizationControls.OrgCredGridEmptyRow);
                    _func.NavigateTo(_chromeDriver, OrganizationControls.OrgCredNew);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, OrganizationControls.OrgCredId);
                    OrganizationCF.createCred(OrgCredentialDetails.Code, OrgCredentialDetails.Title, _chromeDriver);
                    ApplicationCommonFunction.SaveIcn(_chromeDriver, OrganizationControls.OrgCredSave);
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
        public void OrganizationRefRole()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.OrgRefRole);
                if(ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, OrganizationControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.New(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, OrganizationControls.OrgRefRolId);
                    OrganizationCF.createRefRole(RefRoleDetails.Code,RefRoleDetails.Title, _chromeDriver);
                    ApplicationCommonFunction.SaveIcn(_chromeDriver, OrganizationControls.OrgRefRolSave);
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
        public void VerificationErrorMessageRefRole()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.OrgRefRole);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, OrganizationControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.New(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, OrganizationControls.OrgRefRolId);
                   ApplicationCommonFunction.SaveIcn(_chromeDriver, OrganizationControls.OrgRefRolSave);
                    ApplicationCommonFunction.ErrorMessageByClass(_chromeDriver);
                    ApplicationCommonFunction.Cancel(_chromeDriver, OrganizationControls.OrgRefRolCancel);
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
        public void EditOrgRefRole()
        {
            try
            {
                ApplicationCommonFunction.Login(M4PLResources.Username, M4PLResources.Password, _chromeDriver, _loginControls);
                _func.NavigateTo(_chromeDriver, LeftPanelControls.OrgRefRole);
                if (ApplicationCommonFunction.WaitForElementByClass(_chromeDriver, OrganizationControls.GridFocusedRowClass))
                {
                    _chromeDriver.Navigate().Refresh();
                    _func.ToggleFilter(_chromeDriver);
                    ApplicationCommonFunction.WaitForElement(_chromeDriver, OrganizationControls.OrgRefRolToggleFilterRow);
                    ApplicationCommonFunction.ToggleSearch(_chromeDriver, OrganizationControls.OrgRefRoleCodeSearch, RefRoleDetails.SearchedCode, OrganizationControls.FilterBoxChecked);
                    _func.RightClickGrid(_chromeDriver, OrganizationControls.OrgRefRolToggleFilterRow0);
                    _func.NavigateTo(_chromeDriver, OrganizationControls.OrgRefRolEdit);
                        _func.WaitForElement(_chromeDriver, OrganizationControls.OrgRefRolId);
                        OrganizationCF.ContactCardRefRol(_chromeDriver, OrganizationControls.OrgRefRolContactCard, OrganizationControls.OrgRRConTitle, RefRoleDetails.fName, RefRoleDetails.lName, RefRoleDetails.indEmail);
                        _func.NavigateTo(_chromeDriver, OrganizationControls.OrgRRConSaveIcn);
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
    }
}

