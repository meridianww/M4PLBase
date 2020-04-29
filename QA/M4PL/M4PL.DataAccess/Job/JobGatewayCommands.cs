/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobGatewayCommands
Purpose:                                      Contains commands to perform CRUD on JobGateway
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System.Collections.Generic;
using System.Linq;

namespace M4PL.DataAccess.Job
{
    public class JobGatewayCommands : BaseCommands<JobGateway>
    {
        /// <summary>
        /// Gets list of JobGateway records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<JobGateway> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetJobGatewayView, EntitiesAlias.JobGateway);
        }

        /// <summary>
        /// Gets the specific JobGateway record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static JobGateway Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetJobGateway);
        }

        public static JobGateway GetGatewayWithParent(ActiveUser activeUser, long id, long parentId,string entityFor = null)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            parameters.Add(new Parameter("@entityFor", entityFor));
            var result = SqlSerializer.Default.DeserializeSingleRecord<JobGateway>(StoredProceduresConstant.GetJobGateway, parameters.ToArray(), storedProcedure: true);
            return result ?? new JobGateway();
        }

        /// <summary>
        /// Creates a new JobGateway record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobGateway"></param>
        /// <returns></returns>

        public static JobGateway Post(ActiveUser activeUser, JobGateway jobGateway)
        {
            var parameters = GetParameters(jobGateway);
            parameters.AddRange(activeUser.PostDefaultParams(jobGateway));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertJobGateway);
        }
        public static JobGateway PostWithSettings(ActiveUser activeUser, SysSetting userSysSetting, JobGateway jobGateway)
        {
            var parameters = GetParameters(jobGateway, userSysSetting);
            parameters.Add(new Parameter("@isScheduleReschedule", jobGateway.isScheduleReschedule));
            parameters.AddRange(activeUser.PostDefaultParams(jobGateway));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertJobGateway);
        }

        /// <summary>
        /// Updates the existing JobGateway record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobGateway"></param>
        /// <returns></returns>

        public static JobGateway Put(ActiveUser activeUser, JobGateway jobGateway)
        {
            var parameters = GetParameters(jobGateway);
            parameters.AddRange(activeUser.PutDefaultParams(jobGateway.Id, jobGateway));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateJobGateway);
        }
        public static JobGateway PutWithSettings(ActiveUser activeUser, SysSetting userSysSetting, JobGateway jobGateway)
        {
            var parameters = GetParameters(jobGateway, userSysSetting);
            parameters.AddRange(activeUser.PutDefaultParams(jobGateway.Id, jobGateway));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateJobGateway);
        }

        /// <summary>
        /// Updates the existing JobGateway record with Action Fields
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="jobGateway"></param>
        /// <returns></returns>

        public static JobGateway PutJobAction(ActiveUser activeUser, JobGateway jobGateway)
        {
            var parameters = GetActionParameters(jobGateway);
            parameters.Add(new Parameter("@isScheduleReschedule", jobGateway.isScheduleReschedule));
            parameters.AddRange(activeUser.PutDefaultParams(jobGateway.Id, jobGateway));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateJobGatewayAction);
        }

        /// <summary>
        /// Deletes a specific JobGateway record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganizationActRole);
            return 0;
        }

        /// <summary>
        /// Deletes list of JobGateway records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.JobGateway, statusId, ReservedKeysEnum.StatusId);
        }

        public static Entities.Contact.Contact PostContactCard(ActiveUser activeUser, Entities.Contact.Contact contact)
        {
            var parameters = GetContactParameters(contact, activeUser.OrganizationId.ToString());
            parameters.Add(new Parameter("@jobId", contact.JobId));
            parameters.AddRange(activeUser.PostDefaultParams(contact));
            var result = SqlSerializer.Default.DeserializeSingleRecord<Entities.Contact.Contact>(StoredProceduresConstant.InsertContact,
                parameters.ToArray(), storedProcedure: true);
            return result;
        }

        /// <summary>
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>
        private static List<Parameter> GetParameters(JobGateway jobGateway, SysSetting userSysSetting = null)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@jobId", jobGateway.JobID),
               new Parameter("@programId", jobGateway.ProgramID),
               new Parameter("@gwyGatewaySortOrder", jobGateway.GwyGatewaySortOrder),
               new Parameter("@gwyGatewayCode", jobGateway.GwyGatewayCode),
               new Parameter("@gwyGatewayTitle", jobGateway.GwyGatewayTitle),
               new Parameter("@gwyGatewayDuration", jobGateway.GwyGatewayDuration),
               new Parameter("@gwyGatewayDefault", jobGateway.GwyGatewayDefault),
               new Parameter("@gatewayTypeId", jobGateway.GatewayTypeId),
               new Parameter("@gwyGatewayAnalyst", jobGateway.GwyGatewayAnalyst),
               new Parameter("@gwyGatewayResponsible", jobGateway.GwyGatewayResponsible),
               new Parameter("@gwyGatewayPCD", jobGateway.GwyGatewayPCD),
               new Parameter("@gwyGatewayECD", jobGateway.GwyGatewayECD),
               new Parameter("@gwyGatewayACD", jobGateway.GwyGatewayACD),
               new Parameter("@gwyCompleted", jobGateway.GwyCompleted),
               new Parameter("@gatewayUnitId", jobGateway.GatewayUnitId),
               new Parameter("@gwyAttachments", jobGateway.GwyAttachments),
               new Parameter("@gwyProcessingFlags", jobGateway.GwyProcessingFlags),
               new Parameter("@gwyDateRefTypeId", jobGateway.GwyDateRefTypeId),
               new Parameter("@scanner", jobGateway.Scanner),
               new Parameter("@gwyShipApptmtReasonCode", jobGateway.GwyShipApptmtReasonCode),
               new Parameter("@gwyShipStatusReasonCode", jobGateway.GwyShipStatusReasonCode),
               new Parameter("@statusId", jobGateway.StatusId),
               new Parameter("@gwyUpdatedById", jobGateway.GwyUpdatedById),
               new Parameter("@gwyClosedOn", jobGateway.GwyClosedOn),
               new Parameter("@gwyClosedBy", jobGateway.GwyClosedBy),
               new Parameter("@gwyOrderType", jobGateway.GwyOrderType),
               new Parameter("@gwyShipmentType", jobGateway.GwyShipmentType),

               new Parameter("@gwyPerson", jobGateway.GwyPerson),
               new Parameter("@gwyPhone", jobGateway.GwyPhone),
               new Parameter("@gwyEmail", jobGateway.GwyEmail),
               new Parameter("@gwyTitle", jobGateway.GwyTitle),
               new Parameter("@gwyDDPCurrent", jobGateway.GwyDDPCurrent),
               new Parameter("@gwyDDPNew", jobGateway.GwyDDPNew),
               new Parameter("@gwyUprWindow", jobGateway.GwyUprWindow),
               new Parameter("@gwyLwrWindow", jobGateway.GwyLwrWindow),
               new Parameter("@gwyUprDate", jobGateway.GwyUprDate),
               new Parameter("@gwyLwrDate", jobGateway.GwyLwrDate),
			   new Parameter("@gwyPreferredMethod", jobGateway.GwyPreferredMethod),
               new Parameter("@gwyExceptionTitleId", jobGateway.GwyExceptionTitleId),
               new Parameter("@gwyCargoId", jobGateway.GwyCargoId),
               new Parameter("@gwyExceptionStatusId", jobGateway.GwyExceptionStatusId),
               //new Parameter("@where",string.Format(" AND {0}.{1} ={2} AND {0}.{3}='{4}' AND {0}.{5}='{6}' ",
               //jobGateway.GetType().Name, JobGatewayDefaultWhereColms.GatewayTypeId, jobGateway.GatewayTypeId.ToString(), JobGatewayDefaultWhereColms.GwyOrderType, jobGateway.GwyOrderType, JobGatewayDefaultWhereColms.GwyShipmentType, jobGateway.GwyShipmentType))
    
            };
            if (userSysSetting != null && userSysSetting.Settings != null)
            {
                var whereCondition = string.Empty;
                var itemNumberConditions = userSysSetting.Settings.Where(s => s.Entity == EntitiesAlias.JobGateway && s.Name.Equals("ItemNumber"));
                foreach (var setting in itemNumberConditions)
                {
                    if (setting != null && !string.IsNullOrEmpty(setting.Value))
                    {
                        var columnList = setting.Value.SplitComma();
                        var properties = jobGateway.GetType().GetProperties();
                        foreach (var columnName in columnList)
                        {
                            var propInfo = properties.FirstOrDefault(p => columnName.Contains(p.Name));
                            if (propInfo != null)
                            {
                                if (!setting.ValueType.Equals("string", System.StringComparison.OrdinalIgnoreCase))
                                    whereCondition = whereCondition + " " + columnName + " " + propInfo.GetValue(jobGateway, null);
                                else
                                    whereCondition = whereCondition + " " + columnName + " '" + propInfo.GetValue(jobGateway, null) + "'";
                            }
                        }
                    }
                }
                parameters.Add(new Parameter("@where", whereCondition));
            }

            return parameters;
        }

        /// <summary>
        /// </summary>
        /// <param name="jobGateway"></param>
        /// <returns></returns>
        private static List<Parameter> GetActionParameters(JobGateway jobGateway)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@jobId", jobGateway.JobID),
               new Parameter("@programId", jobGateway.ProgramID),
               new Parameter("@gwyGatewayACD", jobGateway.GwyGatewayACD),
               new Parameter("@gwyCompleted", jobGateway.GwyCompleted),
               new Parameter("@gwyShipApptmtReasonCode", jobGateway.GwyShipApptmtReasonCode),
               new Parameter("@gwyShipStatusReasonCode", jobGateway.GwyShipStatusReasonCode),
               new Parameter("@gwyClosedOn", jobGateway.GwyClosedOn),
               new Parameter("@gwyClosedBy", jobGateway.GwyClosedBy),
               new Parameter("@gwyPerson", jobGateway.GwyPerson),
               new Parameter("@gwyPhone", jobGateway.GwyPhone),
               new Parameter("@gwyEmail", jobGateway.GwyEmail),
               new Parameter("@gwyTitle", jobGateway.GwyTitle),
               new Parameter("@gwyDDPCurrent", jobGateway.GwyDDPCurrent),
               new Parameter("@gwyDDPNew", jobGateway.GwyDDPNew),
               new Parameter("@gwyUprWindow", jobGateway.GwyUprWindow),
               new Parameter("@gwyLwrWindow", jobGateway.GwyLwrWindow),
               new Parameter("@gwyUprDate", jobGateway.GwyUprDate),
               new Parameter("@gwyLwrDate", jobGateway.GwyLwrDate),
               new Parameter("@gwyGatewayCode", jobGateway.GwyGatewayCode),
               new Parameter("@gatewayTypeId", jobGateway.GatewayTypeId),
            };
            return parameters;
        }

        public static JobGatewayComplete GetJobGatewayComplete(ActiveUser activeUser, long id, long parentId)
        {
            var parameters = activeUser.GetRecordDefaultParams(id);
            parameters.Add(new Parameter("@parentId", parentId));
            var result = SqlSerializer.Default.DeserializeSingleRecord<JobGatewayComplete>(StoredProceduresConstant.GetJobGatewayComplete, parameters.ToArray(), storedProcedure: true);
            return result ?? new JobGatewayComplete();
        }

        public static JobGatewayComplete PutJobGatewayComplete(ActiveUser activeUser, JobGatewayComplete jobGateway)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@orgId", activeUser.OrganizationId),
               new Parameter("@jobId", jobGateway.JobID),
               new Parameter("@gwyGatewayCode", jobGateway.GwyGatewayCode),
               new Parameter("@gwyGatewayTitle", jobGateway.GwyGatewayTitle),
               new Parameter("@gwyShipApptmtReasonCode", jobGateway.GwyShipApptmtReasonCode),
               new Parameter("@gwyShipStatusReasonCode", jobGateway.GwyShipStatusReasonCode),
            };

            parameters.AddRange(activeUser.PutDefaultParams(jobGateway.Id, jobGateway));
            var result = SqlSerializer.Default.DeserializeSingleRecord<JobGatewayComplete>(StoredProceduresConstant.UpdJobGatewayComplete, parameters.ToArray(), storedProcedure: true);
            return result;
        }

        public static IList<JobAction> GetJobAction(ActiveUser activeUser, long jobId)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@jobId", jobId)
            };
            var result = SqlSerializer.Default.DeserializeMultiRecords<JobAction>(StoredProceduresConstant.GetJobActions, parameters.ToArray(), storedProcedure: true);
            return result;
        }
        public static JobActionCode JobActionCodeByTitle(ActiveUser activeUser, long jobId, string gwyTitle)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@jobId", jobId),
               new Parameter("@pgdGatewayTitle", gwyTitle)
            };
            var result = SqlSerializer.Default.DeserializeSingleRecord<JobActionCode>(StoredProceduresConstant.GetJobActionCodes, parameters.ToArray(), storedProcedure: true);
            return result ?? new JobActionCode();
        }
        public static IList<JobGatewayDetails> GetJobGateway(ActiveUser activeUser, long jobId)
        {
            var parameters = new List<Parameter>
            {
               new Parameter("@jobId", jobId),
               new Parameter("@userId", activeUser.UserId),
            };
            var result = SqlSerializer.Default.DeserializeMultiRecords<JobGatewayDetails>(StoredProceduresConstant.GetJobGateways, parameters.ToArray(), storedProcedure: true);
            return result;
        }

        private static List<Parameter> GetContactParameters(Entities.Contact.Contact contact, string conOrgId)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@conERPId", contact.ConERPId),
               new Parameter("@conOrgId", conOrgId ),
               new Parameter("@conTitleId", contact.ConTitleId),
               new Parameter("@conCompanyName", contact.ConCompanyName),
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
               new Parameter("@conUDF01", contact.ConUDF01),
               new Parameter("@conCompanyId", contact.ConCompanyId),
               new Parameter("@jobSiteCode", contact.JobSiteCode),
               new Parameter("@parentId", contact.ParentId)


           };
            return parameters;
        }
    }
}