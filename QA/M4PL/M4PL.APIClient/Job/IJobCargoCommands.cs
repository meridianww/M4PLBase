﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IJobCargoCommands
Purpose:                                      Set of rules for IJobCargoCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Job;

namespace M4PL.APIClient.Job
{
    /// <summary>
    /// Performs basic CRUD operation on the JobCargo Entity
    /// </summary>
    public interface IJobCargoCommands : IBaseCommands<JobCargoView>
    {
    }
}