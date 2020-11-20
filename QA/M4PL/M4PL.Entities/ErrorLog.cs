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
    /// <summary>
    /// Model for ErrorLog
    /// </summary>
    public class ErrorLog
    {
        /// <summary>
        /// Get or Set for ID
        /// </summary>
        public long Id { get; set; }
        /// <summary>
        /// Get or Set for ErrRelatedTo
        /// </summary>
        public string ErrRelatedTo { get; set; }
        /// <summary>
        /// Get or Set for ErrInnerException
        /// </summary>
        public string ErrInnerException { get; set; }
        /// <summary>
        /// Get or Set for ErrMessage
        /// </summary>
        public string ErrMessage { get; set; }
        /// <summary>
        /// Get or Set for ErrSource
        /// </summary>
        public string ErrSource { get; set; }
        /// <summary>
        /// Get or Set for ErrStackTrace
        /// </summary>
        public string ErrStackTrace { get; set; }
        /// <summary>
        /// Get or Set for ErrAdditionalMessage
        /// </summary>
        public string ErrAdditionalMessage { get; set; }
        /// <summary>
        /// Get or Set for ErrDateStamp
        /// </summary>
        public DateTime ErrDateStamp { get; set; }
    }
}