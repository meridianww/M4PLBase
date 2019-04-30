/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana
Date Programmed:                              11/11/2017
Program Name:                                 AttachmentCommands
Purpose:                                      Contains commands to perform CRUD on Attachment
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Attachment
{
    public class AttachmentCommands : BaseCommands<Entities.Attachment>
    {
        /// <summary>
        /// Gets list of Contacts
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<Entities.Attachment> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetAttachmentView, (EntitiesAlias)pagedDataInfo.Entity);
        }

        /// <summary>
        /// Gets the specific Attachment
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static Entities.Attachment Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetAttachment);
        }

        /// <summary>
        /// Creates a new Attachment
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="attachment"></param>
        /// <returns></returns>

        public static Entities.Attachment Post(ActiveUser activeUser, Entities.Attachment attachment)
        {
            var parameters = GetParameters(attachment);
            parameters.Add(new Parameter("@primaryTableFieldName", attachment.PrimaryTableFieldName));
            parameters.AddRange(activeUser.PostDefaultParams(attachment));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertAttachment);
        }

        /// <summary>
        /// Updates the existing Attachment record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="attachment"></param>
        /// <returns></returns>

        public static Entities.Attachment Put(ActiveUser activeUser, Entities.Attachment attachment)
        {
            var parameters = GetParameters(attachment);
            parameters.Add(new Parameter("@attDownLoadedDate", attachment.AttDownloadedDate));
            parameters.Add(new Parameter("@attDownLoadedBy", attachment.AttDownloadedBy));
            parameters.AddRange(activeUser.PutDefaultParams(attachment.Id, attachment));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateAttachment);
        }

        /// <summary>
        /// Deletes a specific Attachment
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteContact);
            return 0;
        }

        /// <summary>
        /// Deletes list of Contacts
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.Attachment, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Deletes list of Contacts and updated the parent table attachment count
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <param name="statusId"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> DeleteAndUpdateAttachmentCount(ActiveUser activeUser, List<long> ids, int statusId, string parentTable, string fieldName)
        {
            var parameters = new[]
            {
                new Parameter("@userId", activeUser.UserId),
                new Parameter("@roleId", activeUser.RoleId),
                new Parameter("@orgId", activeUser.OrganizationId),
                new Parameter("@ids", string.Join(",", ids)),
                new Parameter("@separator", ","),
                new Parameter("@statusId", statusId),
                new Parameter("@parentTable", parentTable),
                new Parameter("@parentFieldName", fieldName),
            };
            var result = SqlSerializer.Default.DeserializeMultiRecords<IdRefLangName>(StoredProceduresConstant.DeleteAttachmentAndUpdateCount, parameters, storedProcedure: true);
            return result;
        }

        /// <summary>
        /// Gets list of parameters required for the Contacts Module
        /// </summary>
        /// <param name="attachment"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Attachment attachment)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@attTableName", attachment.AttTableName),
                new Parameter("@attPrimaryRecordID", attachment.AttPrimaryRecordID),
                new Parameter("@attItemNumber", attachment.AttItemNumber),
                new Parameter("@attTitle", attachment.AttTitle),
                new Parameter("@attTypeId", attachment.AttTypeId),
                new Parameter("@attFileName", attachment.AttFileName),
                new Parameter("@statusId", attachment.StatusId),
                new Parameter("@where", string.Format(" AND {0}='{1}' ", AttachmentColumns.AttTableName.ToString(), attachment.AttTableName)),
            };
            return parameters;
        }
    }
}