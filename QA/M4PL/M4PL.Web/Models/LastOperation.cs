#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/13/2017
//Program Name:                                 LastOperation
//Purpose:                                      Represents description for the previous operation of the system
//====================================================================================================================================================*/

using M4PL.Entities;
using M4PL.Entities.Support;

namespace M4PL.Web.Models
{
	public class LastOperation
	{
		public bool IsSuccess { get; set; }

		public long RecordId { get; set; }

		public EntitiesAlias Entity { get; set; }

		public MvcRoute Route { get; set; }

		public object Record { get; set; }

		public DisplayMessage DisplayMessage { get; set; }
	}
}