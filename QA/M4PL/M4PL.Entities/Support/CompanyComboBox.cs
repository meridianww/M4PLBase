#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright


//
//====================================================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              07/11/2019
// Program Name:                                 Company ComboBox
// Purpose:                                      Contains objects related to Company Combobox
//====================================================================================================================================================
namespace M4PL.Entities.Support
{
    public class CompanyComboBox
    {
        public long Id { get; set; }
        public string CompTitle { get; set; }
        public string CompCode { get; set; }
        public string CompTableName { get; set; }
    }
}
