using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.XCBL
{
    public class XCBLToM4PLRequest
    {
        public int EntityId { get; set; }
        public object Request { get; set; }
    }
}
