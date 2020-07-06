#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Collections.Generic;

namespace M4PL.Entities.XCBL
{
    public class XCBLSummaryHeaderModel
    {
        public SummaryHeader SummaryHeader { get; set; }
        public List<Address> Address { get; set; }
        public UserDefinedField UserDefinedField { get; set; }
        public CustomAttribute CustomAttribute { get; set; }
        public List<LineDetail> LineDetail { get; set; }
        public List<CopiedGateway> CopiedGatewayIds { get; set; }
    }

    public class CopiedGateway
    {
        public long Id { get; set; }
    }
}
