/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IJobCommands
Purpose:                                      Set of rules for JobCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Job;
using M4PL.Entities.Job;
using System;
using System.Collections.Generic;

namespace M4PL.APIClient.Job
{
    /// <summary>
    /// Performs basic CRUD operation on the Job Entity
    /// </summary>
    public interface IJobReportCommands : IBaseCommands<JobReportView>
    {
        IList<JobVocReport> GetVocReportData(long companyId, string locationCode, DateTime? startDate, DateTime? endDate, bool IsPBSReport = false);
        IList<JobReport> GetDropDownDataForLocation(long customerID, string entity);
    }
}