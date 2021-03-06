﻿#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              10/22/2019
// Program Name:                                 JobOrderItemMapping
// Purpose:                                      Contains objects related to JobOrderItemMapping
//==========================================================================================================

namespace M4PL.Entities.Finance.JobOrderMapping
{
	public class JobOrderItemMapping
	{
		public long JobOrderItemMappingId { get; set; }
		public long JobId { get; set; }
		public string EntityName { get; set; }
		public int LineNumber { get; set; }

		public long M4PLItemId { get; set; }

		public string Document_Number { get; set; }

		public bool IsElectronicInvoiced { get; set; }
	}
}