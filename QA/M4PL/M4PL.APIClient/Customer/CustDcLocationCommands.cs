/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 CustDcLocationCommands
Purpose:                                      Client to consume M4PL API called CustDcLocationController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Customer;

namespace M4PL.APIClient.Customer
{
    public class CustDcLocationCommands : BaseCommands<CustDcLocationView>, ICustDcLocationCommands
    {
        /// <summary>
        ///  Route to call Customer Dc locations
        /// </summary>
        public override string RouteSuffix
        {
            get { return "CustDcLocations"; }
        }
    }
}