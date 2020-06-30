/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 VendDocReferenceCommands
Purpose:                                      Client to consume M4PL API called VendDocReferenceController
=================================================================================================================*/

using M4PL.APIClient.ViewModels.Vendor;

namespace M4PL.APIClient.Vendor
{
    public class VendDocReferenceCommands : BaseCommands<VendDocReferenceView>, IVendDocReferenceCommands
    {
        /// <summary>
        /// Route to call VendDocReferences
        /// </summary>
        public override string RouteSuffix
        {
            get { return "VendDocReferences"; }
        }
    }
}