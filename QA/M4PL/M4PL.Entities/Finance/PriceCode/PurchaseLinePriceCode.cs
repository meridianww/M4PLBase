using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Finance.PriceCode
{
    public class PurchaseLinePriceCode : BaseModel
    {
        public long M4PL_Job_ID { get; set; }
        public string No { get; set; }
        public string Description { get; set; }
        public string Line_Amount { get; set; }

    }
}
