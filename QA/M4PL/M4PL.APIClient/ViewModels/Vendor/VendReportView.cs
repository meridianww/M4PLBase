/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 VendReportView
//Purpose:                                      Represents VendReport Details
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Vendor;

namespace M4PL.APIClient.ViewModels.Vendor
{
    public class VendReportView : VendReport
    {
        public VendReportView()
        {
        }

        public VendReportView(BaseReportModel baseReportModel) : base(baseReportModel)
        {
        }
    }
}