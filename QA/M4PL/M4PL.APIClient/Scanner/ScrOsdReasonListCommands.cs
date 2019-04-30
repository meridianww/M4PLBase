/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrOsdReasonListCommands
Purpose:                                      Client to consume M4PL API called ScrOsdReasonListController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScrOsdReasonListCommands : BaseCommands<M4PL.APIClient.ViewModels.Scanner.ScrOsdReasonListView>, IScrOsdReasonListCommands
    {
        /// <summary>
        /// Route to call ScrOsdReasonList
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScrOsdReasonLists"; }
        }
    }
}