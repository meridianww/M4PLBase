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
        public string Location { get; set; }
        public long? IsPBSReportFieldId { get; set; }
        public bool IsPBSReport { get; set; }
        #endregion

        #region Advanced report
        public long CustomerId { get; set; }
        public long ProgramId { get; set; }
        public string ProgramIdCode { get; set; }
        public string OrderType { get; set; }
        public string OrderTypeName { get; set; }
        public string Scheduled { get; set; }
        public string ScheduledName { get; set; }
        public string Origin { get; set; }
        public string Destination { get; set; }
        public string JobStatusId { get; set; }
        public string JobStatusIdName { get; set; }
        public string GatewayStatus { get; set; }
        public string ServiceMode { get; set; }
        public string Mode { get; set; }
        public string Search { get; set; }
        public string ProgramCode { get; set; }
        public string ProgramTitle { get; set; }
        public string Brand { get; set; }
        public string ProductType { get; set; }
        public string JobChannel { get; set; }
        public string DateTypeName { get; set; }
        public bool IsEnabledAddtionalfield { get; set; }
        public int? CgoPackagingTypeId { get; set; }
        public string CgoPackagingTypeIdName { get; set; }
        public int? JobWeightUnitTypeId { get; set; }
        public string JobWeightUnitTypeIdName { get; set; }
        //public int JobPartsOrdered { get; set; }
        public long CargoId { get; set; }
        public string CargoIdName { get; set; }
        #endregion

    }
}