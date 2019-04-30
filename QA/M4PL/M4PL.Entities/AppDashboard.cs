/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 AppDashboard
Purpose:                                      Contains objects related to AppDashboard
==========================================================================================================*/
using System;

namespace M4PL.Entities
{
    public class AppDashboard : BaseModel
    {
        public int DshMainModuleId { get; set; }

        public byte[] DshTemplate { get; set; }

        public string DshDescription { get; set; }

        public string DshName { get; set; }

        bool? dshIsDefault;
        public bool? DshIsDefault { get { return dshIsDefault; } set { dshIsDefault = value == null ? false : value; } }
    }
}