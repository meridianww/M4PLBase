/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Vendor Title:                                Meridian 4th Party Logistics(M4PL)
Vendormer:                                   Kirty Anurag
Date Vendormed:                              10/10/2017
Vendor Name:                                 VendorCommands
Purpose:                                      Client to consume M4PL API called VendorController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Vendor;

namespace M4PL.APIClient.Vendor
{
    /// <summary>
    /// Route to call Vendors
    /// </summary>
    public class VendReportCommands : BaseCommands<VendReportView>, IVendReportCommands
    {
        public override string RouteSuffix
        {
            get { return "VendReports"; }
        }
    }
}