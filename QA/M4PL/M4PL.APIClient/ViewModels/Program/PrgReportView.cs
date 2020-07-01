/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              13/10/2017
//Program Name:                                 PrgReportView
//Purpose:                                      Represents PrgReport Details
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Program;

namespace M4PL.APIClient.ViewModels.Program
{
    public class PrgReportView : PrgReport
    {
        public PrgReportView()
        {
        }

        public PrgReportView(BaseReportModel baseReportModel) : base(baseReportModel)
        {
        }
    }
}