/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 OrgReportView
//Purpose:                                      Represents OrgReport Details
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Organization;

namespace M4PL.APIClient.ViewModels.Organization
{
    public class OrgReportView : OrgReport
    {
        public OrgReportView()
        {
        }

        public OrgReportView(BaseReportModel baseReportModel) : base(baseReportModel)
        {
        }
    }
}