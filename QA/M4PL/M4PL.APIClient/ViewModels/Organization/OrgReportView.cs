#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              13/10/2017
// Program Name:                                 OrgReportView
// Purpose:                                      Represents OrgReport Details
//====================================================================================================================================================

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