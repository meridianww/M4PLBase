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
        public static disChooseColumns GetAllColumns(string PageName)
        {
            disChooseColumns obj = new disChooseColumns();

            var set = new SetCollection();
            set.AddSet<Columns>("LstColumnName");
            set.AddSet<Columns>("LstDisplayColumnName");

            SqlSerializer.Default.DeserializeMultiSets(set, StoredProcedureNames.GetAllColumns, new Parameter("@PageName", PageName), storedProcedure: true);
            obj.LstColumnName = set.GetSet<Columns>("LstColumnName") ?? new List<Columns>();
            obj.LstDisplayColumnName = set.GetSet<Columns>("LstDisplayColumnName") ?? new List<Columns>();

            return obj;
        }

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
