using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.DisplayModels
{
    public class disChooseColumns
    {
        public List<Columns> LstColumnName { get; set; }
        public List<Columns> LstDisplayColumnName { get; set; }
        public string ColOrderingQuery { get; set; }
    }

    public class Columns
    {
        public string ColColumnName { get; set; }
        public short ColSortOrder { get; set; }
        public string ColAliasName { get; set; }
        public string ColCaption { get; set; }
        public bool ColIsDefault { get; set; }
        public bool ColIsVisible { get; set; }
    }
}
