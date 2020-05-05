using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class JobGatewayDetails
    {
        public string GwyShipApptmtReasonCode { get; set; }
        public string GwyShipStatusReasonCode { get; set; }
        public string GwyGatewayCode { get; set; }
        public string GwyGatewayTitle { get; set; }
        public string GatewayCode
        {
            get
            {
                if (GwyGatewayCode.IndexOf("-") > -1)
                    return GwyGatewayCode.Substring(0, GwyGatewayCode.IndexOf("-")).Trim();
                return GwyGatewayCode;
            }
        }
    }
}
