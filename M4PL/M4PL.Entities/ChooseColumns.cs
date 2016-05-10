using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class ChooseColumns
    {
        public List<ColumnsChild> LstColumnName { get; set; }
        public List<ColumnsChild> LstDisplayColumnName { get; set; }
    }

    public class ColumnsMaster : ChooseColumns
    {
        public int ColMasterId { get; set; }
        public string ColTableName { get; set; }
        public string ColPageName { get; set; }
        public int ColUserId { get; set; }
    }

    public class ColumnsChild : ColumnsMaster
    {
        public int ColChildId { get; set; }
        public string ColColumnName { get; set; }
        public short ColSortOrder { get; set; }
    }

}
