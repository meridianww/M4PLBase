#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              06/06/2018
// Program Name:                                 DeliveryStatusCommands
// Purpose:                                      Client to consume M4PL API called DeliveryStatusesController
//===================================================================================================================

using M4PL.APIClient.ViewModels.Administration;

namespace M4PL.APIClient.Administration
{
	/// <summary>
	/// Route to call column alias
	/// </summary>
	public class DeliveryStatusCommands : BaseCommands<DeliveryStatusView>,
		IDeliveryStatusCommands
	{
		public override string RouteSuffix
		{
			get { return "DeliveryStatuses"; }
		}
	}
}