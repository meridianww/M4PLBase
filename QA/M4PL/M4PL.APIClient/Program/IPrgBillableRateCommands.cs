﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 IPrgBillableRateCommands
Purpose:                                      Set of rules for PrgBillableRateCommands
=============================================================================================================*/

using M4PL.APIClient.ViewModels.Program;

namespace M4PL.APIClient.Program
{
    /// <summary>
    /// Performs basic CRUD operation on the ProgramBillableRate Entity
    /// </summary>
    public interface IPrgBillableRateCommands : IBaseCommands<ProgramBillableRateView>
    {
    }
}