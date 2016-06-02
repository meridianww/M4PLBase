//    Copyright (2016) Meridian Worldwide Transportation Group
//    All Rights Reserved Worldwide
//    ====================================================================================================================================================
//    Program Title:                                Meridian 4th Party Logistics(M4PL)
//    Programmer:                                   Janardana
//    Date Programmed:                              27/4/2016
//    Program Name:                                 _OrganisationChangedAndEnteredFormPartial
//    Purpose:                                      Contains classes related to LogError 

//    ====================================================================================================================================================

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities
{
    public class LogError
    {
        /// <summary>
        /// Gets or sets the ErrorLogId
        /// </summary>
        public int ErrorLogId { get; set; }

        /// <summary>
        /// Gets or sets the User Name
        /// </summary>
        public string UserName { get; set; }

        /// <summary>
        /// Gets or sets the Source
        /// </summary>
        public string Source { get; set; }

        /// <summary>
        /// Gets or sets the Message
        /// </summary>
        public string Message { get; set; }

        /// <summary>
        /// Gets or sets the StackTrace
        /// </summary>
        public string StackTrace { get; set; }

        /// <summary>
        /// Gets or sets the ApplicationUrl
        /// </summary>
        public string ApplicationUrl { get; set; }
    }
}
