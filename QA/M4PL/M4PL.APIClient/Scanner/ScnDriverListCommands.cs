﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana 
Date Programmed:                              28/07/2018
Program Name:                                 ScnDriverListCommands
Purpose:                                      Client to consume M4PL API called ScnDriverListController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScnDriverListCommands : BaseCommands<ViewModels.Scanner.ScnDriverListView>, IScnDriverListCommands
    {
        /// <summary>
        /// Route to call ScnDriverList
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScnDriverLists"; }
        }
    }
}