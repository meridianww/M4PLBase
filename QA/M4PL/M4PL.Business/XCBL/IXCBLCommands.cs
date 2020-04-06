using M4PL.Entities.XCBL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Business.XCBL
{
    public interface IXCBLCommands 
    {
        long PostXCBLSummaryHeader(XCBLToM4PLRequest xCBLToM4PLRequisitionRequest);
    }
}
