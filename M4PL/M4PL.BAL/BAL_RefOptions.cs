using M4PL.Entities;
using M4PL_API_DAL.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_BAL
{
    public class BAL_RefOptions
    {
        public static List<disRefOptions> GetRefOptions(string TableName, string ColumnName)
        {
            return DAL_RefOptions.GetRefOptions(TableName, ColumnName);
        }
    }
}
