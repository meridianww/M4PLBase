/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/13/2017
//Program Name:                                 GlobalReportStorageWebExtension
//Purpose:                                      Provides GlobalReportStorageWebExtension for  reports
//====================================================================================================================================================*/

using System.Collections.Generic;

namespace M4PL.Web
{
    public class GlobalReportStorageWebExtension : DevExpress.XtraReports.Web.Extensions.ReportStorageWebExtension
    {
        public override bool CanSetData(string url)
        {
            return base.CanSetData(url);
        }

        public override bool IsValidUrl(string url)
        {
            return base.IsValidUrl(url);
        }

        public override byte[] GetData(string url)
        {
            return base.GetData(url);
        }

        public override Dictionary<string, string> GetUrls()
        {
            return base.GetUrls();
        }

        public override void SetData(DevExpress.XtraReports.UI.XtraReport report, string url)
        {
            base.SetData(report, url);
        }

        public override string SetNewData(DevExpress.XtraReports.UI.XtraReport report, string defaultUrl)
        {
            return base.SetNewData(report, defaultUrl);
        }
    }
}