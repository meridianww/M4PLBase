//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//=================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              07/31/2019
//Program Name:                                 NavPriceCodeCommands
//Purpose:                                      Client to consume M4PL API called NavPriceCodeCommands
//===================================================================================================================

using M4PL.APIClient.ViewModels.Administration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.APIClient.Administration
{
	public class NavPriceCodeCommands : BaseCommands<NavPriceCodeView>,
		INavPriceCodeCommands
	{
		public override string RouteSuffix
		{
			get { return "NavPriceCode"; }
		}
	}
}
