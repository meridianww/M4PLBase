/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ICustomerCommands
Purpose:                                      Set of rules for CustomerCommands
=============================================================================================================*/

using System.Collections.Generic;

namespace M4PL.Business.Customer
{
    /// <summary>
    /// Performs basic CRUD operation on the Customer Entity
    /// </summary>
    public interface ICustomerCommands : IBaseCommands<Entities.Customer.Customer>
    {
        List<Entities.Customer.Customer> GetActiveCutomers();
    }
}