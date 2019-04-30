/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CommonCommands
Purpose:                                      Contains commands to call DAL logic for like M4PL.DAL.Common.CommonCommands
===================================================================================================================*/

using System.Collections.Generic;

namespace M4PL.Entities.Support
{
    public class SysSetting : SysRefModel
    {
        public string SysJsonSetting { get; set; }
        public byte[] UserIcon { get; set; }
        public IList<RefSetting> Settings { get; set; }
    }
}