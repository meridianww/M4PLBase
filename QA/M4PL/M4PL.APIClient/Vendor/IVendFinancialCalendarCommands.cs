﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IVendFinancialCalendarCommands
Purpose:                                      Set of rules for VendFinancialCalendarCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Vendor;

namespace M4PL.APIClient.Vendor
{
    /// <summary>
    /// Performs basic CRUD operation on the VendFinancialCalendar Entity
    /// </summary>
    public interface IVendFinancialCalendarCommands : IBaseCommands<VendFinancialCalendarView>
    {
    }
}