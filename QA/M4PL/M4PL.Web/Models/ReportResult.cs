/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 ReportResult
//Purpose:                                      Represents description for ReportResult
//====================================================================================================================================================*/

using System.Collections.Generic;
using DevExpress.XtraReports.UI;
using M4PL.Entities.Support;

namespace M4PL.Web.Models
{
    public class ReportResult<TView> : ViewResult
    {
        public long RecordId { get; set; }
        public XtraReport Report { get; set; }
        public TView Record { get; set; }
        public MvcRoute ReportRoute { get; set; }
        public MvcRoute ExportRoute { get; set; }
        public List<string> Location { get; set; }
        public System.DateTime? StartDate { get; set; }
        public System.DateTime? EndDate { get; set; }
        public bool IsPBSReport { get; set; }
    }
}