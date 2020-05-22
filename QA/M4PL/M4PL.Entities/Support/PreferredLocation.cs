using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Support
{
    public class PreferredLocation
    {
        public long Id { get; set; }

        public string VendorDcLocationCode { get; set; }

        public string PPPVendorLocationCode { get; set; }
    }
}
