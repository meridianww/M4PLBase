/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana 
Date Programmed:                              28/07/2018
Program Name:                                 ScnOrderOSDCommands
Purpose:                                      Client to consume M4PL API called ScnOrderOSDController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScnOrderOSDCommands : BaseCommands<ViewModels.Scanner.ScnOrderOSDView>, IScnOrderOSDCommands
    {
        /// <summary>
        /// Route to call ScnOrderOSD
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScnOrderOSDs"; }
        }
    }
}