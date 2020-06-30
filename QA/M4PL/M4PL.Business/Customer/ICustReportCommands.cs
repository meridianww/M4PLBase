/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ICustReportCommands
Purpose:                                      Set of rules for CustReportCommands
=============================================================================================================*/
using M4PL.Entities.Customer;

namespace M4PL.Business.Customer
{
    /// <summary>
    /// Performs Reports for Customer
    /// </summary>
    public interface ICustReportCommands : IBaseCommands<CustReport>
    {
    }
}