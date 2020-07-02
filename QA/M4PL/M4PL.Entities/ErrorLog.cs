#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//==========================================================================================================
// Program Title:                                Error Log
// Programmer:                                   Kirty Anurag
// Date Programmed:                              02/10/2018
// Program Name:                                 Error log
// Purpose:                                      Contains objects related to Error log
//==========================================================================================================

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