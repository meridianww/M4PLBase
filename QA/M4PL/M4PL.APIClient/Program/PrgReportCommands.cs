/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ProgramCommands
Purpose:                                      Client to consume M4PL API called ProgramController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Program;

namespace M4PL.APIClient.Program
{
    /// <summary>
    /// Route to call Programs
    /// </summary>
    public class PrgReportCommands : BaseCommands<PrgReportView>, IPrgReportCommands
    {
        public override string RouteSuffix
        {
            get { return "PrgReports"; }
        }
    }
}