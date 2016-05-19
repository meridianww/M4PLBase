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
using M4PL_API_CommonUtils;
using System;
using System.Collections.Generic;
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

    }
}
