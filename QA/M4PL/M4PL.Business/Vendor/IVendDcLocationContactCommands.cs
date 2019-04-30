/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IVendDcLocationContactCommands
Purpose:                                      Set of rules for VendDcLocationContactCommands
=============================================================================================================*/

using M4PL.Entities.Support;
using M4PL.Entities.Vendor;

namespace M4PL.Business.Vendor
{
    /// <summary>
    /// performs basic CRUD operation on the VendDcLocationContact Entity
    /// </summary>
    public interface IVendDcLocationContactCommands : IBaseCommands<VendDcLocationContact>
    {
        VendDcLocationContact GetVendDcLocationContact(ActiveUser activeUser, long id, long? parentId);
    }
}
