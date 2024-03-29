﻿//    Copyright (2016) Meridian Worldwide Transportation Group
//    All Rights Reserved Worldwide
//    ====================================================================================================================================================
//    Program Title:                                Meridian 4th Party Logistics(M4PL)
//    Programmer:                                   Janardana
//    Date Programmed:                              12/6/2016
//    Program Name:                                 _OrganisationChangedAndEnteredFormPartial
//    Purpose:                                      Contains classes related to Column Alias 

//    ====================================================================================================================================================

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class ColumnsAlias
    {
        public string ColColumnName { get; set; }
        public string ColAliasName { get; set; }
        public string ColCaption { get; set; }
        public string ColDescription { get; set; }
        public string ColCulture { get; set; }
        public bool ColIsVisible { get; set; }
        public bool ColIsDefault { get; set; }
    }

    public class SaveColumnsAlias
    {
        public string ColPageName { get; set; }
        public List<ColumnsAlias> LstColumnsAlias { get; set; }

        public SaveColumnsAlias(string pageName, List<ColumnsAlias> lstColumnsAlias)
        {
            this.ColPageName = pageName;
            this.LstColumnsAlias = lstColumnsAlias;
        }
    }
}
