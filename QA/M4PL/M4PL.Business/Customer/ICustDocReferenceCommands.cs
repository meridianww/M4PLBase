/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ICustDocReferenceCommands
Purpose:                                      Set of rules for CustDocReferenceCommands
=============================================================================================================*/

using M4PL.Entities.Customer;

namespace M4PL.Business.Customer
{
    /// <summary>
    /// Performs basic CRUD operation on the CustDocReference Entity
    /// </summary>
    public interface ICustDocReferenceCommands : IBaseCommands<CustDocReference>
    {
    }
}