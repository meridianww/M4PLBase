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
// Program Name:                                 JobAttributeView
// Purpose:                                      Represents JobAttribute Details
//====================================================================================================================================================

using M4PL.Entities;

namespace M4PL.APIClient.ViewModels.Job
{
    /// <summary>
    ///     To show details of job attribute
    /// </summary>

    public class JobAttributeView : Entities.Job.JobAttribute
    {
        public DropDownViewModel JobDropDownViewModel
        {
            get
            {
                return new DropDownViewModel { Entity = EntitiesAlias.Job, SelectedId = JobID, ValueType = typeof(long), ValueField = "Id", ControlName = "JobID", PageSize = 10, TextString = "JobSiteCode" };
            }
        }
    }
}