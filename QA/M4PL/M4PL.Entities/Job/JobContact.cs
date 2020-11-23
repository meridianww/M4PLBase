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
	/// Model class for Job Contacts
	/// </summary>
	public class JobContact : BaseModel
	{
		/// <summary>
		/// Gets or Sets JobDeliveryResponsibleContactID
		/// </summary>
		public long? JobDeliveryResponsibleContactID { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryResponsibleContactIDName
		/// </summary>
		public string JobDeliveryResponsibleContactIDName { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryAnalystContactID
		/// </summary>
		public long? JobDeliveryAnalystContactID { get; set; }
		/// <summary>
		/// Gets or Sets JobDeliveryAnalystContactIDName
		/// </summary>
		public string JobDeliveryAnalystContactIDName { get; set; }
		/// <summary>
		/// Gets or Sets JobIsDirtyContact
		/// </summary>
		public bool JobIsDirtyContact { get; set; }
		/// <summary>
		/// Gets or Sets JobDriverId
		/// </summary>
		public long? JobDriverId { get; set; }
		/// <summary>
		/// Gets or Sets JobDriverIdName
		/// </summary>
		public string JobDriverIdName { get; set; }
		/// <summary>
		/// Gets or Sets ProgramID
		/// </summary>
		public long? ProgramID { get; set; }
		/// <summary>
		/// Gets or Sets JobRouteId
		/// </summary>
		public string JobRouteId { get; set; }
		/// <summary>
		/// Gets or Sets JobStop
		/// </summary>
		public string JobStop { get; set; }

	}
}
