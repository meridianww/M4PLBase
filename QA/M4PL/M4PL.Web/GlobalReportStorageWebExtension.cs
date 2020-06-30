#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
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