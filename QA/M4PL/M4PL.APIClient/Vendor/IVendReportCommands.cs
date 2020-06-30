/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Vendor Title:                                Meridian 4th Party Logistics(M4PL)
Vendormer:                                   Kirty Anurag
Date Vendormed:                              10/10/2017
Vendor Name:                                 IVendorCommands
Purpose:                                      Set of rules for VendorCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Vendor;

namespace M4PL.APIClient.Vendor
{
    /// <summary>
    /// Performs basic CRUD operation on the Vendor Entity
    /// </summary>
    public interface IVendReportCommands : IBaseCommands<VendReportView>
    {
    }
}