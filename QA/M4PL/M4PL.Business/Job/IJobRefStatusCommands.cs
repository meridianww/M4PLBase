/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IJobRefStatusCommands
Purpose:                                      Set of rules for JobRefStatusCommands
=============================================================================================================*/

using M4PL.Entities.Job;

namespace M4PL.Business.Job
{
    /// <summary>
    /// Perfomrs basic CRUD operation on the JobRefStatus Entity
    /// </summary>
    public interface IJobRefStatusCommands : IBaseCommands<JobRefStatus>
    {
    }
}