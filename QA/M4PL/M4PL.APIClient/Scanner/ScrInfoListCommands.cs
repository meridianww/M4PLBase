/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana 
Date Programmed:                              28/07/2018
Program Name:                                 ScrInfoListCommands
Purpose:                                      Client to consume M4PL API called ScrInfoListController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScrInfoListCommands : BaseCommands<ViewModels.Scanner.ScrInfoListView>, IScrInfoListCommands
    {
        /// <summary>
        /// Route to call ScrInfoList
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScrInfoLists"; }
        }
    }
}