#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/13/2017
//Program Name:                                 DashboardResult
//Purpose:                                      Represents description for Dashboard results of the system
//====================================================================================================================================================*/

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