/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 PrgEdiMappingCommands
Purpose:                                      Client to consume M4PL API called PrgEdiMappingController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Program;

namespace M4PL.APIClient.Program
{
    public class PrgEdiMappingCommands : BaseCommands<PrgEdiMappingView>, IPrgEdiMappingCommands
    {
        /// <summary>
        /// Route to call PrgEdiMappings
        /// </summary>
        public override string RouteSuffix
        {
            get { return "PrgEdiMappings"; }
        }
    }
}