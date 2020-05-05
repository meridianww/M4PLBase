/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 DashboardResult
//Purpose:                                      Represents description for Dashboard results of the system
//====================================================================================================================================================*/

using DevExpress.DashboardWeb.Mvc;
using M4PL.Entities.Support;

namespace M4PL.Web.Models
{
    public class DashboardResult<TView> : ViewResult
    {
        public MvcRoute DashboardRoute { get; set; }
        //public DashboardSourceModel DashboardSourceModel { get; set; }
        public DevExpress.DashboardWeb.WorkingMode WorkingMode { get; set; }
    }
}