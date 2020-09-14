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
	public class JobContact : BaseModel
	{
		public long? JobDeliveryResponsibleContactID { get; set; }
		public string JobDeliveryResponsibleContactIDName { get; set; }
		public long? JobDeliveryAnalystContactID { get; set; }
		public string JobDeliveryAnalystContactIDName { get; set; }
		public bool JobIsDirtyContact { get; set; }
		public long? JobDriverId { get; set; }
		public string JobDriverIdName { get; set; }
		public long? ProgramID { get; set; }
		public string JobRouteId { get; set; }
		public string JobStop { get; set; }
	}
}
