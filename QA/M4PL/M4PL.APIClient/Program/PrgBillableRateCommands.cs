/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 PrgBillableRateCommands
Purpose:                                      Client to consume M4PL API called PrgBillableRateController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Program;

namespace M4PL.APIClient.Program
{
    public class PrgBillableRateCommands : BaseCommands<ProgramBillableRateView>, IPrgBillableRateCommands
    {
        /// <summary>
        /// Route to call PrgBillableRates
        /// </summary>
        public override string RouteSuffix
        {
            get { return "PrgBillableRates"; }
        }
    }
}