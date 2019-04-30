/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 PageControlResult
//Purpose:                                      Represents description for Page Control Result of the system
//====================================================================================================================================================*/

using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Web.Models
{
    public class PageControlResult
    {
        public bool IsPopup { get; set; }

        public IList<PageInfo> PageInfos { get; set; }

        public MvcRoute CallBackRoute { get; set; }

        public string ParentUniqueName { get; set; }

        public int SelectedTabIndex { get; set; }

        public bool EnableTabClick { get; set; }
    }
}