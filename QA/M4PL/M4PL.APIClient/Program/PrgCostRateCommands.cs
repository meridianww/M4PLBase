﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 PrgCostRateCommands
Purpose:                                      Client to consume M4PL API called PrgCostRateController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Program;

namespace M4PL.APIClient.Program
{
    public class PrgCostRateCommands : BaseCommands<ProgramCostRateView>, IPrgCostRateCommands
    {
        /// <summary>
        /// Route to call PrgCostRates
        /// </summary>
        public override string RouteSuffix
        {
            get { return "PrgCostRates"; }
        }
    }
}