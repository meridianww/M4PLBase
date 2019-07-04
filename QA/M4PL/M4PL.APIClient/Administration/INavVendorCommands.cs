/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              06/25/2019
Program Name:                                 INavVendorCommands
Purpose:                                      Set of rules for NavVendorCommands
=============================================================================================================*/
using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.APIClient.Administration
{
	/// <summary>
	/// Performs basic CRUD operation on the Nav Vendor Entity
	/// </summary>
	public interface INavVendorCommands : IBaseCommands<NavVendorView>
	{
	}
}
