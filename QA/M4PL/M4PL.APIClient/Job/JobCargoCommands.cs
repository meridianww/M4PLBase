﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobCargoCommands
Purpose:                                      Client to consume M4PL API called JobCargoController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{
    public class JobCargoCommands : BaseCommands<JobCargoView>, IJobCargoCommands
    {
        /// <summary>
        /// Route to call JobCargos
        /// </summary>
        public override string RouteSuffix
        {
            get { return "JobCargos"; }
        }
    }
}