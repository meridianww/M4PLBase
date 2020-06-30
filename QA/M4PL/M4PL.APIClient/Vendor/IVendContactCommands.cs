/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IVendContactCommands
Purpose:                                      Set of rules for IVendContactCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Vendor;

namespace M4PL.APIClient.Vendor
{
    /// <summary>
    /// Performs basic CRUD operation on the VendContact Entity
    /// </summary>
    public interface IVendContactCommands : IBaseCommands<VendContactView>
    {
    }
}