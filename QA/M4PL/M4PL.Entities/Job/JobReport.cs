/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobReport
Purpose:                                      Contains objects related to JobReport
==========================================================================================================*/
using System;
using System.Collections.Generic;
using System.ComponentModel;

namespace M4PL.Entities.Job
{
    public class JobReport : BaseReportModel
    {
        public JobReport()
        {
        }

        public JobReport(BaseReportModel baseReportModel) : base(baseReportModel)
        {
        }

        [DisplayName("Start Date")]
        public DateTime StartDate { get; set; }
        [DisplayName("End Date")]
        public DateTime EndDate { get; set; }
        #region VOC
        public string  Location { get; set; }  
        public long? IsPBSReportFieldId { get; set; }
        public bool IsPBSReport { get; set; }
        #endregion

        #region Advanced report
        public long CustomerId { get; set; }
        public long ProgramId { get; set; }
        public string ProgramIdCode { get; set; }
        public long OrderTypeId { get; set; } 
        public string Scheduled { get; set; }
        public long Origin { get; set; }
        public long Destination { get; set; }
        public long JobStatusId { get; set; }
        public string GatewayStatusId { get; set; }
        public long ServiceMode { get; set; }
        public long Mode { get; set; }
        public string Search { get; set; }
        #endregion

    }
}