using M4PL.DataAccess.Serializer;
using M4PL.Entities;
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
        public static ColumnsChild GetAllColumns(string PageName)
        {
            ColumnsChild obj = new ColumnsChild();

            var set = new SetCollection();
            set.AddSet<ColumnsChild>("LstColumnName");
            set.AddSet<ColumnsChild>("LstDisplayColumnName");

            SqlSerializer.Default.DeserializeMultiSets(set, StoredProcedureNames.GetAllColumns, new Parameter("@PageName", PageName), storedProcedure: true);
            obj.LstColumnName = set.GetSet<ColumnsChild>("LstColumnName") ?? new List<ColumnsChild>();
            obj.LstDisplayColumnName = set.GetSet<ColumnsChild>("LstDisplayColumnName") ?? new List<ColumnsChild>();

            return obj;
            //return SqlSerializer.Default.DeserializeMultiRecords<ChooseColumns>(StoredProcedureNames.GetAllColumns, new Parameter("@PageName", PageName), false, true);
        }

        public static int SaveChoosedColumns(ColumnsChild obj)
        {
            DataTable dtColumnsList = SqlSerializer.Default.DeserializeDataTable<ColumnsChild>(obj.LstDisplayColumnName);
            dtColumnsList = dtColumnsList.DefaultView.ToTable("udtColumnsChild", true, "ColChildId", "ColColumnName", "ColSortOrder");
            var parameters = new Parameter[]
			{
				new Parameter("@ColumnsList", dtColumnsList, "dbo.udtColumnsChild"),
				new Parameter("@ColPageName",obj.ColPageName),
				new Parameter("@ColUserId",obj.ColUserId),
				new Parameter("@ColEnteredBy",""),
				new Parameter("@ColDateChangedBy","")
			};
            return SqlSerializer.Default.ExecuteRowCount(StoredProcedureNames.SaveChoosedColumns, parameters, true);
        }
    }
}
