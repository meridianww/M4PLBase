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
// Program Name:                                 Module
// Purpose:                                      Contains objects related to Module
//==========================================================================================================

namespace M4PL.Entities.Administration
{
    public class Module : BaseModel
    {
        /// <summary>
        /// Should get added into SYSTM000Ref_Options with LookupEnums.MainModule and should get Id back to set SysRefId for MenuDriver table
        /// And in MenuDriver
        /// </summary>
        public string MainModule { get; set; }

        /// <summary>
        /// Gets or sets menu in Menu Driver
        /// </summary>
        public string BreakDownStructure { get; set; }
    }
}