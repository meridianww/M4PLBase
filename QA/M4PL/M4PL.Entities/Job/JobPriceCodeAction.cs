#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Job
{
	public class JobPriceCodeAction
	{
		public long PriceCodeId { get; set; }
		public string PriceCode { get; set; }
		public string PriceTitle { get; set; }
		public string PriceActionCode { get; set; }
	}
}