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

namespace M4PL.Entities.BizMobl
{
	/// <summary>
	/// Model class for Biz Mobile CSV Data
	/// </summary>
	public class BizMoblCSVData
	{
		/// <summary>
		/// Get or Set File content in CSV file
		/// </summary>
		public byte[] FileContent { get; set; }
		/// <summary>
		/// Get or Set Biz Mobile Device Id
		/// </summary>
		public string DeviceId { get; set; }
	}
}
