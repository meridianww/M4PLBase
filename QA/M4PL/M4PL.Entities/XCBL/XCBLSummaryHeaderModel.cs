using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.XCBL
{
    public class XCBLSummaryHeaderModel
    {
        public SummaryHeader SummaryHeader { get; set; }
        public List<Address> Address { get; set; }
        public UserDefinedField UserDefinedField { get; set; }
        public CustomAttribute CustomAttribute { get; set; }

    }
}
