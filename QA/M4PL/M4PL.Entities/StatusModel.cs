#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities
{
	/// <summary>
	/// Model class for API Response
	/// </summary>
	public class StatusModel
	{
		/// <summary>
		/// Gets or Sets Status Code e.g. 200
		/// </summary>
		public int StatusCode { get; set; }
		/// <summary>
		/// Gets or Sets Status e.g. Success
		/// </summary>
		public string Status { get; set; }
		/// <summary>
		/// Gets or Sets Additional Details
		/// </summary>
		public string AdditionalDetail { get; set; }
	}
}