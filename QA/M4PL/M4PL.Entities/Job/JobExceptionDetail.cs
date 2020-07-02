#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System.Collections.Generic;

namespace M4PL.Entities.Job
{
	public class JobExceptionDetail
	{
		public List<JobExceptionInfo> JobExceptionInfo { get; set; }
		public List<JobInstallStatus> JobInstallStatus { get; set; }
	}

	public class JobExceptionInfo
	{
		public long CustomerId { get; set; }

		public long ExceptionId { get; set; }

		public string ExceptionReferenceCode { get; set; }

		public string ExceptionReasonCode { get; set; }

		public string ExceptionTitle { get; set; }

		public long ExceptionReasonId { get; set; }
	}

	public class JobInstallStatus
	{
		public long CustomerId { get; set; }

		public long InstallStatusId { get; set; }

		public string InstallStatusDescription { get; set; }

		public bool IsException { get; set; }
	}
}