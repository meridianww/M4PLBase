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
		/// <summary>
		/// Gets or Sets Program Name
		/// </summary>
		public string ProgramIDName { get; set; }
		/// <summary>
		/// Gets or Sets Event Name e.g. AWC Cargo Exception
		/// </summary>
		public string EventName { get; set; }
		/// <summary>
		/// Gets or sets Event type id e.g. 3 for Vendor
		/// </summary>
		public int? EventTypeId { get; set; }
		/// <summary>
		/// Gets or Sets Event Type Text
		/// </summary>
		public string EventTypeIdName { get; set; }
		/// <summary>
		/// Gets or Sets Short Name of an Event e.g. ACE for AWC Cargo Exception
		/// </summary>
		public string EventShortName { get; set; }
		/// <summary>
		/// Gets or Sets From mail address 
		/// </summary>
		public string FromMail { get; set; }
		/// <summary>
		/// Gets or Sets Event Description
		/// </summary>
		public string Description { get; set; }
		/// <summary>
		/// Gets or Sets Parent Id as Program ID
		/// </summary>
		public long ParentId { get; set; }
		/// <summary>
		/// Gets or Sets To Email Address
		/// </summary>
		public string ToEmail { get; set; }
		/// <summary>
		/// Gets or Sets CC email Address
		/// </summary>
		public string CcEmail { get; set; }
		/// <summary>
		/// Gets or Sets flag if the mail body is in HTML format
		/// </summary>
        public bool IsBodyHtml { get; set; }
		/// <summary>
		/// Gets or Sets To Email address of Event subscribers
		/// </summary>
        public string ToEmailSubscribers { get; set; }
		/// <summary>
		/// Gets or Sets CC Email address of Event subscribers
		/// </summary>
		public string CcEMailSubscribers { get; set; }
		/// <summary>
		/// Gets or Sets Email Subject 
		/// </summary>
        public string Subject { get; set; }
		/// <summary>
		/// Gets or Sets List of Mapping between Subscriber and their respective types
		/// </summary>
        public List<EventSubscriberAndSubscriberType> SubscriberAndSubscriberTypeMappingList { get; set; }
		/// <summary>
		/// Gets or Sets List of Event Subscriber Selected as To Email Address
		/// </summary>
        public List<EventSubscriber> SubscribersSelectedForToEmail { get; set; }
		/// <summary>
		/// Gets or Sets List of Event Subscriber Selected as CC Email Address
		/// </summary>
		public List<EventSubscriber> SubscribersSelectedForCCEmail { get; set; }


    }
}
