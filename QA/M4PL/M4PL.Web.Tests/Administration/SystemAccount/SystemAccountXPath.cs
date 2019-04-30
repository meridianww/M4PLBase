using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Web.Tests.Administration.SystemAccount
{
    public class SystemAccountXPath
    {
       public const string SysAccGrid_Record = "SystemAccountGridView_DXDataRow0";
       public const string SysAccNew = "SystemAccountGridView_DXContextMenu_Rows_DXI0_T";
       public const string SysAccEdit = "SystemAccountGridView_DXContextMenu_Rows_DXI1_T";
       public const string SysAccChooseColumn = "SystemAccountGridView_DXContextMenu_Rows_DXI2_T";
       public const string SysAccId = "Id_I";
       public const string SysAccScreenName = "SysScreenName_I";
       public const string SysAccContact = "SysUserContactID_I";
       public const string SysAccContactDrpdwn = "SysUserContactID_B-1";
       public const string SysAccContactCard = "btnSysUserContactID0_CD";
       public const string SysAccPassword = "txtSysPassword";
       public const string SysAccPasswordShow = "btnPassword_I";
       public const string SysAccRoleCode = "SysOrgRefRoleId_I";
       public const string SysAccRoleCodeDrpdwn = "SysOrgRefRoleId_B-1";
       public const string SysAccStatus = "StatusId_I";
       public const string SysAccStatusDrpdwn = "StatusId_B-1";
       public const string SysAccStatusActive = "StatusId_DDD_L_LBI0T0";
       public const string SysAccStatusInactive = "StatusId_DDD_L_LBI1T0";
       public const string SysAccStatusArchive = "StatusId_DDD_L_LBI2T0";
       public const string SysAccAttempts = "SysAttempts_I";
       public const string SysAccAttemptRefresh = "btnAttempts_CD";
       public const string SysAccSysAdmn = "IsSysAdmin_S_D";
       public const string SysAccSave = "btnSystemAccountSave";
        public const string SysAccSaveOk = "btnOk_CD";
        public const string SysAccCancel = "btnSystemAccountCancel";
        public const string SysAccUpdate = "btnSystemAccountSave";
        public const string RoleCodePOC = "SysOrgRefRoleId_DDD_L_LBI0T0";
        public const string ToggleFilterContact = "SysUserContactID_I";
        public const string ContactSearchedNameRow = "SysUserContactID_DDD_L_LBI0T0";
       

        //Contact Card Controls

        public const string SysAccConTitle = "ConTitleId_popupContact_I";
        public const string SysAccConFN = "ConFirstName_popupContact_I";
        public const string SysAccConMN = "ConMiddleName_popupContact_I";
        public const string SysAccConLN = "ConLastName_popupContact_I";
        public const string SysAccConJT = "ConJobTitle_popupContact_I";
        public const string SysAccConComp = "ConOrgId_popupContact_I";
        public const string SysAccConBussPhn = "ConBusinessPhone_popupContact_I";
        public const string SysAccConPhnExt = "ConBusinessPhoneExt_popupContact_I";
        public const string SysAccConMobPhn = "ConMobilePhone_popupContact_I";
        public const string SysAccConType = "ConTypeId_popup_I";
        public const string SysAccConWrkEml = "ConEmailAddress_popupContact_I";
        public const string SysAccConIndEml = "ConEmailAddress2_popupContact_I";
        public const string SysAccConBAL1 = "ConBusinessAddress1_popupContact_I";
        public const string SysAccConBAL2 = "ConBusinessAddress2_popupContact_I";
        public const string SysAccConBC = "ConBusinessCity_popupContact_I";
        public const string SysAccConBZP = "ConBusinessZipPostal_popupContact_I";
        public const string SysAccConBSP = "ConBusinessStateId_popup_I";
        public const string SysAccConBCR = "ConBusinessCountryId_popupContact_I";
        public const string SysAccConSaveIcn = "SysUserContactIDCbPanelSecondNavigationPane_DXI1_T";
        public const string SysAccConCancelIcn = "SysUserContactIDCbPanelSecondNavigationPane_DXI0_T";
        public const string SysAccConAddNewIn = "SysUserContactIDCbPanelSecondNavigationPane_DXI2_T";

        //Searched Contact Row
        public const string SearchedContact = "SysUserContactID_DDD_L_LBI0T0";
    }
}
