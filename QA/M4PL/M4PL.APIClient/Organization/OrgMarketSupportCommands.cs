/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 OrgMarketSupportCommands
Purpose:                                      Client to consume M4PL API called OrgMarketSupportController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Organization;

namespace M4PL.APIClient.Organization
{
    public class OrgMarketSupportCommands : BaseCommands<OrgMarketSupportView>, IOrgMarketSupportCommands
    {
        /// <summary>
        /// Route to call OrgMarketSuppports
        /// </summary>
        public override string RouteSuffix
        {
            get { return "OrgMarketSupports"; }
        }
    }
}