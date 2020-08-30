#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              1/20/2020
// Program Name:                                 JobAdvanceReportCommands
// Purpose:                                      Set of rules for JobAdvanceReportCommands
//====================================================================================================================

using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Job.JobAdvanceReportCommands;

namespace M4PL.Business.Job
{
    public class JobAdvanceReportCommands : BaseCommands<JobAdvanceReport>, IJobAdvanceReportCommands
    {
        public int Delete(long id)
        {
            throw new NotImplementedException();
        }

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            throw new NotImplementedException();
        }

        public JobAdvanceReport Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        public IList<JobAdvanceReport> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        public JobAdvanceReport Patch(JobAdvanceReport entity)
        {
            throw new NotImplementedException();
        }

        public JobAdvanceReport Post(JobAdvanceReport entity)
        {
            throw new NotImplementedException();
        }

        public JobAdvanceReport Put(JobAdvanceReport entity)
        {
            throw new NotImplementedException();
        }
        public IList<JobAdvanceReportFilter> GetDropDownDataForProgram(ActiveUser activeUser, long customerId, string entity)
        {
            return _commands.GetDropDownDataForProgram(activeUser, customerId, entity);
        }
        public StatusModel GenerateScrubDriverDetails(ActiveUser activeUser, JobDriverScrubReportData scriberDriverView)
        {
            var result = _commands.InsertDriverScrubReportRawData(scriberDriverView, activeUser);
            return new StatusModel
            {
                Status = result ? "Success" : "Fail",
                StatusCode = result ? 200 : 500,
                AdditionalDetail = result ? "Record has been uploaded successfully" : "Failed to uploaded record"
            };
        }
        public StatusModel GenerateProjectedCapacityDetails(ActiveUser activeUser, ProjectedCapacityData projectedCapacityView)
        {
            var result = _commands.InsertProjectedCapacityRawData(projectedCapacityView, activeUser);
            return new StatusModel
            {
                Status = result ? "Success" : "Fail",
                StatusCode = result ? 200 : 500,
                AdditionalDetail = result ? "Record has been uploaded successfully" : "Failed to uploaded record"
            };
        }
    }
}