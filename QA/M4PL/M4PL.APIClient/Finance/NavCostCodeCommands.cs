//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//=================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Prashant Aggarwal
//Date Programmed:                              07/31/2019
//Program Name:                                 NavCostCodeCommands
//Purpose:                                      Client to consume M4PL API called NavCostCodeCommands
//===================================================================================================================

using M4PL.APIClient.ViewModels.Finance;

namespace M4PL.APIClient.Finance
{
	public class NavCostCodeCommands : BaseCommands<NavCostCodeView>,
		INavCostCodeCommands
	{
		public override string RouteSuffix
		{
			get { return "NavCostCode"; }
		}
	}
}
