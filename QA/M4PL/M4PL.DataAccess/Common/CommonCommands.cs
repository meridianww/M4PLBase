/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CommonCommands
Purpose:                                      Contains commands to perform CRUD on Common functionalities
=============================================================================================================*/

using M4PL.DataAccess.Logger;
using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace M4PL.DataAccess.Common
{
    public static class CommonCommands
    {
        /// <summary>
        /// Gets UserColumnSettings
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="entity"></param>
        /// <returns></returns>
        public static UserColumnSettings GetUserColumnSettings(long userId, EntitiesAlias entity)
        {
            var parameters = new[]
            {
                new Parameter("@userId", userId),
                new Parameter("@tableName", entity.ToString())
            };
            return SqlSerializer.Default.DeserializeSingleRecord<UserColumnSettings>(StoredProceduresConstant.GetColumnAliasesByUserAndTbl, parameters,
                storedProcedure: true);
        }

        /// <summary>
        /// Gets list of UserSecurities
        /// </summary>
        /// <param name="activeUser"></param>
        /// <returns></returns>

        public static IList<UserSecurity> GetUserSecurities(ActiveUser activeUser)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@roleId", activeUser.RoleId),
            };
            return SqlSerializer.Default.DeserializeMultiRecords<UserSecurity>(StoredProceduresConstant.GetUserSecurities, parameters,
                storedProcedure: true);
        }

        /// <summary>
        /// Gets list of Ref role securities
        /// </summary>
        /// <param name="activeUser"></param>
        /// <returns></returns>

        public static IList<UserSecurity> GetRefRoleSecurities(ActiveUser activeUser)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@roleId", activeUser.RoleId),
            };
            return SqlSerializer.Default.DeserializeMultiRecords<UserSecurity>(StoredProceduresConstant.GetRefRoleSecurities, parameters,
                storedProcedure: true);
        }

        /// <summary>
        /// Gers lists of UserSubSecurities
        /// </summary>
        /// <param name="secByRoleId"></param>
        /// <param name="mainModuleId"></param>
        /// <param name="activeUser"></param>
        /// <returns></returns>

        public static IList<UserSubSecurity> GetUserSubSecurities(long secByRoleId, ActiveUser activeUser)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@secByRoleId", secByRoleId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@roleId", activeUser.RoleId),
            };
            return SqlSerializer.Default.DeserializeMultiRecords<UserSubSecurity>(StoredProceduresConstant.GetUserSubSecurities, parameters,
                storedProcedure: true);
        }

        public static bool UpdSysAccAndConBridgeRole(SystemAccount systemAccount, ActiveUser activeUser)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@sysUserContactId ", systemAccount.SysUserContactID),
                new Parameter("@actRoleId  ", systemAccount.SysOrgRefRoleId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@dateChanged", DateTime.UtcNow),
                new Parameter("@changedBy", activeUser.UserName),
            };
            return SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.UpdSysAccAndConBridgeRole, parameters,
             storedProcedure: true);
        }


        public static SysSetting GetUserSysSettings(ActiveUser activeUser)
        {

            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@contactId", activeUser.ContactId),
            };
            return SqlSerializer.Default.DeserializeSingleRecord<SysSetting>(StoredProceduresConstant.GetUserSysSetting, parameters, storedProcedure: true);
        }

        public static bool GetIsFieldUnique(UniqueValidation uniqueValidation, ActiveUser activeUser)
        {
            var parameters = new[]
              {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@langCode", activeUser.LangCode),
                new Parameter("@tableName", uniqueValidation.Entity.ToString()),
                new Parameter("@recordId", uniqueValidation.RecordId),
                new Parameter("@fieldName", uniqueValidation.FieldName),
                new Parameter("@fieldValue", uniqueValidation.FieldValue),
                new Parameter("@parentFilter", uniqueValidation.ParentFilter),
                new Parameter("@parentId", uniqueValidation.ParentId)
            };
            return SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.GetIsFieldUnique, parameters,
               storedProcedure: true);
        }

        public static string IsValidJobSiteCode(string jobSiteCode, long programId, ActiveUser activeUser)

        {
            var parameters = new[]
              {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@conOrgId", activeUser.OrganizationId),
                new Parameter("@jobSiteCode", jobSiteCode),
                new Parameter("@programId", programId),

            };
            return SqlSerializer.Default.ExecuteScalar<string>(StoredProceduresConstant.IsValidJobSiteCode, parameters,
               storedProcedure: true);
        }
        public static long GetVendorIdforSiteCode(string jobSiteCode, long programId, ActiveUser activeUser)

        {
            var parameters = new[]
              {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@conOrgId", activeUser.OrganizationId),
                new Parameter("@jobSiteCode", jobSiteCode),
                new Parameter("@programId", programId),

            };
            return SqlSerializer.Default.ExecuteScalar<long>(StoredProceduresConstant.GetVendorIdforSiteCode, parameters,
               storedProcedure: true);
        }

        public static UserColumnSettings InsAndUpdChooseColumn(ActiveUser activeUser, UserColumnSettings userColumnSettings)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@colTableName", userColumnSettings.ColTableName),
                new Parameter("@colSortOrder", userColumnSettings.ColSortOrder),
                new Parameter("@colNotVisible", userColumnSettings.ColNotVisible),
                new Parameter("@colIsFreezed", userColumnSettings.ColIsFreezed),
                new Parameter("@colIsDefault", userColumnSettings.ColIsDefault),
                new Parameter("@colGroupBy", userColumnSettings.ColGroupBy),
                new Parameter("@colGridLayout", userColumnSettings.ColGridLayout),
                new Parameter("@dateEntered", DateTime.UtcNow),
                new Parameter("@enteredBy", activeUser.UserName),
                new Parameter("@dateChanged", DateTime.UtcNow),
                new Parameter("@changedBy", activeUser.UserName),
            };
            return SqlSerializer.Default.DeserializeSingleRecord<UserColumnSettings>(StoredProceduresConstant.InsAndUpdChooseColumn, parameters,
                storedProcedure: true);
        }

        public static object GetPagedSelectedFieldsByTable(ActiveUser activeUser, DropDownInfo dropDownDataInfo)
        {
            var parameters = new Parameter[]
            {
                new Parameter("@langCode", activeUser.LangCode),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@entity", dropDownDataInfo.Entity.ToString()),
                new Parameter("@fields", dropDownDataInfo.TableFields),
                new Parameter("@pageNo", dropDownDataInfo.PageNumber),
                new Parameter("@pageSize", dropDownDataInfo.PageSize),
                new Parameter("@orderBy", dropDownDataInfo.OrderBy),
                new Parameter("@like", dropDownDataInfo.Contains),
                new Parameter("@where", dropDownDataInfo.WhereCondition),
                new Parameter("@primaryKeyValue", dropDownDataInfo.PrimaryKeyValue),
                new Parameter("@primaryKeyName", dropDownDataInfo.PrimaryKeyName)
            };

            switch (dropDownDataInfo.Entity)
            {
                case EntitiesAlias.Contact:
                    {
                        var paramList = parameters.ToList();
                        paramList.Add(new Parameter("@parentId", dropDownDataInfo.ParentId));
                        paramList.Add(new Parameter("@entityFor", dropDownDataInfo.EntityFor.ToString()));
                        paramList.Add(new Parameter("@parentEntity", dropDownDataInfo.ParentEntity.ToString()));
                        paramList.Add(new Parameter("@companyId", dropDownDataInfo.CompanyId));
                        paramList.Add(new Parameter("@jobSiteCode", dropDownDataInfo.JobSiteCode));

                        var contactComboBox = SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Support.ContactComboBox>(StoredProceduresConstant.GetComboBoxContact, paramList.ToArray(), storedProcedure: true);

                        return contactComboBox;
                    }

                case EntitiesAlias.Company:
                    {
                        var paramList = parameters.ToList();
                        paramList.Add(new Parameter("@parentId", dropDownDataInfo.ParentId));
                        paramList.Add(new Parameter("@entityFor", dropDownDataInfo.EntityFor.ToString()));
                        paramList.Add(new Parameter("@parentEntity", dropDownDataInfo.ParentEntity.ToString()));
                        return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Support.CompanyComboBox>(StoredProceduresConstant.GetComboBoxCompany, paramList.ToArray(), storedProcedure: true);
                    }
                case EntitiesAlias.RollUpBillingJob:
                    {
                        var paramList = parameters.ToList();
                        paramList.Add(new Parameter("@parentId", dropDownDataInfo.ParentId));
                        paramList.Add(new Parameter("@entityFor", dropDownDataInfo.EntityFor.ToString()));
                        paramList.Add(new Parameter("@parentEntity", dropDownDataInfo.ParentEntity.ToString()));
                        return SqlSerializer.Default.DeserializeMultiRecords<ProgramRollupBillingJob>(StoredProceduresConstant.GetProgramRollupBillingJob, paramList.ToArray(), storedProcedure: true);
                    }

                case EntitiesAlias.Organization:
                    LogParameterInformationForSelectedFieldsByTable(parameters);
                    return SqlSerializer.Default.DeserializeMultiRecords<Entities.Organization.Organization>(StoredProceduresConstant.GetSelectedFieldsByTable, parameters, storedProcedure: true);

                case EntitiesAlias.Customer:
                    //LogParameterInformationForSelectedFieldsByTable(parameters);
                    var paramCustomer = parameters.ToList();
                    paramCustomer.Add(new Parameter("@userId", activeUser.UserId));
                    paramCustomer.Add(new Parameter("@roleId", activeUser.RoleId));
                    var custComboBox = SqlSerializer.Default.DeserializeMultiRecords<Entities.Customer.Customer>(StoredProceduresConstant.GetSelectedFieldsByTable, paramCustomer.ToArray(), storedProcedure: true);
                    if (custComboBox != null && custComboBox.Any() && dropDownDataInfo.PageNumber == 1 && dropDownDataInfo.IsRequiredAll)
                        custComboBox.Insert(0, new Entities.Customer.Customer { CustCode = "ALL", CustOrgIdName = "ALL", CompanyId = 0, CustTitle = "All", Id = 0 });
                    return custComboBox;
                case EntitiesAlias.SecurityByRole:
                    LogParameterInformationForSelectedFieldsByTable(parameters);
                    return SqlSerializer.Default.DeserializeMultiRecords<SecurityByRole>(StoredProceduresConstant.GetSelectedFieldsByTable, parameters, storedProcedure: true);

                case EntitiesAlias.Program:
                    //LogParameterInformationForSelectedFieldsByTable(parameters);
                    var paramProgram = parameters.ToList();
                    paramProgram.Add(new Parameter("@userId", activeUser.UserId));
                    paramProgram.Add(new Parameter("@roleId", activeUser.RoleId));
                    var prgCombobox = SqlSerializer.Default.DeserializeMultiRecords<Entities.Program.Program>(StoredProceduresConstant.GetSelectedFieldsByTable, paramProgram.ToArray(), storedProcedure: true);
                    //if (prgCombobox != null && prgCombobox.Any() && dropDownDataInfo.PageNumber == 1 && dropDownDataInfo.IsRequiredAll)
                    //    prgCombobox.Insert(0, new Entities.Program.Program { PrgProgramCode = "ALL", CompanyId = 0, PrgProgramTitle = "All", Id = 0 });
                    return prgCombobox;
                case EntitiesAlias.Job:
                    LogParameterInformationForSelectedFieldsByTable(parameters);
                    return SqlSerializer.Default.DeserializeMultiRecords<Entities.Job.Job>(StoredProceduresConstant.GetSelectedFieldsByTable, parameters, storedProcedure: true);

                case EntitiesAlias.VendDcLocation:
                    LogParameterInformationForSelectedFieldsByTable(parameters);
                    return SqlSerializer.Default.DeserializeMultiRecords<Entities.Vendor.VendDcLocation>(StoredProceduresConstant.GetSelectedFieldsByTable, parameters, storedProcedure: true);

                case EntitiesAlias.Vendor:
                    if (dropDownDataInfo.ColumnName.Equals("PvlVendorId", StringComparison.OrdinalIgnoreCase)
                        || dropDownDataInfo.ColumnName.Equals("PclVendorID", StringComparison.OrdinalIgnoreCase)
                        || dropDownDataInfo.ColumnName.Equals("PblVendorID", StringComparison.OrdinalIgnoreCase))
                    {
                        return SqlSerializer.Default.DeserializeMultiRecords<Entities.Vendor.Vendor>(StoredProceduresConstant.GetVendorDropDownByPrgId, parameters, storedProcedure: true);
                    }

                    LogParameterInformationForSelectedFieldsByTable(parameters);
                    return SqlSerializer.Default.DeserializeMultiRecords<Entities.Vendor.Vendor>(StoredProceduresConstant.GetSelectedFieldsByTable, parameters, storedProcedure: true);

                case EntitiesAlias.TableReference:
                    LogParameterInformationForSelectedFieldsByTable(parameters);
                    return SqlSerializer.Default.DeserializeMultiRecords<TableReference>(StoredProceduresConstant.GetSelectedFieldsByTable, parameters, storedProcedure: true);

                case EntitiesAlias.SystemReference:
                    return SqlSerializer.Default.DeserializeMultiRecords<SystemReference>(StoredProceduresConstant.GetSysRefDropDown, parameters, storedProcedure: true);

                case EntitiesAlias.State:
                    var paramState = parameters.ToList();

                    paramState.Add(new Parameter("@selectedCountry", dropDownDataInfo.SelectedCountry));

                    return SqlSerializer.Default.DeserializeMultiRecords<Entities.MasterTables.State>(StoredProceduresConstant.GetStatesDropDown, paramState.ToArray(), storedProcedure: true);

                case EntitiesAlias.ColumnAlias:
                    return SqlSerializer.Default.DeserializeMultiRecords<ColumnAlias>(StoredProceduresConstant.GetColumnAliasesDropDown, parameters, storedProcedure: true);

                case EntitiesAlias.PrgRefRole:
                    parameters = new[]
            {
                new Parameter("@langCode", activeUser.LangCode),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@entity", dropDownDataInfo.Entity.ToString()),
                new Parameter("@fields", dropDownDataInfo.TableFields),
                new Parameter("@pageNo", dropDownDataInfo.PageNumber),
                new Parameter("@pageSize", dropDownDataInfo.PageSize),
                new Parameter("@orderBy", dropDownDataInfo.OrderBy),
                new Parameter("@like", dropDownDataInfo.Contains),
                new Parameter("@where", dropDownDataInfo.WhereCondition),
                new Parameter("@primaryKeyValue", dropDownDataInfo.PrimaryKeyValue),
                new Parameter("@primaryKeyName", dropDownDataInfo.PrimaryKeyName),
                 new Parameter("@programId", dropDownDataInfo.ParentId)
            };

                    return SqlSerializer.Default.DeserializeMultiRecords<OrgRole>(StoredProceduresConstant.GetRefRolesByProgramId, parameters, storedProcedure: true);

                case EntitiesAlias.ProgramRole:
                    var programRoleParamList = parameters.ToList();
                    programRoleParamList.Add(new Parameter("@programId", dropDownDataInfo.ParentId));

                    return SqlSerializer.Default.DeserializeMultiRecords<ProgramRole>(StoredProceduresConstant.GetProgramRolesByProgramId, programRoleParamList.ToArray(), storedProcedure: true);

                case EntitiesAlias.OrgRefRole:
                    var parameterList = parameters.ToList();
                    parameterList.Add(new Parameter("@userId", activeUser.UserId));
                    parameterList.Add(new Parameter("@entityFor", dropDownDataInfo.EntityFor.ToString()));
                    LogParameterInformationForSelectedFieldsByTable(parameterList.ToArray());
                    return SqlSerializer.Default.DeserializeMultiRecords<Entities.Organization.OrgRefRole>(StoredProceduresConstant.GetSelectedFieldsByTable, parameterList.ToArray(), storedProcedure: true);

                case EntitiesAlias.MenuDriver:
                    return SqlSerializer.Default.DeserializeMultiRecords<MenuDriver>(StoredProceduresConstant.GetMenuModuleDropdown, parameters, storedProcedure: true);

                case EntitiesAlias.Report:
                    LogParameterInformationForSelectedFieldsByTable(parameters);
                    return SqlSerializer.Default.DeserializeMultiRecords<Report>(StoredProceduresConstant.GetSelectedFieldsByTable, parameters, storedProcedure: true);

                case EntitiesAlias.AppDashboard:
                    return SqlSerializer.Default.DeserializeMultiRecords<AppDashboard>(StoredProceduresConstant.GetAppDashboardDropdown, parameters, storedProcedure: true);

                case EntitiesAlias.Lookup:
                    var lookupParameters = parameters.ToList();
                    lookupParameters.Add(new Parameter("@entityFor", dropDownDataInfo.EntityFor.ToString()));
                    return SqlSerializer.Default.DeserializeMultiRecords<IdRefLangName>(StoredProceduresConstant.GetLookupDropDown, lookupParameters.ToArray(), storedProcedure: true);

                case EntitiesAlias.OrgRole:
                    LogParameterInformationForSelectedFieldsByTable(parameters);
                    return SqlSerializer.Default.DeserializeMultiRecords<OrgRole>(StoredProceduresConstant.GetSelectedFieldsByTable, parameters, storedProcedure: true);

                case EntitiesAlias.ProgramContact:
                    parameters = new[]
                                    {
                                        new Parameter("@orgId", activeUser.OrganizationId),
                                        new Parameter("@programId", dropDownDataInfo.ParentId)
                                      };

                    return SqlSerializer.Default.DeserializeMultiRecords<Entities.Contact.Contact>(StoredProceduresConstant.GetProgramContacts, parameters, storedProcedure: true);
                case EntitiesAlias.PrgVendLocation:
                    LogParameterInformationForSelectedFieldsByTable(parameters);
                    return SqlSerializer.Default.DeserializeMultiRecords<Entities.Program.PrgVendLocation>(StoredProceduresConstant.GetSelectedFieldsByTable, parameters, storedProcedure: true);
                case EntitiesAlias.PrgVendLocationCodeLookup:
                    parameters = new[]
                           {
                                new Parameter("@id", dropDownDataInfo.ParentId),
                                new Parameter("@pageNo", dropDownDataInfo.PageNumber),
                                new Parameter("@pageSize", dropDownDataInfo.PageSize),
                                new Parameter("@orderBy", dropDownDataInfo.OrderBy),
                                new Parameter("@like", dropDownDataInfo.Contains),
                                new Parameter("@where", dropDownDataInfo.WhereCondition),
                                new Parameter("@primaryKeyValue", dropDownDataInfo.PrimaryKeyValue),
                                new Parameter("@primaryKeyName", dropDownDataInfo.PrimaryKeyName),
                            };
                    return SqlSerializer.Default.DeserializeMultiRecords<Entities.Program.PrgVendLocation>(StoredProceduresConstant.GetVendorLocations, parameters, storedProcedure: true);
                case EntitiesAlias.EdiMappingTable:
                    parameters = new[] { new Parameter("@where", dropDownDataInfo.WhereCondition) };
                    return SqlSerializer.Default.DeserializeMultiRecords<TableReference>(StoredProceduresConstant.GetEDIMappingTablesByType, parameters, storedProcedure: true);
                case EntitiesAlias.PrgShipApptmtReasonCode:
                    var parameterList1 = parameters.ToList();
                    LogParameterInformationForSelectedFieldsByTable(parameters);
                    parameterList1.Add(new Parameter("@entityFor", dropDownDataInfo.EntityFor.ToString()));
                    return SqlSerializer.Default.DeserializeMultiRecords<Entities.Program.PrgShipApptmtReasonCode>(StoredProceduresConstant.GetSelectedFieldsByTable, parameterList1.ToArray(), storedProcedure: true);
                case EntitiesAlias.PrgShipStatusReasonCode:
                    var parameterList2 = parameters.ToList();
                    parameterList2.Add(new Parameter("@entityFor", dropDownDataInfo.EntityFor.ToString()));
                    LogParameterInformationForSelectedFieldsByTable(parameterList2.ToArray());
                    return SqlSerializer.Default.DeserializeMultiRecords<Entities.Program.PrgShipStatusReasonCode>(StoredProceduresConstant.GetSelectedFieldsByTable, parameterList2.ToArray(), storedProcedure: true);
                case EntitiesAlias.EDISummaryHeader:
                    return SqlSerializer.Default.DeserializeMultiRecords<ColumnAlias>(StoredProceduresConstant.GetEdiSummaryHeaderDropDown, parameters, storedProcedure: true);
            }

            return new object();
        }

        public static bool UpdateLineNumberForJobBillableSheet(ActiveUser activeUser, long? jobId)
        {
            SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateLineNumberForJobBillableSheet, new Parameter("@JobId", jobId), true);

            return true;
        }

        public static bool UpdateLineNumberForJobCostSheet(ActiveUser activeUser, long? jobId)
        {
            SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateLineNumberForJobCostSheet, new Parameter("@JobId", jobId), true);

            return true;
        }

        public static object GetProgramDescendants(ActiveUser activeUser, DropDownInfo dropDownDataInfo)
        {
            var parameters = new Parameter[]
            {
                new Parameter("@langCode", activeUser.LangCode),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@entity", dropDownDataInfo.Entity.ToString()),
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@recordId", dropDownDataInfo.RecordId),
            };
            return SqlSerializer.Default.DeserializeMultiRecords<Entities.Program.Program>(StoredProceduresConstant.GetProgramCodesById, parameters, storedProcedure: true);
        }
        public static IList<LeftMenu> GetModuleMenus(ActiveUser activeUser)
        {
            var parameters = new[]
            {
                new Parameter("@langCode", activeUser.LangCode),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@roleId", activeUser.RoleId),
            };
            return SqlSerializer.Default.DeserializeMultiRecords<LeftMenu>(StoredProceduresConstant.GetModuleMenus, parameters,
                storedProcedure: true).BuildMenus();
        }

        public static int SaveBytes(ByteArray byteArray, ActiveUser activeUser)
        {
            var parameters = new List<Parameter>
                {
                        new Parameter("@userId", activeUser.UserId),
                        new Parameter("@roleCode", activeUser.RoleCode),
                        new Parameter("@langCode", activeUser.LangCode),
                        new Parameter("@recordId", byteArray.Id),
                        new Parameter("@refTableName", byteArray.Entity.ToString()),
                        new Parameter("@fieldName", byteArray.FieldName),
                        new Parameter("@type", byteArray.Type.ToString()),
                        new Parameter("@documentText", byteArray.DocumentText)
                };

            if (byteArray.Bytes != null)
                parameters.Add(new Parameter("@fieldValue", byteArray.Bytes));

            return SqlSerializer.Default.ExecuteScalar<int>(StoredProceduresConstant.SaveBytes, parameters.ToArray(),
             storedProcedure: true);
        }

        public static string AddorEditPreferedLocations(string locations, int contTypeId,  ActiveUser activeUser)
        {
            var parameters = new[]
            {
                        new Parameter("@userId", activeUser.UserId),
                        new Parameter("@orgId", activeUser.OrganizationId),
                        new Parameter("@langCode", activeUser.LangCode),
                        new Parameter("@contactType", contTypeId),
                        new Parameter("@locations", locations)

                };
            return SqlSerializer.Default.ExecuteScalar<string>(StoredProceduresConstant.AddorEditPreferedLocations, parameters,
             storedProcedure: true);
        }


        public static string GetPreferedLocations(ActiveUser activeUser, int contTypeId)
        {

            var parameters = new[]
             {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@langCode",  activeUser.LangCode),
                new Parameter("@conTypeId",  contTypeId),

            };
            return SqlSerializer.Default.ExecuteScalar<string>(StoredProceduresConstant.GetPreferedLocations, parameters,
             storedProcedure: true);
        }

        public static int GetUserContactType(ActiveUser activeUser)
        {
            var parameters = new List<Parameter>
                {
                        new Parameter("@userId", activeUser.UserId),
                        new Parameter("@orgId", activeUser.OrganizationId),
                        new Parameter("@langCode", activeUser.LangCode),
                        new Parameter("@roleId", activeUser.RoleId),
                };
            return SqlSerializer.Default.ExecuteScalar<int>(StoredProceduresConstant.GetUserContactType, parameters.ToArray(),
             storedProcedure: true);
        }

        public static IList<LookupReference> GetRefLookup(ActiveUser activeUser, EntitiesAlias entitiesAlias)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@referenceType", entitiesAlias.ToString()),
            };
            return SqlSerializer.Default.DeserializeMultiRecords<LookupReference>(StoredProceduresConstant.GetRefLookup, parameters,
                storedProcedure: true);
        }

        public static bool CheckRecordUsed(string allRecordIds, EntitiesAlias entity)
        {
            var parameters = new[]
            {
                new Parameter("@Id", allRecordIds),
                new Parameter("@TableName", entity.ToString())
            };
            return SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.CheckRecordUsed, parameters,
                storedProcedure: true);
        }

        public static ByteArray GetByteArrayByIdAndEntity(ByteArray byteArray)
        {
            var fieldName = string.Format("{0} as Bytes", byteArray.FieldName);
            if (byteArray.Type == SQLDataTypes.nvarchar)
                fieldName = string.Format("CONVERT(VARBINARY(MAX), {0}, 0) as Bytes", byteArray.FieldName);
            var parameters = new[]
            {
                new Parameter("@recordId", byteArray.Id),
                new Parameter("@entity", byteArray.Entity.ToString()),
                new Parameter("@fields", fieldName),
            };

            return SqlSerializer.Default.DeserializeSingleRecord<ByteArray>(StoredProceduresConstant.GetByteArrayByIdAndEntity, parameters,
                storedProcedure: true);
        }

        public static Entities.Contact.Contact GetContactById(long recordId, ActiveUser activeUser)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@id", recordId),
            };

            return SqlSerializer.Default.DeserializeSingleRecord<Entities.Contact.Contact>(StoredProceduresConstant.GetContact, parameters,
                storedProcedure: true);
        }

        public static Entities.CompanyAddress.CompanyAddress GetContactAddressByCompany(long companyId, ActiveUser activeUser)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@id", companyId),
            };

            return SqlSerializer.Default.DeserializeSingleRecord<Entities.CompanyAddress.CompanyAddress>(StoredProceduresConstant.GetCompanyCorporateAddress, parameters,
                storedProcedure: true);
        }

        public static Entities.Contact.Contact ContactCardAddOrEdit(Entities.Contact.Contact contact, ActiveUser activeUser)
        {
            var parameters = GetContactCardParameters(contact, activeUser);
            var storedProcedureToUse = StoredProceduresConstant.UpdateContact;
            if (contact.Id > 0)
            {
                parameters.Add(new Parameter("@id", contact.Id));
                parameters.Add(new Parameter("@changedBy", activeUser.UserName));
                parameters.Add(new Parameter("@dateChanged", DateTime.UtcNow));
            }
            else
            {
                parameters.Add(new Parameter("@enteredBy", activeUser.UserName));
                parameters.Add(new Parameter("@dateEntered", DateTime.UtcNow));
                storedProcedureToUse = StoredProceduresConstant.InsertContact;
            }

            return SqlSerializer.Default.DeserializeSingleRecord<Entities.Contact.Contact>(storedProcedureToUse, parameters.ToArray(), storedProcedure: true);
        }

        private static List<Parameter> GetContactCardParameters(Entities.Contact.Contact contact, ActiveUser activeUser)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@roleId", activeUser.RoleId),
               new Parameter("@conERPId", contact.ConERPId),
               //new Parameter("@conOrgId", contact.ConCompany),
               new Parameter("@conTitleId", contact.ConTitleId),
               new Parameter("@conLastName", contact.ConLastName),
               new Parameter("@conFirstName", contact.ConFirstName),
               new Parameter("@conMiddleName", contact.ConMiddleName),
               new Parameter("@conEmailAddress", contact.ConEmailAddress),
               new Parameter("@conEmailAddress2", contact.ConEmailAddress2),
               new Parameter("@conJobTitle", contact.ConJobTitle),
               new Parameter("@conBusinessPhone", contact.ConBusinessPhone),
               new Parameter("@conBusinessPhoneExt", contact.ConBusinessPhoneExt),
               new Parameter("@conHomePhone", contact.ConHomePhone),
               new Parameter("@conMobilePhone", contact.ConMobilePhone),
               new Parameter("@conFaxNumber", contact.ConFaxNumber),
               new Parameter("@conBusinessAddress1", contact.ConBusinessAddress1),
               new Parameter("@conBusinessAddress2", contact.ConBusinessAddress2),
               new Parameter("@conBusinessCity", contact.ConBusinessCity),
               new Parameter("@conBusinessStateId", contact.ConBusinessStateId),
               new Parameter("@conBusinessZipPostal", contact.ConBusinessZipPostal),
               new Parameter("@conBusinessCountryId", contact.ConBusinessCountryId),
               new Parameter("@conHomeAddress1", contact.ConHomeAddress1),
               new Parameter("@conHomeAddress2", contact.ConHomeAddress2),
               new Parameter("@conHomeCity", contact.ConHomeCity),
               new Parameter("@conHomeStateId", contact.ConHomeStateId),
               new Parameter("@conHomeZipPostal", contact.ConHomeZipPostal),
               new Parameter("@conHomeCountryId", contact.ConHomeCountryId),
               new Parameter("@conAttachments", contact.ConAttachments),
               new Parameter("@conWebPage", contact.ConWebPage),
               new Parameter("@conNotes", contact.ConNotes),
               new Parameter("@statusId", contact.StatusId),
               new Parameter("@conTypeId", contact.ConTypeId),
               new Parameter("@conOutlookId", contact.ConOutlookId),
           };
            return parameters;
        }

        public static int GetLastItemNumber(PagedDataInfo pagedDataInfo)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@entity", pagedDataInfo.Entity.ToString()),
                new Parameter("@fieldName", pagedDataInfo.TableFields),
                new Parameter("@where", pagedDataInfo.WhereCondition)
            };

            return SqlSerializer.Default.ExecuteScalar<int>(StoredProceduresConstant.GetLastItemNumber, parameters.ToArray(), storedProcedure: true);
        }

        public static bool ResetItemNumber(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@id", 0),
                new Parameter("@parentId", pagedDataInfo.ParentId),
                new Parameter("@entity", pagedDataInfo.Entity.ToString()),
                new Parameter("@itemNumber", 0),
                new Parameter("@statusId", 3),
                new Parameter("@where", pagedDataInfo.WhereCondition),
                new Parameter("@joins", string.Empty),
                new Parameter("@newItemNumber", pagedDataInfo.TotalCount),
                new Parameter("@deletedKeys",pagedDataInfo.Contains)
            };
            return SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.ResetItemNumber, parameters.ToArray(), storedProcedure: true);
        }

        public static IList<TreeListModel> GetCustPPPTree(ActiveUser activeUser, long orgId, long? custId, long? parentId)
        {
            var parameters = new[]
            {
                new Parameter("@orgId", orgId),
                new Parameter("@custId", custId),
                new Parameter("@parentId", parentId),
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId)
            };
            var result = SqlSerializer.Default.DeserializeMultiRecords<TreeListModel>(StoredProceduresConstant.GetCustPPPTree, parameters, storedProcedure: true);
            return result;
        }

        public static ErrorLog GetOrInsErrorLog(ActiveUser activeUser, ErrorLog errorLog)
        {
            var parameters = new[]
            {
                new Parameter("@id", errorLog.Id),
                new Parameter("@relatedTo", errorLog.ErrRelatedTo),
                new Parameter("@innerException", errorLog.ErrInnerException),
                new Parameter("@message", errorLog.ErrMessage),
                new Parameter("@source", errorLog.ErrSource),
                new Parameter("@stackTrace", errorLog.ErrStackTrace),
                new Parameter("@additionalMessage", errorLog.ErrAdditionalMessage),
            };
            return SqlSerializer.Default.DeserializeSingleRecord<ErrorLog>(StoredProceduresConstant.GetOrInsErrorLog, parameters, storedProcedure: true);
        }


        public static IList<DeleteInfo> GetTableAssociations(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            var parameters = new[]
            {
                new Parameter("@tableName", pagedDataInfo.Entity.ToString()),
                new Parameter("@@id", pagedDataInfo.Contains),

            };

            return SqlSerializer.Default.DeserializeMultiRecords<DeleteInfo>(StoredProceduresConstant.GetCustPPPTree, parameters, storedProcedure: true);
        }

        public static IList<AppDashboard> GetUserDashboards(ActiveUser activeUser, int mainModuleId)
        {
            var parameters = new[]
          {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@mainModuleId", mainModuleId),
            };
            return SqlSerializer.Default.DeserializeMultiRecords<AppDashboard>(StoredProceduresConstant.GetUserDashboards, parameters, storedProcedure: true);
        }

        public static string SwitchOrganization(ActiveUser activeUser, long orgId)
        {
            var parameters = new[]
         {
                        new Parameter("@userId", activeUser.UserId),
                        new Parameter("@contactId", activeUser.ContactId),
                        new Parameter("@orgId", orgId),
                        new Parameter("@roleId", activeUser.RoleId),
            };
            return SqlSerializer.Default.ExecuteScalar<string>(StoredProceduresConstant.SwitchOrganization, parameters, storedProcedure: true);

        }


        public static string GetNextBreakDownStructure(ActiveUser activeUser, bool ribbon)
        {
            var parameters = new[]
         {
                new Parameter("@langCode", activeUser.LangCode),
                 new Parameter("@mnuRibbon", ribbon),
            };
            return SqlSerializer.Default.ExecuteScalar<string>(StoredProceduresConstant.GetNextModuleBDS, parameters, storedProcedure: true);

        }
        public static bool GetJobIsCompleted(long jobId)
        {
            var parameters = new[] { new Parameter("@jobId", jobId) };
            return SqlSerializer.Default.ExecuteScalar<bool>(StoredProceduresConstant.GetIsJobCompleted, parameters, storedProcedure: true);
        }

        public static IList<Role> GetOrganizationRoleDetails(ActiveUser activeUser)
        {
            var parameters = new[] { new Parameter("@userId", activeUser.UserId), new Parameter("@contactId", activeUser.ContactId) };
            var toReturn = SqlSerializer.Default.DeserializeMultiRecords<Role>(StoredProceduresConstant.GetOrganizationRoleDetails, parameters,
                storedProcedure: true);
            return toReturn.Distinct().ToList();
        }

        public static void UpdateUserSystemSettings(ActiveUser activeUser, SysSetting userSystemSettings)
        {
            var parameters = new[]
            {
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@langCode", activeUser.LangCode),
                new Parameter("@sysJsonSetting", userSystemSettings.SysJsonSetting)
            };
            SqlSerializer.Default.Execute(StoredProceduresConstant.UpdateUserSystemSettings, parameters, storedProcedure: true);
        }

        public static IList<SysRefModel> GetDeleteInfoModules(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@entity", pagedDataInfo.Entity.ToString()),
                new Parameter("@recordId", pagedDataInfo.RecordId),
            };
            return SqlSerializer.Default.DeserializeMultiRecords<SysRefModel>(StoredProceduresConstant.GetDeleteInfoModules, parameters,
                storedProcedure: true);
        }


        public static dynamic GetDeleteInfoRecords(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@entity", pagedDataInfo.Entity.ToString()),
                new Parameter("@parentEntity", pagedDataInfo.TableFields),
                new Parameter("@contains", pagedDataInfo.Contains)
            };

            switch (pagedDataInfo.Entity)
            {
                case EntitiesAlias.Account:
                    return SqlSerializer.Default.DeserializeMultiRecords<SystemAccount>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.Organization:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Organization.Organization>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.OrgPocContact:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Organization.OrgPocContact>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.OrgCredential:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Organization.OrgCredential>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.OrgFinancialCalendar:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Organization.OrgFinancialCalendar>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.OrgRefRole:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Organization.OrgRefRole>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.SecurityByRole:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Administration.SecurityByRole>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.SubSecurityByRole:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Administration.SubSecurityByRole>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);

                case EntitiesAlias.Customer:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Customer.Customer>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.CustBusinessTerm:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Customer.CustBusinessTerm>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.CustFinancialCalendar:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Customer.CustDocReference>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.CustContact:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Customer.CustContact>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.CustDcLocation:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Customer.CustDcLocation>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.CustDocReference:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Customer.CustDocReference>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);

                case EntitiesAlias.Vendor:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Vendor.Vendor>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.VendBusinessTerm:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Vendor.VendBusinessTerm>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.VendFinancialCalendar:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Vendor.VendFinancialCalendar>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.VendContact:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Vendor.VendContact>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.VendDcLocation:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Vendor.VendDcLocation>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.VendDocReference:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Vendor.VendDocReference>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);

                case EntitiesAlias.Program:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Program.Program>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.PrgRefGatewayDefault:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Program.PrgRefGatewayDefault>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.PrgRole:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Program.PrgRole>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.PrgVendLocation:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Program.PrgVendLocation>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);

                case EntitiesAlias.PrgBillableRate:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Program.PrgBillableRate>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.PrgCostRate:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Program.PrgCostRate>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.PrgMvoc:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Program.PrgMvoc>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.PrgMvocRefQuestion:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Program.PrgMvocRefQuestion>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.PrgEdiHeader:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Program.PrgEdiHeader>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.PrgEdiMapping:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Program.PrgEdiMapping>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.PrgBillableLocation:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Program.PrgBillableLocation>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.PrgCostLocation:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Program.PrgCostLocation>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);

                case EntitiesAlias.Job:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Job.Job>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.JobGateway:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Job.JobGateway>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.JobAttribute:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Job.JobAttribute>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.JobCargo:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Job.JobCargo>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.JobDocReference:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Job.JobDocReference>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.JobCostSheet:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Job.JobCostSheet>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.JobBillableSheet:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Job.JobBillableSheet>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);

                case EntitiesAlias.ScrOsdList:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Scanner.ScrOsdList>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.ScrCatalogList:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Scanner.ScrCatalogList>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.ScrOsdReasonList:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Scanner.ScrOsdReasonList>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.ScrRequirementList:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Scanner.ScrRequirementList>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.ScrReturnReasonList:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Scanner.ScrReturnReasonList>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.ScrServiceList:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Scanner.ScrServiceList>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);

                case EntitiesAlias.SystemAccount:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Administration.SystemAccount>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.CustDcLocationContact:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Customer.CustDcLocationContact>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);
                case EntitiesAlias.VendDcLocationContact:
                    return SqlSerializer.Default.DeserializeMultiRecords<M4PL.Entities.Vendor.VendDcLocationContact>(StoredProceduresConstant.GetDeleteInfoRecords, parameters, storedProcedure: true);

                default:
                    return new object();
            }
        }


        public static void RemoveDeleteInfoRecords(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@entity", pagedDataInfo.Entity.ToString()),
                new Parameter("@parentEntity", pagedDataInfo.TableFields),
                new Parameter("@contains", pagedDataInfo.Contains),
                new Parameter("@parentFieldName", pagedDataInfo.WhereCondition),
                new Parameter("@itemNumberField", pagedDataInfo.OrderBy),

            };

            SqlSerializer.Default.Execute(StoredProceduresConstant.RemoveDeleteInfoRecords, parameters, storedProcedure: true);
        }

        public static UserSecurity GetUserPageOptnLevelAndPermission(long userId, long orgId, long roleId, EntitiesAlias entity, ActiveUser activeUser)
        {
            var parameters = new[]
            {
                new Parameter("@userId", userId),
                new Parameter("@orgId", orgId),
                new Parameter("@roleId", roleId),
                new Parameter("@entity", entity.ToString()),
            };
            return SqlSerializer.Default.DeserializeSingleRecord<UserSecurity>(StoredProceduresConstant.GetUserPageOptnLevelAndPermission, parameters, storedProcedure: true);
        }

        public static UserSecurity GetDashboardAccess(ActiveUser activeUser, string tableName, long dashboardId)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@tableName", tableName),
                new Parameter("@dashboardId", dashboardId),
            };
            return SqlSerializer.Default.DeserializeSingleRecord<UserSecurity>(StoredProceduresConstant.GetDashboardAccess, parameters, storedProcedure: true);
        }

        private static void LogParameterInformationForSelectedFieldsByTable(Parameter[] parameters)
        {
            Task.Run(() =>
            {
                string parameterJson = Newtonsoft.Json.JsonConvert.SerializeObject(parameters);
                ErrorLogger.Log(new Exception(), string.Format("Parameters for SP GetSelectedFieldsByTable are: {0}", parameterJson), "GetSelectedFieldsByTable", Utilities.Logger.LogType.Informational);
            });
        }

        public static CommonIds GetMaxMinRecordsByEntity(string Entity, long RecordID, long OrganizationId, long ID)
        {
            var parameters = new[]
            {
                new Parameter("@entity", Entity),
                new Parameter("@recordID", RecordID.ToString()),
                new Parameter("@OrgId",OrganizationId),
                new Parameter("@ID",ID),
            };
            return SqlSerializer.Default.DeserializeSingleRecord<CommonIds>(StoredProceduresConstant.GetMaxMinRecordByEntity, parameters, storedProcedure: true);
        }

        public static JobGatewayModelforPanel GetGatewayTypeByJobID(long jobGatewayateId)
        {
            var parameters = new[] { new Parameter("@jobGatewayateId", jobGatewayateId) };
            return SqlSerializer.Default.DeserializeSingleRecord<JobGatewayModelforPanel>(StoredProceduresConstant.GetGatewayTypeByJobID, parameters, storedProcedure: true);
        }
    }
}