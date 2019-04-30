/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 UserSubSecurity
Purpose:                                      Contains objects related to UserSubSecurity
==========================================================================================================*/

namespace M4PL.Entities.Support
{
    public class UserSubSecurity
    {
        public long SecByRoleId { get; set; }
        public string RefTableName { get; set; }
        public int SubsMenuOptionLevelId { get; set; }
        public int SubsMenuAccessLevelId { get; set; }
    }
}