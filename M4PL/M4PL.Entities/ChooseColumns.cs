using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class disChooseColumns
    {
        public List<Columns> LstColumnName { get; set; }
        public List<Columns> LstDisplayColumnName { get; set; }
    }

    public class ChooseColumns : disChooseColumns
    {
        public int ColColumnOrderId { get; set; }
        public int ColColumnSortId { get; set; }
        public string ColTableName { get; set; }
        public string ColPageName { get; set; }
        public int ColUserId { get; set; }
        public string ColColumnName { get; set; }
        public short ColSortOrder { get; set; }
        public string ColSortColumn { get; set; }
        public string ColAliasName { get; set; }
    }

    public class Columns
    {
        public string ColColumnName { get; set; }
        public short ColSortOrder { get; set; }
        public string ColAliasName { get; set; }
    }

}
