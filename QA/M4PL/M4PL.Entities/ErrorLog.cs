/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Error Log
Programmer:                                   Kirty Anurag
Date Programmed:                              02/10/2018
Program Name:                                 Error log
Purpose:                                      Contains objects related to Error log
==========================================================================================================*/

using System;

namespace M4PL.Entities
{
    public class ErrorLog
    {
        public long Id { get; set; }
        public string ErrRelatedTo { get; set; }
        public string ErrInnerException { get; set; }
        public string ErrMessage { get; set; }
        public string ErrSource { get; set; }
        public string ErrStackTrace { get; set; }
        public string ErrAdditionalMessage { get; set; }
        public DateTime ErrDateStamp { get; set; }
    }
}