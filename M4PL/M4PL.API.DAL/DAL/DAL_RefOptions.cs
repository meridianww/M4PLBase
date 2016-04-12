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
        public static List<disRefOptions> GetRefOptions(string TableName, string ColumnName)
        {
            var parameters = new Parameter[]
			{
				new Parameter("@TableName",TableName),
				new Parameter("@ColumnName",ColumnName)
            };

            return SqlSerializer.Default.DeserializeMultiRecords<disRefOptions>(StoredProcedureNames.GetRefOptions, parameters, false, true);
        }
    }
}
