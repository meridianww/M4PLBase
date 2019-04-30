/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana 
Date Programmed:                              28/07/2018
Program Name:                                 ScnOrderServiceCommands
Purpose:                                      Client to consume M4PL API called ScnOrderServiceController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScnOrderServiceCommands : BaseCommands<ViewModels.Scanner.ScnOrderServiceView>, IScnOrderServiceCommands
    {
        /// <summary>
        /// Route to call ScnOrderService
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScnOrderServices"; }
        }
    }
}