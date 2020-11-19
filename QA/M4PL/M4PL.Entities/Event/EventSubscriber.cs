using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Event
{
    /// <summary>
    /// Model class for Event Subscriber
    /// </summary>
    public class EventSubscriber
    {
        /// <summary>
        /// Gets or Sets Id
        /// </summary>
        public int Id { get; set; }
        /// <summary>
        /// Gets or Sets Description e.g. Vendor/Customer/Custom
        /// </summary>
        public string SubscriberDescription { get; set; }
    }
}
