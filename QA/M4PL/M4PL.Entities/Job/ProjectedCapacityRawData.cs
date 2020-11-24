using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Job
{
    /// <summary>
    /// Model class for Projected Capacity RawData
    /// </summary>
    public class ProjectedCapacityRawData
    {
        /// <summary>
        /// Gets or Sets Projected Capacity 
        /// </summary>
        public string ProjectedCapacity { get; set; }
        /// <summary>
        /// gets or Sets Location
        /// </summary>
        public string Location { get; set; }
        /// <summary>
        /// Gets or Sets Year
        /// </summary>
		public int Year { get; set; }
	}
}
