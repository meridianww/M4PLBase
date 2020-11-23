using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    /// <summary>
    /// Model class for Driver Contact
    /// </summary>
    public class DriverContact
    {
        /// <summary>
        /// Gets or Sets Driver contact id
        /// </summary>
        public long? Id { get; set; }
        /// <summary>
        /// Gets or Sets Lcoation Code
        /// </summary>
        public string LocationCode { get; set; }
        /// <summary>
        /// Gets or Sets First Name
        /// </summary>
        public string FirstName { get; set;     }
        /// <summary>
        /// Gets or Sets Last Name
        /// </summary>
        public string LastName { get; set; }
        /// <summary>
        /// Gets or Sets BizMoblContactID
        /// </summary>
        public string BizMoblContactID { get; set; }
        /// <summary>
        /// Gets or Sets Job Id
        /// </summary>
        public long? JobId { get; set; }
        /// <summary>
        /// Gets or Sets Job Route Id
        /// </summary>
		public string JobRouteId { get; set; }
        /// <summary>
        /// Gets or Sets Job Stop
        /// </summary>
		public string JobStop { get; set; }
	}
}
