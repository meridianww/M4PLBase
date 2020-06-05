using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class JobActionCode
    {
        public string PgdShipStatusReasonCode { get; set; }
        public string PgdShipApptmtReasonCode { get; set; }
		public int UTCValue { get; set; }
	}
}
