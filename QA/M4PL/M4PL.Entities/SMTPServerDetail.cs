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
	public class SMTPServerDetail
	{
		public int Id { get; set; }
		public string SMTPServerName { get; set; }
		public int SMTPServerPort { get; set; }
		public string SMTPLoginUserName { get; set; }
		public string SMTPLoginPassword { get; set; }
		public bool IsSSLEnabled { get; set; }
		public string DefaultFromAddress { get; set; }
	}
}
