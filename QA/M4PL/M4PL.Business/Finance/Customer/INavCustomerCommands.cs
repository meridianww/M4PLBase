﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              06/25/2019
Program Name:                                 INavCustomerCommands
Purpose:                                      Set of rules for NavCustomerCommands
===============================================================================================================*/
using System.Collections.Generic;
using M4PL.Entities.Finance.Customer;

namespace M4PL.Business.Finance.Customer
{
	/// <summary>
	/// Provides the operations based on the Table name
	/// </summary>
	public interface INavCustomerCommands : IBaseCommands<NavCustomer>
	{
		IList<NavCustomer> GetAllNavCustomer();
	}
}
