/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              06/25/2019
Program Name:                                 INavCustomerCommands
Purpose:                                      Set of rules for NavCustomerCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Administration;
using System.Collections.Generic;

namespace M4PL.APIClient.Administration
{
	/// <summary>
	/// Performs basic CRUD operation on the Nav Customer Entity
	/// </summary>
	public interface INavCustomerCommands : IBaseCommands<NavCustomerView>
	{
    }
}
