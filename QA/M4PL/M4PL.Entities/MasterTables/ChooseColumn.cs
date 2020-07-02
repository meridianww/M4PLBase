#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 ChooseColumn
// Purpose:                                      Contains objects related to ChooseColumn
//==========================================================================================================
namespace M4PL.Entities.MasterTables
{
    public class ChooseColumn
    {
        public long? ParentId { get; set; }
        public string Title { get; set; }
        public string Available { get; set; }
        public string Show { get; set; }
        public string FreezeColumn { get; set; }
        public string RemoveFreezeColumn { get; set; }
        public string GroupBy { get; set; }
        public string FreezeColumnDesc { get; set; }
        public string MandatoryFieldDesc { get; set; }
        public bool ShowGrouping { get; set; } //this is to show grouping options in choose column
    }
}