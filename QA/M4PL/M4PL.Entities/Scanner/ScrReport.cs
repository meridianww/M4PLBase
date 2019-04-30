/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrReport
Purpose:                                      Contains objects related to ScrReport
==========================================================================================================*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Scanner
{
    public class ScrReport : BaseReportModel
    {
        public ScrReport()
        {
        }

        public ScrReport(BaseReportModel baseReportModel) : base(baseReportModel)
        {
        }
    }
}
