#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Nikhil
// Date Programmed:                              08/21/2019
// Program Name:                                 PrgEdiConditionCommands
// Purpose:                                      Client to consume M4PL API called PrgEdiConditionsController
//=============================================================================================================
using M4PL.APIClient.ViewModels.Program;

namespace M4PL.APIClient.Program
{
	public class PrgEdiConditionCommands : BaseCommands<PrgEdiConditionView>, IPrgEdiConditionCommands
	{
		/// <summary>
		/// Route to call PrgEdiCondition
		/// </summary>
		public override string RouteSuffix
		{
			get { return "PrgEdiConditions"; }
		}
	}
}