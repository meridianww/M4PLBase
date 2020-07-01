/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ColumnAliasCommands
Purpose:                                      Contains commands to perform CRUD on ColumnAlias
=============================================================================================================*/

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Administration;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.DataAccess.Administration
{
    public class ColumnAliasCommands : BaseCommands<ColumnAlias>
    {
        /// <summary>
        /// Gets column aliases records based on the table name
        /// </summary>
        /// <param name="langCode"></param>
        /// <param name="tableName"></param>
        /// <returns></returns>
        public static IList<ColumnAlias> GetColumnAliasesByTblName(string langCode, string tableName, bool isGridSetting = false)
        {
            var parameters = new[]
            {
                new Parameter("@langCode", langCode),
                new Parameter("@tableName", tableName),
                new Parameter("@isGridSetting", isGridSetting)
            };
            return
                SqlSerializer.Default.DeserializeMultiRecords<ColumnAlias>(
                    StoredProceduresConstant.GetColumnAliasesByTableName, parameters, storedProcedure: true);
        }

        /// <summary>
        /// Gets the list of Column aliases records from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>

        public static IList<ColumnAlias> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetColumnAliasView, EntitiesAlias.ColumnAlias, langCode: true);
        }

        /// <summary>
        /// Gets specific column alias record from the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static ColumnAlias Get(ActiveUser activeUser, long id)
        {
            return Get(activeUser, id, StoredProceduresConstant.GetColumnAlias, langCode: true);
        }

        /// <summary>
        /// Creates a new record in the database
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="columnAlias"></param>
        /// <returns></returns>

        public static ColumnAlias Post(ActiveUser activeUser, ColumnAlias columnAlias)
        {
            var parameters = GetParameters(columnAlias);
            parameters.AddRange(activeUser.PostDefaultParams(columnAlias));
            return Post(activeUser, parameters, StoredProceduresConstant.InsertColumnAlias);
        }

        /// <summary>
        /// Updates the specific record details
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="columnAlias"></param>
        /// <returns></returns>

        public static ColumnAlias Put(ActiveUser activeUser, ColumnAlias columnAlias)
        {
            var parameters = GetParameters(columnAlias);
            parameters.Add(new Parameter("@where", string.Format(" AND {0}='{1}' ", ColumnAliasColumns.ColTableName.ToString(), columnAlias.ColTableName)));
            parameters.AddRange(activeUser.PutDefaultParams(columnAlias.Id, columnAlias));
            return Put(activeUser, parameters, StoredProceduresConstant.UpdateColumnAlias);
        }

        /// <summary>
        /// Deletes specific record from the database
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
        /// Deletes list of records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>
        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.ColumnAlias, statusId, ReservedKeysEnum.StatusId);
        }

        /// <summary>
        /// Gets list of parameters required for the colun alias Module
        /// </summary>
        /// <param name="columnAlias"></param>
        /// <returns></returns>
        private static List<Parameter> GetParameters(ColumnAlias columnAlias)
        {
            var parameters = new List<Parameter>
            {
                new Parameter("@langCode", columnAlias.LangCode),
                new Parameter("@colTableName", columnAlias.ColTableName),
                new Parameter("@colColumnName", columnAlias.ColColumnName),
                new Parameter("@colAliasName", columnAlias.ColAliasName),
                new Parameter("@lookupId", columnAlias.ColLookupId),
                new Parameter("@colCaption", columnAlias.ColCaption),
                new Parameter("@colDescription", columnAlias.ColDescription),
                new Parameter("@colSortOrder", columnAlias.ColSortOrder),
                new Parameter("@colIsReadOnly", columnAlias.ColIsReadOnly),
                new Parameter("@colIsVisible", columnAlias.ColIsVisible),
                new Parameter("@colIsDefault", columnAlias.ColIsDefault),
                new Parameter("@statusId", columnAlias.StatusId),
                new Parameter("@isGridColumn", columnAlias.IsGridColumn),
                new Parameter("@colGridAliasName",columnAlias.ColGridAliasName)
            };
            return parameters;
        }
    }
}