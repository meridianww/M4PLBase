using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class JobGatewayDetails
    {
        public string PacApptReasonCode { get; set; }
        public string PscShipReasonCode { get; set; }
        public string PgdGatewayCode { get; set; }
        public string PgdGatewayTitle { get; set; }
        public string GatewayCode
        {
            get
            {
                if (PgdGatewayCode.IndexOf("-") > -1)
                    return PgdGatewayCode.Substring(0, PgdGatewayCode.IndexOf("-")).Trim();
                return PgdGatewayCode;
            }
        }
    }
}
