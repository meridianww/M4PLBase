using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    /// <summary>
    /// Model class for Projected Capacity Data
    /// </summary>
    public class ProjectedCapacityData
    {
        /// <summary>
        /// Gets or Sets Customer Id
        /// </summary>
        public long CustomerId { get; set; }
        /// <summary>
        /// Gets or Sets Year
        /// </summary>
        public int Year { get; set; }
        
        /// <summary>
        /// Gets or Sets List of Projected Capacity Raw Data
        /// </summary>
        public List<ProjectedCapacityRawData> ProjectedCapacityRawData { get; set; }
    }
}
