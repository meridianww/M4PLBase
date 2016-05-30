//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              8/4/2016
//Program Name:                                 RefOptions
//Purpose:                                      Create, access, and review data from database for Dropdowns
//
//==================================================================================================================================================== 

using M4PL.DataAccess.Serializer;
using M4PL.Entities;
using M4PL.Entities.DisplayModels;
using M4PL_API_CommonUtils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_API_DAL.DAL
{
    public class DAL_RefOptions
    {
        /// <summary>
        /// Function to dropdown options for forms
        /// </summary>
        /// <param name="TableName"></param>
        /// <param name="ColumnName"></param>
        /// <returns></returns>
        public static List<disRefOptions> GetRefOptions(string TableName, string ColumnName)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@TableName",TableName),
				new Parameter("@ColumnName",ColumnName)
            };

            return SqlSerializer.Default.DeserializeMultiRecords<disRefOptions>(StoredProcedureNames.GetRefOptions, parameters, false, true);
        }

        /// <summary>
        /// Function to save the Layout Grid
        /// </summary>
        /// <param name="pagename"></param>
        /// <param name="strLayout"></param>
        /// <returns></returns>
        public static int SaveGridLayout(string pagename, string strLayout, int userid)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@Pagename",pagename),
				new Parameter("@Layout",strLayout),
				new Parameter("@UserID",userid)               		
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.SaveGridLayout, parameters, true);
        }

        /// <summary>
        /// Function to get saved Layout Grid
        /// </summary>
        /// <param name="pagename"></param>
        /// <param name="userid"></param>
        /// <returns></returns>
        public static string GetSavedGridLayout(string pagename, int userid)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@Pagename",pagename),
				new Parameter("@UserID",userid)               		
			};
            return SqlSerializer.Default.ExecuteScalar<string>(StoredProcedureNames.GetSavedGridLayout, parameters, false, true);
        }


        public static int SaveAliasColumn(SaveColumnsAlias obj)
        {
            DataTable dtColumnsList = SqlSerializer.Default.DeserializeDataTable<ColumnsAlias>(obj.LstColumnsAlias);
            dtColumnsList = dtColumnsList.DefaultView.ToTable("udtColumnAliases", true, "ColColumnName", "ColAliasName", "ColCaption", "ColDescription", "ColIsVisible", "ColIsDefault");
            var parameters = new Parameter[]
			{
				new Parameter("@ColumnsList", dtColumnsList, "dbo.udtColumnAliases"),
				new Parameter("@PageName",obj.ColPageName)
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.SaveColumnsAlias, parameters, true);
        }

        public static List<ColumnsAlias> GetAllColumnAliases(string pagename)
        {
            return SqlSerializer.Default.DeserializeMultiRecords<ColumnsAlias>(StoredProcedureNames.GetAllColumnAliases, new Parameter("@PageName", pagename), false, true);
        }

        public static long GetNextPrevValue(string pageName, long id, short options = 0)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@Pagename",pageName),
				new Parameter("@Option",options),
				new Parameter("@CurrentId",id)               		
			};
            return SqlSerializer.Default.ExecuteScalar<long>(StoredProcedureNames.GetNextPrevValue, parameters, false, true);
        }
    }
}
