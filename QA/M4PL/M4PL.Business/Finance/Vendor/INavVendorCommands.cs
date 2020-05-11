/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              06/25/2019
Program Name:                                 INavVendorCommands
Purpose:                                      Set of rules for NavVendorCommands
===============================================================================================================*/
using M4PL.Entities.Finance.Vendor;
using System.Collections.Generic;

namespace M4PL.Business.Finance.Vendor
{
	/// <summary>
	/// Provides the operations based on the Table name
	/// </summary>
	public interface INavVendorCommands : IBaseCommands<NavVendor>
	{
        IList<NavVendor> GetAllData();
    }
}
