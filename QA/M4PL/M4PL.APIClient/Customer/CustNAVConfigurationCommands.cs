﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kamal
// Date Programmed:                              12/17/2020
// Program Name:                                 CustNAVConfigurationCommands
// Purpose:                                      Client to consume M4PL API called CustNAVConfigurationController
//=================================================================================================================


using M4PL.APIClient.ViewModels.Customer;

namespace M4PL.APIClient.Customer
{
    public class CustNAVConfigurationCommands : BaseCommands<CustNAVConfigurationView>, ICustNAVConfigurationCommands
    {
		/// <summary>
		///  Route to call Customer NAV Configuration
		/// </summary>
		public override string RouteSuffix
		{
			get { return "CustNAVConfiguration"; }
		}
	}
}
