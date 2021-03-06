﻿//    Copyright (2016) Meridian Worldwide Transportation Group
//    All Rights Reserved Worldwide
//    ====================================================================================================================================================
//    Program Title:                                Meridian 4th Party Logistics(M4PL)
//    Programmer:                                   Janardana
//    Date Programmed:                              13/5/2016
//    Program Name:                                 _OrganisationChangedAndEnteredFormPartial
//    Purpose:                                      Contains classes related to Choose Columns 

//    ====================================================================================================================================================

using M4PL.Entities.DisplayModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
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

    

}
