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
	/// Model class for SMTP Server Detail
	/// </summary>
	public class SMTPServerDetail
	{
		/// <summary>
		/// Gets or Sets Id
		/// </summary>
		public int Id { get; set; }
		/// <summary>
		/// Gets or Sets SMTP Server Name
		/// </summary>
		public string SMTPServerName { get; set; }
		/// <summary>
		/// Gets or Sets SMTP Server Port
		/// </summary>
		public int SMTPServerPort { get; set; }
		/// <summary>
		/// Gets or Sets SMTP Login UserName
		/// </summary>
		public string SMTPLoginUserName { get; set; }
		/// <summary>
		/// Gets or Sets SMTP Login Password
		/// </summary>
		public string SMTPLoginPassword { get; set; }
		/// <summary>
		/// Gets or Sets flag if IsSSLEnabled
		/// </summary>
		public bool IsSSLEnabled { get; set; }
		/// <summary>
		/// Gets or Sets Default FromAddress
		/// </summary>
		public string DefaultFromAddress { get; set; }

	}
}
