/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ICustFinancialCalendarCommands
Purpose:                                      Set of rules for CustFinancialCalendar
=============================================================================================================*/

using M4PL.Entities.Customer;

namespace M4PL.Business.Customer
{
    /// <summary>
    /// Perform basic CRUD operation on the CustFinancialCalendar Entity
    /// </summary>
    public interface ICustFinancialCalendarCommands : IBaseCommands<CustFinancialCalendar>
    {
    }
}