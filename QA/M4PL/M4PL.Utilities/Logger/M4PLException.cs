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

namespace M4PL.Utilities.Logger
{
	/// <summary>
	/// Model for M4PLException
	/// </summary>
	public class M4PLException
	{
		/// <summary>
		/// Get or Set for Exception
		/// </summary>
		public Exception Exception { get; set; }

		/// <summary>
		/// Get or Set for AdditionalMessage
		/// </summary>
		public string AdditionalMessage { get; set; }

		/// <summary>
		/// Get or Set for ErrorRelatedTo
		/// </summary>
		public string ErrorRelatedTo { get; set; }

		/// <summary>
		/// Get or Set for LogType
		/// </summary>
		public LogType LogType { get; set; }
	}
}
