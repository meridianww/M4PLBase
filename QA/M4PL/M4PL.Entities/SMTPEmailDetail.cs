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

namespace M4PL.Entities
{
	/// <summary>
	/// Model class for SMTP Email Details
	/// </summary>
	public class SMTPEmailDetail
	{
		/// <summary>
		/// Gets or Sets List of Email Details
		/// </summary>
		public List<EmailDetail> EmailDetail { get; set; }
		/// <summary>
		/// Gets or Sets List of SMTP Server Details
		/// </summary>
		public List<SMTPServerDetail> SMTPServerDetail { get; set; }
	}
}
