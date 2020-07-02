#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              13/10/2017
// Program Name:                                 JobView
// Purpose:                                      Represents Job Details
//====================================================================================================================================================

namespace M4PL.APIClient.ViewModels.Job
{
    /// <summary>
    ///     To show details of job
    /// </summary>
    public class JobView : Entities.Job.Job
    {
        public string ControlNamePrefix { get; set; }
    }
}