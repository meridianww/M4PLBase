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

namespace M4PL.Entities.Program
{
	public class PrgEventManagement : BaseModel
	{
		public string EventName { get; set; }

		public int EventTypeId { get; set; }

		public string EventTypeIdName { get; set; }

		public string EventShortName { get; set; }

		public string FromMail { get; set; }

		public string Description { get; set; }

		public long ParentId { get; set; }

		public string ToEmail { get; set; }

		public string CcEMail { get; set; }
	}
}
