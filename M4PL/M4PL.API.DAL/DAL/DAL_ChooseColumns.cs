//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              30/4/2016
//Program Name:                                 ChooseColumns
//Purpose:                                      Create, access, and review data from database for ChooseColumn
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
    public class DAL_ChooseColumns
    {
        /// <summary>
        /// Function to get all columns to display to select & unselect for grid.
        /// </summary>
        /// <param name="PageName"></param>
        /// <returns></returns>
        public static disChooseColumns GetAllColumns(string PageName, bool IsRestoreDefault = false)
        {
            disChooseColumns obj = new disChooseColumns();

            var set = new SetCollection();
            set.AddSet<Columns>("LstColumnName");
            set.AddSet<Columns>("LstDisplayColumnName");

            var parameters = new Parameter[]
			{
				new Parameter("@PageName", PageName),
				new Parameter("@IsRestoreDefault", IsRestoreDefault)
			};

            SqlSerializer.Default.DeserializeMultiSets(set, StoredProcedureNames.GetAllColumns, parameters, storedProcedure: true);
            obj.LstColumnName = set.GetSet<Columns>("LstColumnName") ?? new List<Columns>();
            obj.LstDisplayColumnName = set.GetSet<Columns>("LstDisplayColumnName") ?? new List<Columns>();

            return obj;
        }

        /// <summary>
        /// Function to save all selected columns to display to grid.
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int SaveChoosedColumns(ChooseColumns obj)
        {
            DataTable dtColumnsList = SqlSerializer.Default.DeserializeDataTable<Columns>(obj.LstDisplayColumnName);
            dtColumnsList = dtColumnsList.DefaultView.ToTable("udtColumnOrdering", true, "ColColumnName", "ColSortOrder");
            var parameters = new Parameter[]
			{
				new Parameter("@ColumnsList", dtColumnsList, "dbo.udtColumnOrdering"),
				new Parameter("@ColPageName",obj.ColPageName),
				new Parameter("@ColUserId",obj.ColUserId),
				new Parameter("@ColEnteredBy",""),
				new Parameter("@ColDateChangedBy","")
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.SaveChoosedColumns, parameters, true);
        }
    }
}
