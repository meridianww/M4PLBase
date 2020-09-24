using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Finance.Remittance
{
    public class NavRemittance : BaseModel
    {
        /// <summary>
        /// JobId
        /// </summary>
        public long JobId { get; set; }
        /// <summary>
        /// ChequeNo
        /// </summary>
        public string ChequeNo { get; set; }
        /// <summary>
        /// VendorOrderNo
        /// </summary>
        public string VendorOrderNo { get; set; }
        /// <summary>
        /// DocumentDate
        /// </summary>
        public DateTime? DocumentDate { get; set; }
        /// <summary>
        /// Amount
        /// </summary>
        public decimal? Amount { get; set; }
        /// <summary>
        /// StrRoute
        /// </summary>
        public string StrRoute { get; set; }
    }
}
