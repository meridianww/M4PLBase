/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              1/20/2020
Program Name:                                 IJobAdvanceReportCommands
Purpose:                                      Set of rules for JobAdvanceReportCommands
=============================================================================================================*/

using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;

namespace M4PL.Business.Job
{
    /// <summary>
    /// perfoems basic CRUD operation on the JobAdvanceReport Entity
    /// </summary>
    public interface IJobAdvanceReportCommands : IBaseCommands<JobAdvanceReport>
    {
        IList<JobAdvanceReportFilter> GetDropDownDataForProgram(ActiveUser activeUser, long customerID, string entity);
    }
}