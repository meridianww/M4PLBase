﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 VendBusinessTermCommands
Purpose:                                      Client to consume M4PL API called VendBusinessTermController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Vendor;

namespace M4PL.APIClient.Vendor
{
    public class VendBusinessTermCommands : BaseCommands<VendBusinessTermView>, IVendBusinessTermCommands
    {
        /// <summary>
        /// Route to call VendBusinessTerms
        /// </summary>
        public override string RouteSuffix
        {
            get { return "VendBusinessTerms"; }
        }
    }
}