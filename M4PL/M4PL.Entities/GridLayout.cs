//    Copyright (2016) Meridian Worldwide Transportation Group
//    All Rights Reserved Worldwide
//    ====================================================================================================================================================
//    Program Title:                                Meridian 4th Party Logistics(M4PL)
//    Programmer:                                   Janardana
//    Date Programmed:                              5/4/2016
//    Program Name:                                 _OrganisationChangedAndEnteredFormPartial
//    Purpose:                                      Contains classes related to Grid Layout 

//    ====================================================================================================================================================

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class GridLayout
    {
        public string PageName { get; set; }
        public int UserId { get; set; }
        public string Layout { get; set; }

        public GridLayout()
        {

        }

        public GridLayout(string pageName, int userId, string layout)
        {
            this.PageName = pageName;
            this.Layout = layout;
            this.UserId = userId;
        }
    }
}
