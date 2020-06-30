/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScannerCommands
Purpose:                                      Client to consume M4PL API called ScannerController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Scanner;

namespace M4PL.APIClient.Scanner
{
    /// <summary>
    /// Route to call Scanners
    /// </summary>
    public class ScrReportCommands : BaseCommands<ScrReportView>, IScrReportCommands
    {
        public override string RouteSuffix
        {
            get { return "ScrReports"; }
        }
    }
}