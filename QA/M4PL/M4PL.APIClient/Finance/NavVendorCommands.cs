//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//=================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              06/25/2019
//Program Name:                                 NavVendorCommands
//Purpose:                                      Client to consume M4PL API called NavVendorCommands
//===================================================================================================================
using M4PL.APIClient.ViewModels.Finance;

namespace M4PL.APIClient.Finance
{
	/// <summary>
	/// Route to call Nav Vendor
	/// </summary>
	public class NavVendorCommands : BaseCommands<NavVendorView>,
		INavVendorCommands
	{
		public override string RouteSuffix
		{
			get { return "NavVendor"; }
		}
	}
}
