using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    public class JobXcblInfo : BaseModel
    {
        /// <summary>
        /// Gets or Sets JobId
        /// </summary>
        public long JobId { get; set; }
        /// <summary>
        /// Gets or Sets CustomerSalesOrderNumber
        /// </summary>
        public string CustomerSalesOrderNumber { get; set; }
        /// <summary>
        /// ColumnMappingData
        /// </summary>
        public List<ColumnMappingData> ColumnMappingData { get; set; }
        /// <summary>
        /// IsAccepted
        /// </summary>
        public bool? IsAccepted { get; set; }

        public long SummaryHeaderId { get; set; }
    }
    /// <summary>
    /// ColumnMappingData mapping class
    /// </summary>
    public class ColumnMappingData
    {
        /// <summary>
        /// Gets or Sets ColumnName
        /// </summary>
        public string ColumnName { get; set; }

        /// <summary>
        /// Gets or Sets Existing value from Job Table
        /// </summary>
        public string ExistingValue { get; set; }

        /// <summary>
        /// Gets or Sets Existing value from xCBL Table
        /// </summary>
        public string UpdatedValue { get; set; }
    }
}
