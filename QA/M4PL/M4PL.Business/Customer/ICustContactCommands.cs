/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ICustContactCommands
Purpose:                                      Set of rules for CustContactCommands
=============================================================================================================*/

using M4PL.Entities.Customer;

namespace M4PL.Business.Customer
{
    /// <summary>
    /// Performs basic CRUD operation on CustContact Entity
    /// </summary>
    public interface ICustContactCommands : IBaseCommands<CustContact>
    {
    }
}