/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              09/25/2018
Program Name:                                 IVendDcLocationContactCommands
Purpose:                                      Set of rules for VendDcLocationContactCommands
=============================================================================================================*/
using M4PL.APIClient.ViewModels.Vendor;

namespace M4PL.APIClient.Vendor
{
    /// <summary>
    /// Performs basic CRUD operation on the VendDcLocationContact Entity
    /// </summary>
    public interface IVendDcLocationContactCommands : IBaseCommands<VendDcLocationContactView>
    {
        VendDcLocationContactView Get(long id, long? parentId);
    }
}
