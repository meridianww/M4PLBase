/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IJobDocReferenceCommands
Purpose:                                      Set of rules for JobDocReferenceCommands
=============================================================================================================*/

using M4PL.Entities.Job;
using M4PL.Entities.Support;

namespace M4PL.Business.Job
{
    /// <summary>
    /// Performs basis CRUD operation on the JobDocReference Entity
    /// </summary>
    public interface IJobDocReferenceCommands : IBaseCommands<JobDocReference>
    {
        JobDocReference PutWithSettings(SysSetting userSysSetting, JobDocReference jobDocReference);

        JobDocReference PostWithSettings(SysSetting userSysSetting, JobDocReference jobDocReference);
    }
}