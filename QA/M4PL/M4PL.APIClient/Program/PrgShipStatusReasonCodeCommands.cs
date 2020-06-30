/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 PrgShipStatusReasonCodeCommands
Purpose:                                      Client to consume M4PL API called PrgShipStatusReasonCodeController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Program;

namespace M4PL.APIClient.Program
{
    public class PrgShipStatusReasonCodeCommands : BaseCommands<PrgShipStatusReasonCodeView>, IPrgShipStatusReasonCodeCommands
    {
        /// <summary>
        /// Route to call PrgShipStatusReasonCodes
        /// </summary>
        public override string RouteSuffix
        {
            get { return "PrgShipStatusReasonCodes"; }
        }
    }
}