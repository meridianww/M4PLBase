using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DevExpress.Web.Mvc;
using System.Web.Mvc;
using M4PL_API_CommonUtils;

namespace M4PL_Apln.Models
{
    public class Settings
    {
        public static void SetFilterRowVisibility(MVCxGridView grid, bool visible)
        {
            grid.Settings.ShowFilterRow = visible;
        }
    }
}