/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IJobAttributeCommands
Purpose:                                      Set of rules for JobAttributeCommands
=============================================================================================================*/

using M4PL.Entities.Job;

namespace M4PL.Business.Job
{
    /// <summary>
    /// perfoems basic CRUD operation on the JobAttribute Entity
    /// </summary>
    public interface IJobAttributeCommands : IBaseCommands<JobAttribute>
    {
    }
}