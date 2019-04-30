/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 JobAttributeView
//Purpose:                                      Represents JobAttribute Details
//====================================================================================================================================================*/

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