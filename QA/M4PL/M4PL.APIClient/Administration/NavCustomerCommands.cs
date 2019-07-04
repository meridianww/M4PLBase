﻿//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//=================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              06/25/2019
//Program Name:                                 NavCustomerCommands
//Purpose:                                      Client to consume M4PL API called NavCustomerCommands
//===================================================================================================================
using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.APIClient.Administration
{
	/// <summary>
	/// Route to call Nav Vendor
	/// </summary>
	public class NavCustomerCommands : BaseCommands<NavCustomerView>,
		INavCustomerCommands
	{
		public override string RouteSuffix
		{
			get { return "NavCustomer"; }
		}
    }
}
