﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 VendDcLocationCommands
Purpose:                                      Client to consume M4PL API called VendDcLocationController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Vendor;

namespace M4PL.APIClient.Vendor
{
    public class VendDcLocationCommands : BaseCommands<VendDcLocationView>, IVendDcLocationCommands
    {
        /// <summary>
        /// Route to call VendDcLocations
        /// </summary>
        public override string RouteSuffix
        {
            get { return "VendDcLocations"; }
        }
    }
}