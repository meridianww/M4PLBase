/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrServiceListCommands
Purpose:                                      Client to consume M4PL API called ScrServiceListController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScrServiceListCommands : BaseCommands<M4PL.APIClient.ViewModels.Scanner.ScrServiceListView>, IScrServiceListCommands
    {
        /// <summary>
        /// Route to call ScrServiceList
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScrServiceLists"; }
        }
    }
}