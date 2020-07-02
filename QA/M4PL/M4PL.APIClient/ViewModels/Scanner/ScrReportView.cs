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
// Program Name:                                 ScrReportView
// Purpose:                                      Represents ScrReport Details
//====================================================================================================================================================

using M4PL.Entities;
using M4PL.Entities.Scanner;

namespace M4PL.APIClient.ViewModels.Scanner
{
    public class ScrReportView : ScrReport
    {
        public ScrReportView()
        {
        }

        public ScrReportView(BaseReportModel baseReportModel) : base(baseReportModel)
        {
        }
    }
}
