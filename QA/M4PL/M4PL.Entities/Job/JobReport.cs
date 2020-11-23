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
// Program Name:                                 JobReport
// Purpose:                                      Contains objects related to JobReport
//==========================================================================================================
using System;
using System.ComponentModel;

namespace M4PL.Entities.Job
{
    /// <summary>
    /// Model class for Job Report
    /// </summary>
    public class JobReport : BaseReportModel
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public JobReport()
        {
        }
        /// <summary>
        /// Parameterized constructor by passing Base Report Model
        /// </summary>
        /// <param name="baseReportModel"></param>
        public JobReport(BaseReportModel baseReportModel) : base(baseReportModel)
        {
        }
        /// <summary>
        /// Gets or Sets Start Date
        /// </summary>
        [DisplayName("Start Date")]
        public DateTime? StartDate { get; set; }
        /// <summary>
        /// Gets or Sets End Date
        /// </summary>
        [DisplayName("End Date")]
        public DateTime? EndDate { get; set; }

        #region VOC
        /// <summary>
        /// Gets or Sets Location
        /// </summary>
        public string Location { get; set; }
        /// <summary>
        /// Gets or Sets PBS Report Field ID
        /// </summary>
        public long? IsPBSReportFieldId { get; set; }
        /// <summary>
        /// Gets or Sets flag if PBS Report
        /// </summary>
        public bool IsPBSReport { get; set; }

        #endregion VOC

        #region Advanced report
        /// <summary>
        /// Gets or Sets Customer Id
        /// </summary>
        public long CustomerId { get; set; }
        /// <summary>
        /// Gets or Sets Program Id
        /// </summary>
        public long ProgramId { get; set; }
        /// <summary>
        /// Gets or Sets Program Code
        /// </summary>
        public string ProgramIdCode { get; set; }
        /// <summary>
        /// Gets or Sets Order Type
        /// </summary>
        public string OrderType { get; set; }
        /// <summary>
        /// Gets or Sets Order Type Name
        /// </summary>
        public string OrderTypeName { get; set; }
        /// <summary>
        /// Gets or Sets Scheduled for Job Report
        /// </summary>
        public string Scheduled { get; set; }
        /// <summary>
        /// Gets or Sets Scheduled Name
        /// </summary>
        public string ScheduledName { get; set; }
        /// <summary>
        /// Gets or Sets Origin
        /// </summary>
        public string Origin { get; set; }
        /// <summary>
        /// Gets or Sets Destination
        /// </summary>
        public string Destination { get; set; }
        /// <summary>
        /// Gets or Sets Job Status Id
        /// </summary>
        public string JobStatusId { get; set; }
        /// <summary>
        /// Gets or Sets Job Status Name
        /// </summary>
        public string JobStatusIdName { get; set; }
        /// <summary>
        /// Gets or Sets Gateway Status
        /// </summary>
        public string GatewayStatus { get; set; }
        /// <summary>
        /// Gets or Sets Service Mode
        /// </summary>
        public string ServiceMode { get; set; }
        /// <summary>
        /// Gets or Sets Mode
        /// </summary>
        public string Mode { get; set; }
        /// <summary>
        /// Gets or Sets Search Text
        /// </summary>
        public string Search { get; set; }
        /// <summary>
        /// Gets or Sets Program Code
        /// </summary>
        public string ProgramCode { get; set; }
        /// <summary>
        /// Gets or Sets Program Title
        /// </summary>
        public string ProgramTitle { get; set; }
        /// <summary>
        /// Gets or Sets Brand
        /// </summary>
        public string Brand { get; set; }
        /// <summary>
        /// Gets or Sets Product Type
        /// </summary>
        public string ProductType { get; set; }
        /// <summary>
        /// Gets or Sets Job Channel
        /// </summary>
        public string JobChannel { get; set; }
        /// <summary>
        /// Gets or Sets Date Type Name
        /// </summary>
        public string DateTypeName { get; set; }

        //public bool IsEnabledAddtionalfield { get; set; }
        /// <summary>
        /// Gets or Sets flag if Manifest available
        /// </summary>
        public bool Manifest { get; set; }

        //public string CgoPackagingTypeId { get; set; }
        //public string CgoPackagingTypeIdName { get; set; }
        //public int? CgoWeightUnitTypeId { get; set; }
        //public string CgoWeightUnitTypeIdName { get; set; }
        //public int JobPartsOrdered { get; set; }
        /// <summary>
        /// Gets or Sets Cargo Id
        /// </summary>
        public long CargoId { get; set; }
        /// <summary>
        /// Gets or Sets Cargo Name
        /// </summary>
        public string CargoIdName { get; set; }
        /// <summary>
        /// Gets or Sets Packaging Code
        /// </summary>
        public string PackagingCode { get; set; }
        /// <summary>
        /// Gets or Sets Report Type Identifier
        /// </summary>
        public int? ReportType { get; set; }
        /// <summary>
        /// Gets or Sets Year
        /// </summary>
        public int? Year { get; set; }
        #endregion Advanced report
    }
}