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
// Programmer:                                   Janardana 
// Date Programmed:                              05/29/2018
// Program Name:                                 Contact Combobox
// Purpose:                                      Contains objects related to Contact Combobox
//==========================================================================================================

namespace M4PL.Entities.Support
{
    public class ContactComboBox
    {
        public long Id { get; set; }
        public string ConFullName { get; set; }
        public string ConJobTitle { get; set; }
        public string ConOrgIdName { get; set; }
        public string ConFileAs { get; set; }
        public int StatusId { get; set; }
    }
}
