#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/13/2017
//Program Name:                                 FormViewProvider
//Purpose:                                      Methods and properties related to FormViewProvider
//====================================================================================================================================================*/

using M4PL.APIClient.ViewModels;
using M4PL.Entities;
using M4PL.Utilities;
using M4PL.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.Web.Providers
{
    public static class FormViewProvider
    {
        public static Dictionary<EntitiesAlias, string[]> ComboBoxColumns
        {
            get
            {
                //Note: Id and Lookup should be on 1st and 2nd order
                return new Dictionary<EntitiesAlias, string[]> {
                    { EntitiesAlias.MenuDriver, new string[] { "Id", "MnuTitle","MnuBreakdownStructure" } },
                    { EntitiesAlias.Contact, new string[] { "Id", "ConFullName", "ConJobTitle", "ConFileAs" } },
                    { EntitiesAlias.Organization, new string[] { "Id", "OrgCode", "OrgTitle" } },
                    { EntitiesAlias.Customer, new string[] { "Id", "CustCode", "CustTitle" } },
                  //  { EntitiesAlias.SecurityByRole, new string[] { "Id", "RoleCode", "SecLineOrder" } },
                    { EntitiesAlias.Program, new string[] { "Id", "PrgCustomerCode", "PrgProgramCode" } },
                    { EntitiesAlias.Job, new string[] { "Id", "JobSiteCode", "JobConsigneeCode" } },
                    { EntitiesAlias.VendDcLocation, new string[] { "Id", "VdcItemNumber", "VdcLocationCode" } },
                    { EntitiesAlias.PrgVendLocation, new string[] { "Id", "PvlItemNumber","PvlLocationCode" } },
                    { EntitiesAlias.PrgVendLocationCodeLookup, new string[] { "Id", "PvlLocationCode" } },
                    { EntitiesAlias.Vendor, new string[] { "Id", "VendCode" } },
                    { EntitiesAlias.TableReference, new string[] { "TblLangName", "SysRefName" } },
                    { EntitiesAlias.Validation, new string[] { "RefName" } },
                    { EntitiesAlias.State, new string[] { "Id", "StateAbbr", "StateName" } },
                    { EntitiesAlias.SystemReference, new string[] { "Id", "SysLookupId", "SysLookupCode", "SysOptionName", "SysDefault" } },
                    { EntitiesAlias.ColumnAlias, new string[] { "Id", "ColColumnName", "ColAliasName", "ColCaption",  "ColLookupId","ColLookupCode" } },
                    { EntitiesAlias.Report, new string[] { "Id", "RprtName", "RprtIsDefault" } },
                    { EntitiesAlias.AppDashboard, new string[] { "Id", "DshName", "DshIsDefault" } },
                    { EntitiesAlias.OrgRole, new string[] { "Id", "OrgRoleCode", "OrgRoleTitle" } },
                    { EntitiesAlias.OrgRefRole, new string[] { "Id", "OrgRoleCode", "OrgRoleTitle" } },
                    { EntitiesAlias.PrgRefRole, new string[] { "Id", "OrgRoleCode", "OrgRoleTitle" } },
                    { EntitiesAlias.ProgramRole, new string[] { "Id", "PrgRoleCode", "PrgRoleTitle" } },
                    { EntitiesAlias.ProgramContact, new string[] { "Id", "ConFullName", "ConJobTitle", "ConOrgIdName", "ConFileAs" } },
                    { EntitiesAlias.MenuSystemReference, new string[] { "Id","SysOptionName" } },
                    { EntitiesAlias.PrgShipApptmtReasonCode, new string[] { "Id", "PacApptReasonCode", "PacApptTitle" } },
                    { EntitiesAlias.PrgShipStatusReasonCode, new string[] { "Id", "PscShipReasonCode", "PscShipTitle" } },
                    { EntitiesAlias.Company, new string[] { "Id", "CompTitle", "CompCode", "CompTableName" } },
                    { EntitiesAlias.EdiColumnAlias, new string[] { "Id", "ColColumnName", "ColAliasName"} },
                    { EntitiesAlias.VOCCustLocation, new string[] { "Id", "LocationCode" } },
                    { EntitiesAlias.RollUpBillingJob, new string[] { "Id", "ColAliasName", "ColColumnName" } },
                    { EntitiesAlias.JobAdvanceReport, new string[] { "Id", "ProgramIdCode" } },
                    { EntitiesAlias.Scheduled, new string[] { "Id", "Schedule" } },
                    { EntitiesAlias.OrderType, new string[] { "Id", "OrderType" } },
                    { EntitiesAlias.JobStatusId, new string[] { "Id", "JobStatusId" } },
                    { EntitiesAlias.JobCargo, new string[] { "Id", "CgoPartNumCode","CgoTitle","CgoSerialNumber" } },
                    { EntitiesAlias.GwyExceptionCode, new string[] { "Id", "JgeTitle", "JgeReasonCode" } },
                    { EntitiesAlias.GwyExceptionStatusCode, new string[] { "Id", "ExStatusDescription" } },
                    { EntitiesAlias.PrgRefGatewayDefault, new string[] { "Id", "PgdGatewayCode" } },
                    { EntitiesAlias.EventType, new string[] { "Id", "EventName", "EventDisplayName" } },
                };
            }
        }

        public static Dictionary<EntitiesAlias, string[]> ComboBoxSelectedFields
        {
            get
            {
                //Note: Id and Lookup should be on 1st and 2nd order
                return new Dictionary<EntitiesAlias, string[]> {
                    {
                        EntitiesAlias.EDISummaryHeader, new string[]
                        {
                            "eshBillToAltContEmail",
                            "eshBillToContactEmail",
                            "eshConsigneeAltContEmail",
                            "eshConsigneeContactEmail",
                            "eshCustomerReferenceNo",
                            "eshInterConsigneeAltContEmail",
                            "eshInterConsigneeContactEmail",
                            "eshLocationId" ,
                            "eshLocationNumber" ,
                            "eshProductType",
                            "eshShipDescription",
                            "eshShipFromAltContEmail",
                            "eshShipFromCity ",
                            "eshShipFromContactEmail"
                        } 
                    },
                };
            }
        }

        public static Dictionary<EntitiesAlias, string[]> ComboBoxColumnsExtension
        {
            get
            {
                return new Dictionary<EntitiesAlias, string[]> {
                    //{ EntitiesAlias.ColumnAlias, new string[] {"DataType", "MaxLength" } },
                     { EntitiesAlias.Lookup, new string[] {  "SysRefName" , "LangName" } },
                     { EntitiesAlias.State, new string[] { "Country" } },
                     { EntitiesAlias.MenuDriver, new string[] { "RbnBreakdownStructure" } },
                };
            }
        }

        #region Long DropDown

        public static DropDownViewModel GetContactDropDown(this long selectedId, string fieldName, ViewResult viewResult, long parentId = 0, long companyId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.Contact, fieldName, viewResult, "ConFileAs", parentId, null, companyId);
        }

        public static DropDownViewModel GetCompanyDropDown(this long selectedId, string fieldName, ViewResult viewResult, long parentId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.Company, fieldName, viewResult, "CompTitle", parentId);
        }

        public static DropDownViewModel GetRollUpBillingJob(this long selectedId, string fieldName, ViewResult viewResult, long parentId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.RollUpBillingJob, fieldName, viewResult, "ColColumnName", parentId);
        }

        public static DropDownViewModel GetCustomerCompanyDropDown(this long selectedId, string fieldName, ViewResult viewResult, long parentId = 0, bool isRequiredAll = false)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.Customer, fieldName, viewResult, "CompTitle", parentId, null, 0, isRequiredAll);
        }

        public static DropDownViewModel GetProgramContactDropDown(this long selectedId, string fieldName, ViewResult viewResult, long parentId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.ProgramContact, fieldName, viewResult, "ConFileAs", parentId);
        }

        public static DropDownViewModel GetDashboardDropDown(long selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, long parentId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.AppDashboard, fieldName, controlCaption, isRequired, isPopup, "DshName", permission, parentId, isFilterModel: true);
        }

        public static DropDownViewModel GetReportDropDown(long selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, long parentId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.Report, fieldName, controlCaption, isRequired, isPopup, "RprtName", permission, parentId);
        }

        public static DropDownViewModel GetMainModuleDropDown(this long selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, long parentId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.MenuDriver, fieldName, controlCaption, isRequired, isPopup, "MnuTitle", permission, parentId);
        }

        public static DropDownViewModel GetOrgDropDown(this long selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, long parentId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.Organization, fieldName, controlCaption, isRequired, isPopup, "OrgCode", permission, parentId);
        }

        public static DropDownViewModel GetContactDropDown(this long selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, long parentId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.Contact, fieldName, controlCaption, isRequired, isPopup, "ConFileAs", permission, parentId);
        }

        public static DropDownViewModel GetProgramDropDown(this long selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, long parentId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.Program, fieldName, controlCaption, isRequired, isPopup, "PrgProgramCode", permission, parentId);
        }

        public static DropDownViewModel GetJobProgramDropDown(this long selectedId, string fieldName, ViewResult viewResult, long parentId = 0, bool isRequiredAll = false)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.Program, fieldName, viewResult, "PrgProgramCode", parentId, null, 0, isRequiredAll);
        }

        public static DropDownViewModel GetPrgVendLocationDropDown(this long selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, long parentId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.PrgVendLocation, fieldName, controlCaption, isRequired, isPopup, "PvlLocationCode", permission, parentId);
        }

        public static DropDownViewModel GetVendorDropDown(this long selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, long parentId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.Vendor, fieldName, controlCaption, isRequired, isPopup, "VendCode", permission, parentId);
        }

        public static DropDownViewModel GetJobDropDown(this long selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, long parentId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.Job, fieldName, controlCaption, isRequired, isPopup, "JobSiteCode", permission, parentId);
        }

        public static DropDownViewModel GetOrgRefRoleDropDown(this long selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, long parentId = 0, EntitiesAlias entityFor = EntitiesAlias.Common)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.OrgRefRole, fieldName, controlCaption, isRequired, isPopup, "OrgRoleCode", permission, parentId, null, false, entityFor);
        }

        public static DropDownViewModel GetLongDropDownForFilter(string entityString, string fieldName, string controlCaption, bool isRequired, Dictionary<string, string> savedFilters, string currentFieldName, Permission permission, long parentId = 0, EntitiesAlias entityFor = EntitiesAlias.Common)
        {
            var entity = (EntitiesAlias)Enum.Parse(typeof(EntitiesAlias), entityString);
            var relatedValue = string.Empty;
            long currentLongValue = 0;
            savedFilters.TryGetValue(currentFieldName, out relatedValue);
            Int64.TryParse(relatedValue, out currentLongValue);
            var dropDown = GetLongDropDown(currentLongValue, entity, fieldName, controlCaption, isRequired, false, string.Empty, permission, parentId, isFilterModel: true, entityFor: entityFor);
            return dropDown;
        }

        public static DevExpress.Web.EditPropertiesBase GetAdvanceFilterLongDropdown(DropDownViewModel dropDownViewModel)
        {
            var props = new DevExpress.Web.ComboBoxProperties();
            props.ValueType = typeof(bool);
            props.CallbackPageSize = 20;
            return props;
        }

        public static DropDownViewModel GetLongDropDown(this long selectedId, EntitiesAlias entity, string fieldName, string controlCaption, bool isRequired, bool isPopup, string textString, Permission permission, long parentId = 0, string maxLengthField = null, bool isFilterModel = false, EntitiesAlias entityFor = EntitiesAlias.Common)
        {
            return new DropDownViewModel
            {
                Entity = entity,
                EntityFor = entityFor,
                SelectedId = selectedId,
                ValueType = typeof(System.Int64),
                ValueField = "Id",
                ControlName = fieldName,
                ControlCaption = controlCaption,
                IsPopup = isPopup,
                PageSize = 10,
                TextString = textString,
                IsRequired = isRequired,
                ParentId = parentId,
                IsReadOnly = permission < Permission.EditActuals,
                MaxLengthField = maxLengthField,
                Filter = isFilterModel
            };
        }

        public static DropDownViewModel GetLongDropDown(this long selectedId, EntitiesAlias entity, string fieldName, ViewResult viewResult, string textString, long parentId = 0, string maxLengthField = null, long companyId = 0, bool isRequiredAll = false)
        {
            var colSetting = viewResult.ColumnSettings.FirstOrDefault(fieldName);
            return new DropDownViewModel
            {
                Entity = entity,
                SelectedId = selectedId,
                ValueType = typeof(System.Int64),
                ValueField = "Id",
                ControlName = fieldName,
                ControlCaption = colSetting.ColAliasName,
                IsPopup = viewResult.IsPopUp,
                PageSize = viewResult.SessionProvider.UserSettings.Settings.GetSystemSettingValue(WebApplicationConstants.SysComboBoxPageSize).ToInt(),
                TextString = textString,
                IsRequired = colSetting.IsRequired,
                ParentId = parentId,
                IsReadOnly = viewResult.Permission < Permission.EditActuals,
                MaxLengthField = maxLengthField,
                CompanyId = companyId,
                IsRequiredAll = isRequiredAll,
                ParentEntity = viewResult.CallBackRoute != null ? viewResult.CallBackRoute.ParentEntity : EntitiesAlias.Contact,
                ControlAction = maxLengthField,
            };
        }

        #endregion Long DropDown

        #region String DropDown

        public static DropDownViewModel GetColumnDropDown(this string selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, string parentCondition, Permission permission)
        {
            return new DropDownViewModel
            {
                Entity = EntitiesAlias.ColumnAlias,
                SelectedId = selectedId,
                ValueType = typeof(string),
                ValueField = "ColColumnName",
                ControlName = fieldName,
                ControlCaption = controlCaption,
                IsPopup = isPopup,
                PageSize = 10,
                IsRequired = isRequired,
                TextString = "ColColumnName",
                IsReadOnly = permission < Permission.EditActuals,
                ParentCondition = parentCondition
            };
        }

        public static DropDownViewModel GetEDISummaryHeaderDropDown(this string selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, string parentCondition, Permission permission)
        {
            return new DropDownViewModel
            {
                Entity = EntitiesAlias.EDISummaryHeader,
                SelectedId = selectedId,
                ValueType = typeof(string),
                ValueField = "ColColumnName",
                ControlName = fieldName,
                ControlCaption = controlCaption,
                IsPopup = isPopup,
                PageSize = 10,
                IsRequired = isRequired,
                TextString = "ColColumnName",
                IsReadOnly = permission < Permission.EditActuals,
                ParentCondition = parentCondition
            };
        }

        public static DropDownViewModel GetTableDropDown(this string selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, long parentId = 0, bool hideClearBtn = false)
        {
            return GetStringDropDown(selectedId, EntitiesAlias.TableReference, "SysRefName", fieldName, controlCaption, isRequired, isPopup, "LangName", permission, parentId, hideClearBtn);
        }

        public static DropDownViewModel GetStringDropDownForFilter(EntitiesAlias currentEntity, string valueField, string fieldName, string controlCaption, bool isRequired, string textString, Dictionary<string, string> savedFilters, string currentFieldName, Permission permission, long parentId = 0)
        {
            string relatedValue = null;
            savedFilters.TryGetValue(currentFieldName, out relatedValue);
            var dropDown = GetStringDropDown(relatedValue, currentEntity, valueField, fieldName, controlCaption, isRequired, false, textString, permission, parentId);
            return dropDown;
        }

        public static DropDownViewModel GetStringDropDown(this string selectedId, EntitiesAlias entity, string valueField, string fieldName, string controlCaption, bool isRequired, bool isPopup, string textString, Permission permission, long parentId = 0, bool hideClearBtn = false)
        {
            return new DropDownViewModel
            {
                Entity = entity,
                SelectedId = selectedId,
                ValueType = typeof(string),
                ValueField = valueField,
                ControlName = fieldName,
                ControlCaption = controlCaption,
                IsPopup = isPopup,
                PageSize = 10,
                IsRequired = isRequired,
                TextString = textString,
                IsReadOnly = permission < Permission.EditActuals,
                ParentId = parentId,
                HideClearButton = hideClearBtn
            };
        }

        public static DropDownViewModel GetProgramVendorLocationDropDown(this string selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, long parentId = 0)
        {
            return GetStringDropDown(selectedId, EntitiesAlias.PrgVendLocation, "PvlLocationCode", fieldName, controlCaption, isRequired, isPopup, "LangName", permission, parentId);
        }

        #endregion String DropDown

        #region Int Dropdown

        public static IntDropDownViewModel GetLookupDropDown(this int selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, int parentId = 0)
        {
            var dropDown = GetIntDropDown(selectedId, EntitiesAlias.Lookup, fieldName, controlCaption, isRequired, isPopup, "LangName", permission, parentId);
            dropDown.ValueField = "SysRefId";
            dropDown.TextString = "LangName";
            return dropDown;
        }

        public static IntDropDownViewModel GetSysRefDropDown(this int selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, int parentId = 0)
        {
            var dropDown = GetIntDropDown(selectedId, EntitiesAlias.SystemReference, fieldName, controlCaption, isRequired, isPopup, "SysOptionName", permission, parentId);
            if (parentId < 1)
            {
                dropDown.ValueField = "SysLookupId";
                dropDown.TextString = "SysLookupCode";
            }
            return dropDown;
        }

        public static IntDropDownViewModel GetStateDropDown(this int selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, int parentId = 0)
        {
            return GetIntDropDown(selectedId, EntitiesAlias.State, fieldName, controlCaption, isRequired, isPopup, "StateAbbr", permission, parentId);
        }
        public static IntDropDownViewModel GetEventTypeDropDown(this int selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, int parentId = 0)
        {
            return GetIntDropDown(selectedId, EntitiesAlias.EventType, fieldName, controlCaption, isRequired, isPopup, "EventDisplayName", permission, parentId);
        }

        public static IntDropDownViewModel GetScheduleDropDown(this int selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, int parentId = 0)
        {
            return GetIntDropDown(selectedId, EntitiesAlias.Scheduled, fieldName, controlCaption, isRequired, isPopup, "Scheduled", permission, parentId);
        }

        public static IntDropDownViewModel GetOrderTypeDropDown(this int selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, int parentId = 0)
        {
            return GetIntDropDown(selectedId, EntitiesAlias.OrderType, fieldName, controlCaption, isRequired, isPopup, "OrderType", permission, parentId);
        }

        public static IntDropDownViewModel GetJobStatusIdDropDown(this int selectedId, string fieldName, string controlCaption, bool isRequired, bool isPopup, Permission permission, int parentId = 0)
        {
            return GetIntDropDown(selectedId, EntitiesAlias.JobStatusId, fieldName, controlCaption, isRequired, isPopup, "JobStatusId", permission, parentId);
        }

        public static IntDropDownViewModel GetActionDropDown(string fieldName, string controlCaption, int parentId)
        {
            return GetIntDropDown(0, EntitiesAlias.Action, fieldName, controlCaption, true, false, "Action", Permission.All, parentId);
        }

        public static IntDropDownViewModel GetSubActionDropDown(string fieldName, string controlCaption, int parentId)
        {
            return GetIntDropDown(0, EntitiesAlias.SubAction, fieldName, controlCaption, true, false, "SubAction", Permission.All, parentId);
        }

        public static IntDropDownViewModel GetGatewayDropDown(string fieldName, string controlCaption, int parentId)
        {
            return GetIntDropDown(0, EntitiesAlias.NextGatway, fieldName, controlCaption, true, false, "NextGatway", Permission.All, parentId);
        }

        public static IntDropDownViewModel GetIntDropDown(this int selectedId, EntitiesAlias entity, string fieldName, string controlCaption, bool isRequired, bool isPopup, string textString, Permission permission, int parentId = 0)
        {
            return new IntDropDownViewModel
            {
                Entity = entity,
                SelectedId = selectedId,
                ValueField = "Id",
                ControlName = fieldName,
                ControlCaption = controlCaption,
                IsPopup = isPopup,
                PageSize = 10,
                TextString = textString,
                IsRequired = isRequired,
                IsReadOnly = permission < Permission.EditActuals,
                ParentId = parentId
            };
        }

        #endregion Int Dropdown

        public static string GetParentFilter<TView>(this TView viewRecord, System.Reflection.PropertyInfo[] props, EntitiesAlias entity)
        {
            string parentFilter = null;
            var parentFieldName = string.Empty;
            if (ParentCondition.ContainsKey(entity))
                parentFieldName = ParentCondition[entity];
            var propNames = props.Select(c => c.Name).ToList();
            if (!string.IsNullOrWhiteSpace(parentFieldName))
            {
                var propInfo = props[propNames.IndexOf(parentFieldName)];
                if (props[propNames.IndexOf(parentFieldName)].PropertyType == typeof(string))
                    parentFilter = string.Format(" AND {0} = '{1}' ", parentFieldName, props[propNames.IndexOf(parentFieldName)].GetValue(viewRecord).ToString());
                else
                    parentFilter = string.Format(" AND {0} = {1} ", parentFieldName, props[propNames.IndexOf(parentFieldName)].GetValue(viewRecord).ToString());
            }

            return parentFilter;
        }

        public static string GetCompositUniqueFilter<TView>(this TView viewRecord, System.Reflection.PropertyInfo[] props, EntitiesAlias entity)
        {
            string compositeFilter = string.Empty;
            var compositFieldsName = CompositUniqueCondition[entity];
            var propNames = props.Select(c => c.Name).ToList();
            foreach (var singleField in compositFieldsName)
            {
                var propInfo = props[propNames.IndexOf(singleField)];
                if (props[propNames.IndexOf(singleField)].PropertyType == typeof(string))
                    compositeFilter += string.Format(" AND {0} = '{1}' ", singleField, props[propNames.IndexOf(singleField)].GetValue(viewRecord).ToString());
                else if (!string.IsNullOrWhiteSpace(Convert.ToString(props[propNames.IndexOf(singleField)].GetValue(viewRecord))))
                    compositeFilter += string.Format(" AND {0} = {1} ", singleField, Convert.ToString(props[propNames.IndexOf(singleField)].GetValue(viewRecord)));
            }
            return compositeFilter;
        }

        public static Dictionary<EntitiesAlias, string> ItemFieldName
        {
            get
            {
                return new Dictionary<EntitiesAlias, string> {
                     { EntitiesAlias.Organization,  "OrgSortOrder"},
                     { EntitiesAlias.OrgPocContact,"ConItemNumber"},
                     { EntitiesAlias.OrgCredential,"CreItemNumber"},
                     { EntitiesAlias.OrgMarketSupport,"MrkOrder"},
                     { EntitiesAlias.OrgFinancialCalendar,"FclPeriod"},
                     { EntitiesAlias.OrgRolesResp,"OrgRoleSortOrder"},
                     { EntitiesAlias.OrgRefRole,"OrgRoleSortOrder"},
                     { EntitiesAlias.Customer,"CustItemNumber"},
                     { EntitiesAlias.CustBusinessTerm,"CbtItemNumber"},
                     { EntitiesAlias.CustContact,"ConItemNumber"},
                     { EntitiesAlias.CustDcLocation,"CdcItemNumber"},
                     { EntitiesAlias.CustDocReference,"CdrItemNumber"},
                     { EntitiesAlias.CustFinancialCalendar,"FclPeriod"},
                     { EntitiesAlias.Vendor,"VendItemNumber"},
                     { EntitiesAlias.VendBusinessTerm,"VbtItemNumber"},
                     { EntitiesAlias.VendContact,"ConItemNumber"},
                     { EntitiesAlias.VendDcLocation,"VdcItemNumber"},
                     { EntitiesAlias.VendDocReference,"VdrItemNumber"},
                     { EntitiesAlias.VendFinancialCalendar,"FclPeriod"},
                     { EntitiesAlias.PrgRefGatewayDefault,"PgdGatewaySortOrder"},
                     { EntitiesAlias.PrgRole,"PrgRoleSortOrder"},
                     { EntitiesAlias.PrgShipStatusReasonCode,"PscShipItem"},
                     { EntitiesAlias.PrgShipApptmtReasonCode,"PacApptItem"},
                     { EntitiesAlias.PrgRefAttributeDefault,"AttItemNumber"},
                     { EntitiesAlias.PrgMvocRefQuestion,"QueQuestionNumber"},
                     { EntitiesAlias.PrgVendLocation,"PvlItemNumber"},
                     { EntitiesAlias.PrgEdiHeader,"PehItemNumber"},
                     { EntitiesAlias.ScrCatalogList,"CatalogItemNumber"},
                     { EntitiesAlias.ScrOsdList,"OSDItemNumber"},
                     { EntitiesAlias.ScrOsdReasonList,"ReasonItemNumber"},
                     { EntitiesAlias.ScrRequirementList,"RequirementLineItem"},
                     { EntitiesAlias.ScrReturnReasonList,"ReturnReasonLineItem"},
                     { EntitiesAlias.ScrServiceList,"ServiceLineItem"},
                     { EntitiesAlias.Attachment,"AttItemNumber"},
                     { EntitiesAlias.JobGateway,"GwyGatewaySortOrder"},
                     { EntitiesAlias.JobAttribute,"AjbLineOrder"},
                     { EntitiesAlias.JobCargo,"CgoLineItem"},
                     { EntitiesAlias.JobDocReference,"JdrItemNumber"},
                     { EntitiesAlias.SecurityByRole,"SecLineOrder"},
                     { EntitiesAlias.DeliveryStatus,"ItemNumber"},
                     { EntitiesAlias.CustDcLocationContact,"ConItemNumber"},
                     { EntitiesAlias.VendDcLocationContact,"ConItemNumber"}
                };
            }
        }

        public static Dictionary<EntitiesAlias, string> ParentCondition
        {
            get
            {
                return new Dictionary<EntitiesAlias, string> {
                     { EntitiesAlias.OrgPocContact,"ConOrgId"},
                     { EntitiesAlias.OrgCredential,"OrgID"},
                     { EntitiesAlias.OrgMarketSupport,"OrgID"},
                     { EntitiesAlias.OrgFinancialCalendar,"OrgID"},
                     { EntitiesAlias.OrgRefRole,"OrgID"},
                     { EntitiesAlias.OrgRolesResp,"OrgID"},
                     { EntitiesAlias.Customer,"CustOrgId"},
                     { EntitiesAlias.CustBusinessTerm,"CbtCustomerId"},
                     { EntitiesAlias.CustContact,  "ConPrimaryRecordId"},
                     { EntitiesAlias.CustDcLocation,"CdcCustomerID"},
                     { EntitiesAlias.CustDocReference,"CdrCustomerID"},
                     { EntitiesAlias.CustFinancialCalendar,"CustID"},
                     { EntitiesAlias.Vendor,"VendOrgID"},
                     { EntitiesAlias.VendBusinessTerm,"VbtVendorID"},
                     { EntitiesAlias.VendContact,"ConPrimaryRecordId"},
                     { EntitiesAlias.VendDcLocation,"VdcVendorID"},
                     { EntitiesAlias.VendDocReference,"VdrVendorID"},
                     { EntitiesAlias.VendFinancialCalendar,"VendID"},
                     { EntitiesAlias.PrgRefGatewayDefault,"PgdProgramID"},
                     { EntitiesAlias.PrgRole,"ProgramID"},
                     { EntitiesAlias.PrgShipStatusReasonCode,"PscProgramID"},
                     { EntitiesAlias.PrgShipApptmtReasonCode,"PacProgramID"},
                     { EntitiesAlias.PrgRefAttributeDefault,"ProgramID"},
                     { EntitiesAlias.PrgMvocRefQuestion,"MVOCID"},
                     { EntitiesAlias.PrgEdiHeader,"PehProgramID"},
                     { EntitiesAlias.PrgVendLocation,"PvlProgramID"},
                     { EntitiesAlias.SubSecurityByRole,"SecByRoleId"},
                     { EntitiesAlias.Attachment,"AttPrimaryRecordID"},
                     { EntitiesAlias.JobGateway,"JobID"},
                     { EntitiesAlias.JobAttribute,"JobID"},
                     { EntitiesAlias.JobCargo,"JobID"},
                     { EntitiesAlias.JobDocReference,"JobID"},
                     { EntitiesAlias.SecurityByRole,"OrgRefRoleId"},
                     { EntitiesAlias.ColumnAlias,"ColTableName"},
                     { EntitiesAlias.ScrCatalogList,"CatalogProgramID"},
                     { EntitiesAlias.CustDcLocationContact,"ConPrimaryRecordId"},
                     { EntitiesAlias.VendDcLocationContact,"ConPrimaryRecordId"},
                     { EntitiesAlias.PrgBillableRate,"ProgramLocationId"},
                     { EntitiesAlias.PrgCostRate,"ProgramLocationId"}
                };
            }
        }

        public static Dictionary<EntitiesAlias, string[]> CompositUniqueCondition
        {
            get
            {
                return new Dictionary<EntitiesAlias, string[]>
                {
                    //{ EntitiesAlias.CustDcLocation, new string[] { "CdcContactMSTRID" } },
                    //{ EntitiesAlias.VendDcLocation, new string[] { "VdcContactMSTRID" } },

                };
            }
        }

        public static Dictionary<EntitiesAlias, string> AttachmentFieldName
        {
            get
            {
                return new Dictionary<EntitiesAlias, string>{
                     { EntitiesAlias.Contact,  "ConAttachments"},
                     { EntitiesAlias.CustBusinessTerm,  "CbtAttachment"},
                     { EntitiesAlias.CustDocReference,  "CdrAttachment"},
                     { EntitiesAlias.PrgEdiHeader,  "PehAttachments"},
                     { EntitiesAlias.VendBusinessTerm,  "VbtAttachment"},
                     { EntitiesAlias.VendDocReference,  "VdrAttachment"},
                     { EntitiesAlias.JobGateway,  "GwyAttachments"},
                     { EntitiesAlias.JobDocReference,  "JdrAttachment"}
                };
            }
        }

        public static DropDownViewModel GetCargoDropDown(this long selectedId, string fieldName, ViewResult viewResult, long parentId = 0)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.JobCargo, fieldName, viewResult, "CargoItem", parentId);
        }

        public static DropDownViewModel GetExceptionCodeDropDown(this long selectedId, string fieldName, ViewResult viewResult, long parentId = 0, string gatewayAction = null)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.GwyExceptionCode, fieldName, viewResult, "JgeTitle", parentId, gatewayAction);
        }

        public static DropDownViewModel GetExStatusCodeDropDown(this long selectedId, string fieldName, ViewResult viewResult, long parentId = 0, string gatewayAction = null)
        {
            return GetLongDropDown(selectedId, EntitiesAlias.GwyExceptionStatusCode, fieldName, viewResult, "ExStatusDescription", parentId, gatewayAction);
        }
    }
}