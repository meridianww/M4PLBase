/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ScrReturnReasonListCommands
Purpose:                                      Client to consume M4PL API called ScrReturnReasonListController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScrReturnReasonListCommands : BaseCommands<M4PL.APIClient.ViewModels.Scanner.ScrReturnReasonListView>, IScrReturnReasonListCommands
    {
        /// <summary>
        /// Route to call ScrReturnReasonList
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScrReturnReasonLists"; }
        }
    }
}