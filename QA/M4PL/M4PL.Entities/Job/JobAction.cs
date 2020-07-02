#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

namespace M4PL.Entities.Job
{
    public class JobAction
    {
        public string PacApptReasonCode { get; set; }
        public string PacApptTitle { get; set; }
        public string PscShipReasonCode { get; set; }
        public string PscShipTitle { get; set; }
        public string PgdGatewayCode { get; set; }
        public string PgdGatewayTitle { get; set; }
        public long ProgramId { get; set; }
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
