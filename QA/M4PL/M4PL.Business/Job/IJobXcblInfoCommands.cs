#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                 Prashant Aggarwal
// Date Programmed:                            19/02/2020
// Program Name:                                 IJobEDIXcblCommands
// Purpose:                                      Set of rules for JobEDIXcblCommands
//==============================================================================================================

using M4PL.Entities.Job;

namespace M4PL.Business.Job
{
    /// <summary>
    /// Performs basic CRUD operation on the JobEDIXcbl Entity
    /// </summary>
    public interface IJobXcblInfoCommands : IBaseCommands<JobXcblInfo>
    {
        JobXcblInfo GetJobXcblInfo(long jobId, long gatewayId);
        bool AcceptJobXcblInfo(long jobId, long gatewayId);
        bool RejectJobXcblInfo(long gatewayId);
    }
}