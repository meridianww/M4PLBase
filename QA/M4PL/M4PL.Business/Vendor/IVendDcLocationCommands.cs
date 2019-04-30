/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IVendDcLocationCommands
Purpose:                                      Set of rules for VendDcLocationCommands
=============================================================================================================*/

using M4PL.Entities.Vendor;

namespace M4PL.Business.Vendor
{
    /// <summary>
    /// Performs basic CRUD operation on the VendDcLocation Entity
    /// </summary>
    public interface IVendDcLocationCommands : IBaseCommands<VendDcLocation>
    {
    }
}