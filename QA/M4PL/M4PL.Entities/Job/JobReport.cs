﻿/*Copyright(2016) Meridian Worldwide Transportation Group
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

        public string  Location { get; set; }
        [DisplayName("Start Date")]
        public DateTime StartDate { get; set; }
        [DisplayName("End Date")]
        public DateTime EndDate { get; set; }

        public long? IsPBSReportFieldId { get; set; }
        public bool IsPBSReport { get; set; }
    }
}