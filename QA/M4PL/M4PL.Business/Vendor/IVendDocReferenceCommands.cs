/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IVendDocReferenceCommands
Purpose:                                      Set of rules for VendDocReferenceCommands
=============================================================================================================*/

using M4PL.Entities.Vendor;

namespace M4PL.Business.Vendor
{
    /// <summary>
    /// Performs basic CRUD operation on the VendDocReference Entity
    /// </summary>
    public interface IVendDocReferenceCommands : IBaseCommands<VendDocReference>
    {
    }
}