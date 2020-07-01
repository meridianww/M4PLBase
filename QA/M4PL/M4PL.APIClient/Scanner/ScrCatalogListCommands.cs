/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScrCatalogListCommands
Purpose:                                      Client to consume M4PL API called ScrCatalogListController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScrCatalogListCommands : BaseCommands<M4PL.APIClient.ViewModels.Scanner.ScrCatalogListView>, IScrCatalogListCommands
    {
        /// <summary>
        /// Route to call ScrCatalogList
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScrCatalogLists"; }
        }
    }
}