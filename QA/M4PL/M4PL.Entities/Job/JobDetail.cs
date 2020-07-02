#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 JobDetail
// Purpose:                                      Contains objects related to JobDetail
//==========================================================================================================
using System;

namespace M4PL.Entities.Job
{
    public class JobDetail : BaseModel
    {
        /// <summary>
        /// Gets or sets the job master identifier.
        /// </summary>
        /// <value>
        /// The JobMITJob identifier.
        /// </value>
        public long? JobMITJobID { get; set; }

        /// <summary>
        /// Gets or sets the program identifier.
        /// </summary>
        /// <value>
        /// The Program identifier.
        /// </value>
        public long? ProgramID { get; set; }

        public string ProgramIDName { get; set; }

        /// <summary>
        /// Gets or sets the type of job.
        /// </summary>
        /// <value>
        /// The JobSiteCode.
        /// </value>
        public string JobSiteCode { get; set; }

        /// <summary>
        /// Gets or sets the consignee code.
        /// </summary>
        /// <value>
        /// The JobConsigneeCode.
        /// </value>
        public string JobConsigneeCode { get; set; }

        /// <summary>
        /// Gets or sets the sales order.
        /// </summary>
        /// <value>
        /// The JobCustomerSalesOrder.
        /// </value>
        public string JobCustomerSalesOrder { get; set; }

        /// <summary>
        /// Gets or sets the .
        /// </summary>
        /// <value>
        /// The JobBOLMaster.
        /// </value>
        public string JobBOLMaster { get; set; }

        /// <summary>
        /// Gets or sets the .
        /// </summary>
        /// <value>
        /// The JobBOLChild.
        /// </value>
        public string JobBOLChild { get; set; }

        /// <summary>
        /// Gets or sets the purchase order.
        /// </summary>
        /// <value>
        /// The JobCustomerPurchaseOrder.
        /// </value>
        public string JobCustomerPurchaseOrder { get; set; }

        /// <summary>
        /// Gets or sets the carrier contract.
        /// </summary>
        /// <value>
        /// The JobCarrierContract.
        /// </value>
        public string JobCarrierContract { get; set; }

        /// <summary>
        /// Gets or sets the  status.
        /// </summary>
        /// <value>
        /// The GatewayStatusId.
        /// </value>
        public int? GatewayStatusId { get; set; }

        /// <summary>
        /// Gets or sets the status date.
        /// </summary>
        /// <value>
        /// The JobStatusedDate.
        /// </value>
        public DateTime? JobStatusedDate { get; set; }

        /// <summary>
        /// Gets or sets the job completion.
        /// </summary>
        /// <value>
        /// The JobCompleted.
        /// </value>
        public bool JobCompleted { get; set; }
    }
}