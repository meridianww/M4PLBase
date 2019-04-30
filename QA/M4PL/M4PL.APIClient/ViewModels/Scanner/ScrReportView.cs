/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 ScrReportView
//Purpose:                                      Represents ScrReport Details
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Scanner;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
