/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 PrgShipApptmtReasonCodeCommands
Purpose:                                      Client to consume M4PL API called PrgShipApptmtReasonCodeController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Program;

namespace M4PL.APIClient.Program
{
    public class PrgShipApptmtReasonCodeCommands : BaseCommands<PrgShipApptmtReasonCodeView>, IPrgShipApptmtReasonCodeCommands
    {
        /// <summary>
        /// Route to call PrgShipAppmtReasonCodes
        /// </summary>
        public override string RouteSuffix
        {
            get { return "PrgShipApptmtReasonCodes"; }
        }
    }
}