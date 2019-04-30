/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CommonCommands
Purpose:                                      Contains commands to call DAL logic for like M4PL.DAL.Common.CommonCommands
===================================================================================================================*/

namespace M4PL.Entities.Administration
{
    public class SysSetting : Support.UserSysSetting
    {
        public int SysSessionTimeOut { get; set; }

        public int SysWarningTime { get; set; }

        public int SysThresholdPercentage { get; set; }

        public string SysDateFormat { get; set; }
    }
}