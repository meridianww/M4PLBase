using DevExpress.Web.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DOSample.Models
{
    public class GridResult<TView>
    {
        public GridResult()
        {
            Records = new List<TView>();
            ColumnSettings = new List<ColumnSetting>();
        }

        public GridViewModel GridViewModel { get; set; }

        public IList<TView> Records { get; set; }

        public string PageName { get; set; }

        public byte[] Icon { get; set; }

        public IList<ColumnSetting> ColumnSettings { get; set; }
    }
}