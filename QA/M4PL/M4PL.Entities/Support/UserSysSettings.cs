/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CommonCommands
Purpose:                                      Contains commands to call DAL logic for like M4PL.DAL.Common.CommonCommands
===================================================================================================================*/

namespace M4PL.Entities.Support
{
    public class UserSysSetting : SysRefModel
    {
        public int SysMainModuleId { get; set; }
        public string SysDefaultAction { get; set; }
        public string SysStatusesIn { get; set; }
        public string SysGridViewPageSizes { get; set; }
        public int SysPageSize { get; set; }
        public int SysComboBoxPageSize { get; set; }

        public byte[] UserIcon { get; set; }

        public string Theme { get; set; }
    }
}