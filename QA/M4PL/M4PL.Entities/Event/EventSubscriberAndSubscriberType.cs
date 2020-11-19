using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Event
{
    /// <summary>
    /// Model class for mapping
    /// </summary>
    public class EventSubscriberAndSubscriberType
    {
        /// <summary>
        /// Gets or Sets Subscriber Id e.g. 1 for Customer
        /// </summary>
        public int SubscriberId { get; set; }
        /// <summary>
        /// Gets or Sets Subscriber Type Id e.g. 1 for To and 2 for CC
        /// </summary>
        public int SubscriberTypeId { get; set; }

    }
}
