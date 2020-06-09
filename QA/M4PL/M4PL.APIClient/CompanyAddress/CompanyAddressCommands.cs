/*Copyright (2019) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              07/11/2019
//Program Name:                                 Company Address
//Purpose:                                      Client to consume M4PL API called CompanyAddressController
//====================================================================================================================================================*/
using M4PL.APIClient.ViewModels.CompanyAddress;

namespace M4PL.APIClient.CompanyAddress
{
    public class CompanyAddressCommands : BaseCommands<CompanyAddressView>, ICompanyAddressCommands
    {
        /// <summary>
        /// Route to call Company Address
        /// </summary>
        public override string RouteSuffix
        {
            get { return "CompanyAddress"; }
        }
    }
}

