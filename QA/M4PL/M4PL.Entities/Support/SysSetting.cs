#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 CommonCommands
// Purpose:                                      Contains commands to call DAL logic for like M4PL.DAL.Common.CommonCommands
//===================================================================================================================

using System.Collections.Generic;

namespace M4PL.Entities.Support
{
    /// <summary>
    /// Model class for System Settings
    /// </summary>
    public class SysSetting : SysRefModel
    {
        /// <summary>
        /// Gets or Sets Settings in Json format (Containes details like Theme, IsSysAdmin etc.)
        /// </summary>
        public string SysJsonSetting { get; set; }
        /// <summary>
        /// Gets or Sets UserIcon in VarBinary format
        /// </summary>
        public byte[] UserIcon { get; set; }
        /// <summary>
        /// Gets or Sets Reference Settings
        /// </summary>
        public IList<RefSetting> Settings { get; set; }
    }
}