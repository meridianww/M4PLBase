/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kamal
Date Programmed:                              04/18/2020
Program Name:                                 JobSurvey
Purpose:                                      Contains model for JobSurvey
=============================================================================================================*/

using System.Collections.Generic;

namespace M4PL.Entities.Signature
{
    public class JobSignature
    {
        public long Id { get; set; }
        public long JobId { get; set; }
        public string UserName { get; set; }
        public string Signature { get; set; }
    }
}






