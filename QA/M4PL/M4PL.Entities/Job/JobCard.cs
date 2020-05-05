
/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prasanta
Date Programmed:                              02/15/2020
Program Name:                                 JobCard
Purpose:                                      Contains objects related to Job
==========================================================================================================*/

using System;

namespace M4PL.Entities.Job
{
    /// <summary>
    ///  It holds the data related to origin and delivery details for the particular program
    /// </summary>
    public class JobCard : Job
    {
        public string Destination { get; set; }
    }
}
