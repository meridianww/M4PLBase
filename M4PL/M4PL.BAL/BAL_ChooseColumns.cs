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
        /// <summary>
        /// Function to get all columns to display to select & unselect for grid.
        /// </summary>
        /// <param name="PageName"></param>
        /// <returns></returns>
        public static disChooseColumns GetAllColumns(string PageName)
        {
            return DAL_ChooseColumns.GetAllColumns(PageName);
        }

        /// <summary>
        /// Function to save all selected columns to display to grid.
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int SaveChoosedColumns(ChooseColumns value)
        {
            return DAL_ChooseColumns.SaveChoosedColumns(value);
        }
    }
}
