﻿#region Copyright
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
// Program Name:                                 UserSecurity
// Purpose:                                      Contains objects related to UserSecurity
//==========================================================================================================

using System.Collections.Generic;

namespace M4PL.Entities.Support
{
    /// <summary>
    ///
    /// </summary>
    public class UserSecurity
    {
        public UserSecurity()
        {
            UserSubSecurities = new List<UserSubSecurity>();
        }

        public long Id { get; set; }
        public int SecMainModuleId { get; set; }
        public int SecMenuOptionLevelId { get; set; }
        public int SecMenuAccessLevelId { get; set; }
        public IList<UserSubSecurity> UserSubSecurities { get; set; }
    }
}