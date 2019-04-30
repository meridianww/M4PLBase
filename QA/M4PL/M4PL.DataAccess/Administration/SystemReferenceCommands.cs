/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 {Class name} like SystemReferenceCommands
Purpose:                                      Contains commands to perform CRUD on SystemReference
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
    public class SystemReferenceCommands : BaseCommands<SystemReference>
    {
        /// <summary>
        /// Gets list of SystemReference records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<SystemReference> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetSystemReferenceView, EntitiesAlias.SystemReference, langCode: true);
        }

        /// <summary>
        /// Gets the specific SystemReference record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static SystemReference Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetSystemReference, langCode: true);
        }

        /// <summary>
        /// Creates a new systemReference record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="systemReference"></param>
        /// <returns></returns>

        public static SystemReference Post(ActiveUser activeUser, SystemReference systemReference)
        {
            var parameters = GetParameters(systemReference, activeUser);
            parameters.Add(new Parameter("@enteredBy", activeUser.UserName));
            parameters.Add(new Parameter("@dateEntered", System.DateTime.UtcNow));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertSystemReference);
        }

        /// <summary>
        /// Updates the existing systemReference record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="systemReference"></param>
        /// <returns></returns>

        public static SystemReference Put(ActiveUser activeUser, SystemReference systemReference)
        {
            var parameters = GetParameters(systemReference, activeUser);
            parameters.Add(new Parameter("@id", systemReference.Id));
            parameters.Add(new Parameter("@changedBy", activeUser.UserName));
            parameters.Add(new Parameter("@dateChanged", System.DateTime.UtcNow));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateSystemReference);
        }

        /// <summary>
        /// Deletes a specific systemReference record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteMenuDriver);
            return 0;
        }

        /// <summary>
        /// Deletes list of systemReference records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.SystemReference, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets all Lookup Ids of Deleted Items
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> GetDeletedRecordLookUpIds(ActiveUser activeUser, string ids)
        {
            var parameters = new[] { new Parameter("@ids", ids) };
            return SqlSerializer.Default.DeserializeMultiRecords<IdRefLangName>(StoredProceduresConstant.GetDeletedRecordLookUpIds, parameters, storedProcedure: true);
        }

        /// <summary>
        /// Gets list of parameters required for the systemReference Module
        /// </summary>
        /// <param name="systemReference"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(SystemReference systemReference, ActiveUser activeUser)
        {
            var parameters = new List<Parameter>
           {
               new Parameter("@lookupId", systemReference.SysLookupId),
               new Parameter("@sysOptionName", systemReference.SysOptionName),
               new Parameter("@sysSortOrder", systemReference.SysSortOrder),
               new Parameter("@sysDefault", systemReference.SysDefault),
               new Parameter("@statusId", systemReference.StatusId),
               new Parameter("@isSysAdmin", systemReference.IsSysAdmin),
               new Parameter("@lookupName", systemReference.SysLookupCode),
               new Parameter("@langCode", activeUser.LangCode),
               new Parameter("@userId", activeUser.UserId),
               new Parameter("@roleId", activeUser.RoleId),
               new Parameter("@entity", EntitiesAlias.SystemReference.ToString()),
               new Parameter("@where", string.Format(" AND {0}={1} ", SysRefOptionColumns.SysLookupId.ToString(), systemReference.SysLookupId)),
        };
            return parameters;
        }
    }
}