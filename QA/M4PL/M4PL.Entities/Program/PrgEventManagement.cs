#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

using M4PL.Entities.Event;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Program
{
	public class PrgEventManagement : BaseModel
	{
		/// <summary>
		/// Gets or sets the program identifier.
		/// </summary>
		/// <value>
		/// The Program identifier.
		/// </value>
		public long? ProgramID { get; set; }

		public string ProgramIDName { get; set; }

		public string EventName { get; set; }

		public int? EventTypeId { get; set; }

		public string EventTypeIdName { get; set; }

		public string EventShortName { get; set; }

		public string FromMail { get; set; }

		public string Description { get; set; }

		public long ParentId { get; set; }

		public string ToEmail { get; set; }

		public string CcEmail { get; set; }

        public bool IsBodyHtml { get; set; }

        public string ToEmailSubscribers { get; set; }

        public string CcEMailSubscribers { get; set; }

        public string Subject { get; set; }
        public List<EventSubscriberAndSubscriberType> SubscriberAndSubscriberTypeMappingList { get; set; }

        public List<EventSubscriber> SubscribersSelectedForToEmail { get; set; }

        public List<EventSubscriber> SubscribersSelectedForCCEmail { get; set; }


    }
}
