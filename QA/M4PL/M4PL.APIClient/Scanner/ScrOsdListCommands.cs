/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScrOsdListCommands
Purpose:                                      Client to consume M4PL API called ScrOsdListController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScrOsdListCommands : BaseCommands<M4PL.APIClient.ViewModels.Scanner.ScrOsdListView>, IScrOsdListCommands
    {
        /// <summary>
        /// Route to call ScrOsdList
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScrOsdLists"; }
        }
    }
}