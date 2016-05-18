//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Janardana
//Date Programmed:                              8/4/2016
//Program Name:                                 User
//Purpose:                                      Business Logic for Dropdownlist
//
//==================================================================================================================================================== 

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
        /// <summary>
        /// Function to dropdown options for forms
        /// </summary>
        /// <param name="TableName"></param>
        /// <param name="ColumnName"></param>
        /// <returns></returns>
        public static List<disRefOptions> GetRefOptions(string TableName, string ColumnName)
        {
            return DAL_RefOptions.GetRefOptions(TableName, ColumnName);
        }

        /// <summary>
        /// Function to save the Layout Grid
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static int SaveGridLayout(string pagename, string strLayout, int userid)
        {
            return DAL_RefOptions.SaveGridLayout(pagename, strLayout, userid);
        }
    }
}
