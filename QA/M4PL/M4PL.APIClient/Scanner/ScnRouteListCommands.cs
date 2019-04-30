/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana 
Date Programmed:                              28/07/2018
Program Name:                                 ScnRouteListCommands
Purpose:                                      Client to consume M4PL API called ScnRouteListController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScnRouteListCommands : BaseCommands<ViewModels.Scanner.ScnRouteListView>, IScnRouteListCommands
    {
        /// <summary>
        /// Route to call ScnRouteList
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScnRouteLists"; }
        }
    }
}