using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest
{
    public class Exceptions
    {
        public bool HasExceptions { get; set; }

        public ExceptionInfo ExceptionInfo { get; set; }
    }
}
