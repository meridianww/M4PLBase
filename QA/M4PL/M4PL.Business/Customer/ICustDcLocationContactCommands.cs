/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ICustDcLocationContactCommands
Purpose:                                      Set of rules for CustDcLocationContactCommands
=============================================================================================================*/

using M4PL.Entities.Customer;
using M4PL.Entities.Support;

namespace M4PL.Business.Customer
{
    /// <summary>
    /// performs basic CRUD operation on the CustDcLocationContact Entity
    /// </summary>
    public interface ICustDcLocationContactCommands : IBaseCommands<CustDcLocationContact>
    {
        CustDcLocationContact GetCustDcLocationContact(ActiveUser activeUser, long id, long? parentId);
    }
}
