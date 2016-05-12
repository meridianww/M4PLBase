using M4PL.Entities;
using M4PL.Entities.DisplayModels;
using M4PL_API_DAL.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL_BAL
{
    public class BAL_ChooseColumns
    {
        public static disChooseColumns GetAllColumns(string PageName)
        {
            return DAL_ChooseColumns.GetAllColumns(PageName);
        }

        public static int SaveChoosedColumns(ChooseColumns value)
        {
            return DAL_ChooseColumns.SaveChoosedColumns(value);
        }
    }
}
