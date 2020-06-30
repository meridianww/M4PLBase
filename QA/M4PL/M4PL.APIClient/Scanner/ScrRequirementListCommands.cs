/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 ScrRequirementListCommands
Purpose:                                      Client to consume M4PL API called ScrRequirementListController
=================================================================================================================*/

namespace M4PL.APIClient.Scanner
{
    public class ScrRequirementListCommands : BaseCommands<M4PL.APIClient.ViewModels.Scanner.ScrRequirementListView>, IScrRequirementListCommands
    {
        /// <summary>
        /// Route to call ScrRequirementList
        /// </summary>
        public override string RouteSuffix
        {
            get { return "ScrRequirementLists"; }
        }
    }
}