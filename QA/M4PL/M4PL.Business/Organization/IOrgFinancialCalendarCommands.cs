/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IOrgFinancialCalendarCommands
Purpose:                                      Set of rules for OrgFinancialCalendarCommands
=============================================================================================================*/

using M4PL.Entities.Organization;

namespace M4PL.Business.Organization
{
    /// <summary>
    /// Performs basic CRUD operation on the OrgFinancialCalendar Entity
    /// </summary>
    public interface IOrgFinancialCalendarCommands : IBaseCommands<OrgFinancialCalendar>
    {
    }
}