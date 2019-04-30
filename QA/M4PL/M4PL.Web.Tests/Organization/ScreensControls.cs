using M4PL.Web.Tests.Common;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support.UI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Organization
{
   public static class ScreensControls
    {
        //DataViewScreenControls

        public const string OrgId = "Id_I";
        public const string OrgItem = "OrgSortOrder_I";
        public const string OrgCode = "OrgCode_I";
        public const string OrgTitle = "OrgTitle_I";
        public const string OrgGroup = "OrgGroupId_I";
        public const string OrgGroupDrpdwn = "OrgGroupId_B-1";
        public const string OrgGrpbrokerage = "OrgGroupId_DDD_L_LBI1T0";
        public const string OrgStatus = "StatusId_I";
        public const string OrgImage = "OrgImage_DXButtonPanel_DXOpenDialogButton";
        public const string OrgSave = "btnOrganizationSave_CD";
        public const string OrgCancel = "btnOrganizationCancel_CD";
        public const string OrgSaveOk = "btnOk_CD";
        public const string UpdateOrgDetail = "btnOrganizationSave";
        public const string OrgUpdateOk = "btnOk_CD";
        public const string OrgNew = "OrganizationGridView_DXContextMenu_Rows_DXI0_T";
        public const string OrgEdit = "OrganizationGridView_DXContextMenu_Rows_DXI1_T";
        public const string OrgChooseColumn = "OrganizationGridView_DXContextMenu_Rows_DXI2_T";
        public const string OrgDesTab = "pageControl_AT0T";
        public const string OrgPOCTab = "pageControl_T1T";
        public const string OrgCredTab = "pageControl_T2T";
        public const string OrgRoleResTab = "pageControl_T3T";
        public const string ToogleFilterCode = "OrganizationGridView_DXFREditorcol2_I";
        public const string SearchedRow = "OrganizationGridView_DXDataRow0";

       // POC Tab

        public const string OrgPOCGrid = "OrgPocContactGridView_DXEmptyRow";
        public const string OrgPOCNew = "OrgPocContactGridView_DXContextMenu_Rows_DXI0_T";
        public const string OrgPOCEdit = "";
        public const string OrgPOCChooseColumn = "OrgPocContactGridView_DXContextMenu_Rows_DXI1_T";
        public const string OrgPOCId = "Id_popup_I";
        public const string OrgPOCItem = "PocSortOrder_popup_I";
        public const string OrgPOCCode = "PocCode_popup_I";
        public const string OrgPOCTitle = "PocTitle_popup_I";
        public const string OrgPOCContact = "ContactID_popup_I";
        public const string OrgPOCContactDrpDwn = "ContactID_popup_B-1";
        public const string OrgPOCContactCard = "btnContactID0_CD";
        public const string OrgPOCAddress = "ConBusinessAddress1ContactID0_popup_I";
        public const string OrgPOCDefault = "PocDefault_popup_S";
        public const string OrgPOCStatus = "StatusId_popup_I";
        public const string OrgStatusIcn = "StatusId_popup_B-1";
        public const string OrgPOCType = "PocTypeId_popup_I";
        public const string OrgPOCTypeIcn = "PocTypeId_popup_B-1";
        public const string OrgPOCSave = "OrganizationOrgPocContactDataView2POCContactCbPanelSecondNavigationPane_DXI1_T";
        public const string OrgPOCCancel = "OrganizationOrgPocContactDataView2POCContactCbPanelSecondNavigationPane_DXI0_T";
        public const string OrgPOCSaveOk = "btnOk";


        //POC ContactCard

        public const string POCConTitle = "ConTitleId_popupContact_I";
        public const string POCConFN = "ConFirstName_popupContact_I";
        public const string POCConMN = "ConMiddleName_popupContact_I";
        public const string POCConLN = "ConLastName_popupContact_I";
        public const string POCConJT = "ConJobTitle_popupContact_I";
        public const string POCConComp = "ConOrgId_popupContact_I";
        public const string POCConBussPhn = "ConBusinessPhone_popupContact_I";
        public const string POCConPhnExt = "ConBusinessPhoneExt_popupContact_I";
        public const string POCConMobPhn = "ConMobilePhone_popupContact_I";
        public const string POCConType = "ConTypeId_popup_I";
        public const string POCConWrkEml = "ConEmailAddress_popupContact_I";
        public const string POCConIndEml = "ConEmailAddress2_popupContact_I";
        public const string POCConBAL1 = "ConBusinessAddress1_popupContact_I";
        public const string POCConBAL2 = "ConBusinessAddress2_popupContact_I";
        public const string POCConBC = "ConBusinessCity_popupContact_I";
        public const string POCConBZP = "ConBusinessZipPostal_popupContact_I";
        public const string POCConBSP = "ConBusinessStateId_popup_I";
        public const string POCConBCR = "ConBusinessCountryId_popupContact_I";
        public const string POCConSaveIcn = "ContactIDCbPanelSecondNavigationPane_DXI1_T";
        public const string POCConCancelIcn = "ContactIDCbPanelSecondNavigationPane_DXI0_";
        public const string POCConAddNewIn = "ContactIDCbPanelSecondNavigationPane_DXI2_";


        //Credential Tab

        public const string OrgCredGrid = "OrgCredentialGridView_DXEmptyRow";
        public const string OrgCredNew = "OrgCredentialGridView_DXContextMenu_Rows_DXI0_T";
        public const string OrgCredEdit = "OrgCredentialGridView_DXContextMenu_Rows_DXI1_T";
        public const string OrgCredChooseColumn = "OrgCredentialGridView_DXContextMenu_Rows_DXI2_T";
        public const string OrgCredId = "Id_popup_I";
        public const string OrgCredItem = "CreItemNumber_popup_I";
        public const string OrgCredCode = "CreCode_popup_I";
        public const string OrgCredTitle = "CreTitle_popup_I";
        public const string OrgCredExpDate = "CreExpDate_popup_I";
        public const string OrgCredExpDateDrpDwn = "CreExpDate_popup_B-1";
        public const string OrgCredExpDateToday = "CreExpDate_popup_DDD_C_BT";
        public const string OrgCredStatus = "StatusId_popup_I";
        public const string OrgCredSave = "OrganizationOrgCredentialDataView3CredentialsCbPanelSecondNavigationPane_DXI1_T";
        public const string OrgCredCancel = "OrganizationOrgCredentialDataView3CredentialsCbPanelSecondNavigationPane_DXI0_T";
        public const string OrgCredSaveOk = "btnOk_CD";

        //Credentials Attachment Controls

        public const string OrgCredRowRightClk = "OrgCredentialGridView_DXDataRow0";
        public const string OrgCredAttchmentPanel = "pnlCreAttachment_HC";
        public const string OrgCredAttachmentNew= "AttachmentGridView_DXCBtn0";
        public const string OrgCredAttachmentBrowse = "ucAttFileName_TextBox0_Input";
        public const string OrgCredAttachmentDownloadIcn = "btnDownloadAttachmentGridViewcellnew_6_CD";
        public const string OrgCredAttachmentItem = "AttachmentGridView_DXEditor1_I";
        public const string OrgCredAttachmentTitle = "AttachmentGridView_DXEditor2_I";
        public const string OrgCredAttachmentDwnldDate = "AttachmentGridView_DXEditor4_I";
        public const string OrgCredAttachmentDwnldBy = "AttachmentGridView_DXEditor5_I";
        public const string OrgCredAttachmentSaveChanges = "btnSaveAttachmentGridView_CD";
        public const string OrgCredAttachmentCancelChanges = "btnCancelAttachmentGridView_CD";

        // Act Roles

        public const string OrgRREdit = "OrgRolesRespGridView_DXContextMenu_Rows_DXI0_T";
        public const string OrgRRChooseColumn = "OrgRolesRespGridView_DXContextMenu_Rows_DXI1_T";
        public const string OrgRRId = "Id_popup_I";
        public const string OrgRRItem = "OrgRoleSortOrder_popup_I";
        public const string OrgRRCode = "OrgRefRoleId_popup_I";
        public const string OrgRRTitle = "OrgRoleTitle_popup_I";
        public const string OrgRRType = "RoleTypeId_popup_I";
        public const string OrgRRDefault = "OrgRoleDefault_popup_S_D";
        public const string OrgRRContact = "OrgRoleContactID_popup_I";
        public const string OrgRRContactDrpdwn = "OrgRoleContactID_popup_B-1";
        public const string OrgRRContactCard = "btnOrgRoleContactID0_CD";
        public const string OrgRRBusinessPhn = "ConBusinessPhone_popupContact_I";
        public const string OrgRRBusinessWE = "ConEmailAddressOrgRoleContactID0_popup_I";
        public const string OrgRRStatus = "StatusId_popup_I";
        public const string OrgRROrgLog = "OrgLogical_popup_S_D";
        public const string OrgRRProgram = "PrgLogical_popup_S_D";
        public const string OrgRRProject = "PrjLogical_popup_S_D";
        public const string OrgRRPhase = "PhsLogical_popup_S_D";
        public const string OrgRRJob = "JobLogical_popup_S_D";
        public const string OrgRRContactDefault = "PrxContactDefault_popup_S_D";
        public const string OrgRRJobAnalyst = "PrxJobDefaultAnalyst_popup_S_D";
        public const string OrgRRJobResponsible = "PrxJobDefaultResponsible_popup_S_D";
        public const string OrgRRJobGWAnalyst = "PrxJobGWDefaultAnalyst_popup_S_D";
        public const string OrgJobGWResponsible = "PrxJobGWDefaultResponsible_popup_S_D";
        public const string OrgRRSave = "OrganizationOrgRolesRespDataView4RolesRespCbPanelSecondNavigationPane_DXI1_T";
        public const string OrgRRCancel = "OrganizationOrgRolesRespDataView4RolesRespCbPanelSecondNavigationPane_DXI0_T";
        public const string OrgRRSaveOk = "btnOk_CD";
        public const string OrgRRSearchedCode = "//td[contains(text(),'SYSADMN')]";
        public const string OrgRRRoleTypeAgent = "RoleTypeId_popup_DDD_L_LBI1T0";
        


       // Organization Ref Role Data View Screen

        public const string OrgRefRolDVS = "M4PLNavBar_I0i4_";
        public const string OrgRefRolNew = "OrgRefRoleGridView_DXContextMenu_Rows_DXI0_T";
        public const string OrgRefRolEdit = "OrgRefRoleGridView_DXContextMenu_Rows_DXI1_T";
        public const string OrgRefRolChooseColumn = "OrgRefRoleGridView_DXContextMenu_Rows_DXI2_T";
        public const string OrgRefRolDetail = "pageControl_AT0T";
        public const string OrgRefRolSecurity = "pageControl_T1T";
        public const string OrgRefRolId = "Id_I";
        public const string OrgRefRolItem = "OrgRoleSortOrder_I";
        public const string OrgRefRolCode = "OrgRoleCode_I";
        public const string OrgRefRolTitle = "OrgRoleTitle_I";
        public const string OrgRefRolDefault = "OrgRoleDefault";
        public const string OrgRefRolType = "RoleTypeId_I";
        public const string OrgRefRolTypeDrpdwn = "RoleTypeId_B-1";
        public const string OrgRefRoleTypeDriver = "RoleTypeId_DDD_L_LBI4T0";
        public const string OrgRefRolContact = "OrgRoleContactID_I";
        public const string OrgRefRolContactIcn = "OrgRoleContactID_B-1";
        public const string OrgRefRolContactCard = "btnOrgRoleContactID0_CD";
        public const string OrgRefRolBusinessPhn = "ConBusinessPhoneOrgRoleContactID0_I";
        public const string OrgRefRolWorkEml = "ConEmailAddressOrgRoleContactID0_I";
        public const string OrgRefRolOrg = "OrgLogical_S_D";
        public const string OrgRefRolProgram = "PrgLogical_S_D";
        public const string OrgRefRolProject = "PrjLogical_S_D";
        public const string OrgRefRolPhase = "PhsLogical_S_D";
        public const string OrgRefRolJob = "JobLogical_S_D";
        public const string OrgRefRolContactC = "PrxContactDefault_S_D";
        public const string OrgRefRolJobAnalyst = "PrxJobDefaultAnalyst_S_D";
        public const string OrgRefRolJobResponsible = "PrxJobDefaultResponsible_S_D";
        public const string OrgRefRolJobGWAnalyst = "PrxJobGWDefaultAnalyst_S_D";
        public const string OrgRefRolJobGWResponsible = "PrxJobGWDefaultResponsible_S_D";
        public const string OrgRefRolSave = "btnOrgRefRoleSave_CD";
        public const string OrgRefRolCancel = "btnOrgRefRoleCancel_CD";
        public const string OrgRefRolSaveOk = "btnOk_CD";
        public const string OrgRefRolUpdate = "btnOk_CD";

      
        public const string OrgRefRolSecNew = "SecurityByRoleGridView_DXCBtn0";
        public const string OrgRefRolToggleFilterCode = "OrgRefRoleGridView_DXFREditorcol2_I";
        public const string OrgRefRolToggleFilterSearchCode = "";
        public const string OrgRefRolToggleFilterRow = "OrgRefRoleGridView_DXDataRow0";
        public const string SecModuleClick = "SecurityByRoleGridView_DXDataRow-1";

        //Ref Roles Contact Card

        public const string OrgRRConTitle = "ConTitleId_popupContact_I";
        public const string OrgRRConFN = "ConFirstName_popupContact_I";
        public const string OrgRRConMN = "ConMiddleName_popupContact_I";
        public const string OrgRRConLN = "ConLastName_popupContact_I";
        public const string OrgRRConJT = "ConJobTitle_popupContact_I";
        public const string OrgRRConComp = "ConOrgId_popupContact_I";
        public const string OrgRRConBussPhn = "ConBusinessPhone_popupContact_I";
        public const string OrgRRConPhnExt = "ConBusinessPhoneExt_popupContact_I";
        public const string OrgRRConMobPhn = "ConMobilePhone_popupContact_I";
        public const string OrgRRConType = "ConTypeId_popup_I";
        public const string OrgRRConWrkEml = "ConEmailAddress_popupContact_I";
        public const string OrgRRConIndEml = "ConEmailAddress2_popupContact_I";
        public const string OrgRRConBAL1 = "ConBusinessAddress1_popupContact_I";
        public const string OrgRRConBAL2 = "ConBusinessAddress2_popupContact_I";
        public const string OrgRRConBC = "ConBusinessCity_popupContact_I";
        public const string OrgRRConBZP = "ConBusinessZipPostal_popupContact_I";
        public const string OrgRRConBSP = "ConBusinessStateId_popup_I";
        public const string OrgRRConBCR = "ConBusinessCountryId_popupContact_I";
        public const string OrgRRConSaveIcn = "OrgRoleContactIDCbPanelSecondNavigationPane_DXI1_";
        public const string OrgRRConCancelIcn = "OrgRoleContactIDCbPanelSecondNavigationPane_DXI0_T";
        public const string OrgRRConAddNewIn = "OrgRoleContactIDCbPanelSecondNavigationPane_DXI2_T";



        public const string OrgRRSecModuletxtId = "SecurityByRoleGridView_DXEditor2_I";
        public const string OrgRRSecModuleDrpdwn = "SecurityByRoleGridView_DXEditor2_B-1";
        public const string OrgRRSecOptionLeveltxtId = "OrgActSecurityByRoleGridView_DXEditor3_I";
        public const string OrgRRSecOptionLevelDrpdwn = "SecurityByRoleGridView_DXBEC3";
        public const string OrgRRSecAccessLeveltxtId = "OrgActSecurityByRoleGridView_DXEditor4_I";
        public const string OrgRRSecAccessLevelDrpdwn = "OrgActSecurityByRoleGridView_DXEditor5_I";
        public const string OrgRRSecStatustxtId = "SecurityByRoleGridView_DXEditor5_I";
        public const string OrgRRSecStatusDrpdwn = "SecurityByRoleGridView_DXEditor5_B-1";
        public const string OrgRRSecModuleOpJobOp = "SecurityByRoleGridView_DXEditor2_DDD_L_LBI6T0";
        public const string OrgRRSecOptionNoRights = "SecurityByRoleGridView_DXEditor3_DDD_L_LBI0T0";
        public const string OrgRRSecAccessNo = "SecurityByRoleGridView_DXEditor4_DDD_L_LBI0T0";
        public const string OrgRRSecStatusActive = "SecurityByRoleGridView_DXEditor5_DDD_L_LBI0T0";
        public const string OrgRRSecSaveChanges = "btnSaveSecurityByRoleGridView";
        public const string OrgRRSecCancelChanges = "btnCancelSecurityByRoleGridView";
        public const string OrgRRSecOutsideRow = "pageControl_TC";

        //Org Act Role Data View Screen

        public const string OrgActRolDVS = "M4PLNavBar_I0i3_";

        public const string OrgActRolEdit = "OrgActRoleGridView_DXContextMenu_Rows_DXI0_T";
        public const string OrgActRolChooseColumn = "OrgActRoleGridView_DXContextMenu_Rows_DXI1_T";
        public const string OrgActRolDetail = "pageControl_AT0T";
        public const string OrgActRolSecurity = "pageControl_T1T";
        public const string OrgActRolId = "Id_I";
        public const string OrgActRolItem = "OrgRoleSortOrder_I";
        public const string OrgActRolCode = "OrgRefRoleId_I";
        public const string OrgActRolTitle = "OrgRoleTitle_I";
        public const string OrgActRolDefault = "OrgRoleDefault_S_D";
        public const string OrgActRolType = "RoleTypeId_I";
        public const string OrgActRolTypeDrpdwn = "RoleTypeId_B-1";
        public const string OrgActRolContact = "OrgRoleContactID_I";
        public const string OrgActRolContactIcn = "OrgRoleContactID_B-1";
        public const string OrgActRolContactCard = "btnOrgRoleContactID565_CD";
        public const string OrgActRolBusinessPhn = "ConBusinessPhoneOrgRoleContactID0_I";
        public const string OrgActRolWorkEml = "ConEmailAddressOrgRoleContactID0_I";
        public const string OrgActRolStatus = "StatusId_I";
        public const string OrgActRolOrgLgc = "OrgLogical_S_D";
        public const string OrgActRolProgram = "PrgLogical_S_D";
        public const string OrgActRolProject = "PrjLogical_S";
        public const string OrgActRolPhase = "PhsLogical_S_D";
        public const string OrgActRolJob = "JobLogical_S_D";
        public const string OrgActRolContactDefault = "PrxContactDefault_S_D";
        public const string OrgActRolJobAnalyst = "PrxJobDefaultAnalyst_S_D";
        public const string OrgActRolJobResponsible = "PrxJobDefaultResponsible_S_D";
        public const string OrgActRolJobGWAnalyst = "PrxJobGWDefaultAnalyst_S_D";
        public const string OrgActRolJobGWResponsible = "PrxJobGWDefaultResponsible_S_D";
        public const string OrgActRolUpdate = "btnOrgActRoleSave";
        public const string OrgActRolCancel = "btnOrgActRoleCancel";
        public const string OrgActRolSaveOk = "btnOk_CD";
        public const string OrgActRolTypConsultant = "RoleTypeId_DDD_L_LBI2T0";

        public const string OrgActRolSecNew = "OrgActSecurityByRoleGridView_DXCBtn0";
        public const string OrgActRolCodeToggleDrpdwnIcn = "OrgRefRoleId_B-1";
        public const string OrgActRolCodeSysadmn = "OrgRefRoleId_DDD_L_LBI13T0";
        public const string OrgActRolCodSearchedRow = "OrgActRoleGridView_DXDataRow0";

        public const string OrgActRolSecMainMod = "OrgActSecurityByRoleGridView_DXDataRow-1";
        public const string OrgARSecMainModuletxtId = "OrgActSecurityByRoleGridView_DXEditor3_I";
        public const string OrgARSecMainModuleDrpdwn = "OrgActSecurityByRoleGridView_DXEditor3_B-1";
        public const string OrgARSecMenuOptionLeveltxtId = "OrgActSecurityByRoleGridView_DXEditor4_I";
        public const string OrgARSecMenuOptionLevelDrpdwn = "OrgActSecurityByRoleGridView_DXEditor4_B-1";
        public const string OrgARSecMenuAccessLeveltxtId = "OrgActSecurityByRoleGridView_DXEditor5_I";
        public const string OrgARSecMenuAccessLevelDrpdwn = "OrgActSecurityByRoleGridView_DXEditor5_B-1";
        public const string OrgARSecStatustxtId = "OrgActSecurityByRoleGridView_DXEditor6_I";
        public const string OrgARSecStatusDrpdwn = "OrgActSecurityByRoleGridView_DXEditor6_B-1";
        
        public const string OrgActRolSecSave = "btnSaveOrgActSecurityByRoleGridView";
        public const string OrgActRolSecCancel = "btnCancelOrgActSecurityByRoleGridView";


        public static void updateOrgDetail(ChromeDriver driver)
        {
            driver.FindElementById(UpdateOrgDetail).Click();
            Thread.Sleep(5000);
            driver.FindElementById(OrgUpdateOk).Click();
            Thread.Sleep(3000);
        }

        public static void CancelOrgDetail(ChromeDriver driver)
        {
            driver.FindElementById(OrgCancel);
            Thread.Sleep(5000);
        }
    }
}
