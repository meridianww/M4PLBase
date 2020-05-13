/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 JobDocReferenceView
//Purpose:                                      Represents Job DocumentReference  Details
//====================================================================================================================================================*/

namespace M4PL.APIClient.ViewModels.Job
{
    /// <summary>
    ///     To show details of job document reference
    /// </summary>
    public class JobDocReferenceView : Entities.Job.JobDocReference
    {
        public bool IsNew { get; set; }
    }
}