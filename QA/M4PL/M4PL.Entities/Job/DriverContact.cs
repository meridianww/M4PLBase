using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class DriverContact
    {
        public long? Id { get; set; }
        public string LocationCode { get; set; }
        public string FirstName { get; set;     }
        public string LastName { get; set; }
        public string BizMoblContactID { get; set; }
        public long? JobId { get; set; }
		public string JobRouteId { get; set; }
		public string JobStop { get; set; }
	}
}
