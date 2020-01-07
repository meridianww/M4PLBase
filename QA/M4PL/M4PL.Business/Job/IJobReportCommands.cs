/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IJobReportCommands
Purpose:                                      Set of rules for JobReportCommands
=============================================================================================================*/
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;

namespace M4PL.Business.Job
{
    /// <summary>
    /// Performs Reports for Job
    /// </summary>
    public interface IJobReportCommands : IBaseCommands<JobReport>
    {
        IList<JobVocReport> GetVocReportData(long companyId, string locationCode, DateTime? startDate, DateTime? endDate, bool IsPBSReport);
        IList<JobAdvanceReport> GetDropDownDataForProgram(ActiveUser activeUser,long customerID, string entity);
    }
}