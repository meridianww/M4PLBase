/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 JobGatewayView
//Purpose:                                      Represents Job Gateway Details
//====================================================================================================================================================*/

namespace M4PL.APIClient.ViewModels.Job
{
    /// <summary>
    ///     To show details of job gateway
    /// </summary>
    public class JobGatewayView : Entities.Job.JobGateway
    {
        public string CurrentAction { get; set; }
        public bool IsAction { get; set; }
        public bool IsEditOperation { get; set; }
    }
}