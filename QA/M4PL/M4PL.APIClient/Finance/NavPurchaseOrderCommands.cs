//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//=================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              10/04/2019
//Program Name:                                 NavSalesOrderCommands
//Purpose:                                      Client to consume M4PL API called NavPurchaseOrderCommands
//===================================================================================================================

using M4PL.APIClient.ViewModels.Finance;
using M4PL.Entities;
using System.Collections.Generic;

namespace M4PL.APIClient.Finance
{
	public class NavPurchaseOrderCommands : BaseCommands<NavPurchaseOrderView>,
		INavPurchaseOrderCommands
	{
		public override string RouteSuffix
		{
			get { return "NavPurchaseOrder"; }
		}
	}
}
