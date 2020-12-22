using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Customer
{
    /// <summary>
    /// CustNAVConfiguration
    /// </summary>
    public class CustNAVConfiguration : BaseModel
    {
        /// <summary>
        /// Gets or sets the NAVConfigurationId
        /// </summary>
        public long NAVConfigurationId { get; set; }
        /// <summary>
        /// Gets or sets ServiceUrl
        /// </summary>
        public string ServiceUrl { get; set; }
        /// <summary>
        /// Gets or sets CustomerId
        /// </summary>
        public long CustomerId { get; set; }
        /// <summary>
        /// Gets or sets ServiceUserName
        /// </summary>
        public string ServiceUserName { get; set; }
        /// <summary>
        /// Gets or sets ServicePassword
        /// </summary>
        public string ServicePassword { get; set; }
        /// <summary>
        /// Gets or sets IsProductionEnvironment
        /// </summary>
        public bool IsProductionEnvironment { get; set; }        
    }
}
