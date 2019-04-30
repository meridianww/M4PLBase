/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobRefCostSheetCommands
Purpose:                                      Client to consume M4PL API called JobRefCostSheetController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{
    public class JobRefCostSheetCommands : BaseCommands<JobRefCostSheetView>, IJobRefCostSheetCommands
    {
        /// <summary>
        /// Route to call JobRefCostSheet
        /// </summary>
        public override string RouteSuffix
        {
            get { return "JobRefCostSheets"; }
        }
    }
}