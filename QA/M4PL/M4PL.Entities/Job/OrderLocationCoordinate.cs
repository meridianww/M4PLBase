#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
	/// <summary>
	/// Model class for Job Location Co Ordinates
	/// </summary>
	public class OrderLocationCoordinate
	{
		/// <summary>
		/// Gets or Sets StatusCode
		/// </summary>
		public int StatusCode { get; set; }
		/// <summary>
		/// Gets or Sets Status
		/// </summary>
		public string Status { get; set; }
		/// <summary>
		/// Gets or Sets AdditionalDetail
		/// </summary>
		public string AdditionalDetail { get; set; }
		/// <summary>
		/// Gets or Sets Latitude
		/// </summary>
		public decimal Latitude { get; set; }
		/// <summary>
		/// Gets or Sets Longitude
		/// </summary>
		public decimal Longitude { get; set; }

	}
}
