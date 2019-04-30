﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana 
Date Programmed:                              28/07/2018
Program Name:                                 ScnCargoDetailCommands
Purpose:                                      Client to consume M4PL API called ScnCargoDetailController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScnCargoDetailCommands : BaseCommands<ViewModels.Scanner.ScnCargoDetailView>, IScnCargoDetailCommands
    {
        /// <summary>
        /// Route to call ScnCargoDetail
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScnCargoDetails"; }
        }
    }
}