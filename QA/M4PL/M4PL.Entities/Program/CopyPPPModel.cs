#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using System.Collections.Generic;

namespace M4PL.Entities.Program
{
    public class CopyPPPModel
    {
        public CopyPPPModel()
        {
            IsEDI = false;
        }
        /// <summary>
        /// Gets or Sets Record Id e.g. If Program is being copies then ProgramID, if Project is being copies then ProjectId
        /// </summary>
        public long RecordId { get; set; }
        /// <summary>
        /// Gets or Sets Select All flag (require for on demand tree list for DB update)
        /// </summary>
        public bool SelectAll { get; set; } // require for on demand tree list for DB update

        public bool IsEDI { get; set; }

        /// <summary>
        /// Gets or Sets Ids if selected All
        /// </summary>
        public List<string> ConfigurationIds { get; set; } // SELECT ALL
                                                           /// <summary>
                                                           /// Gets or Sets List PPP Ids destination to be copies
                                                           /// </summary>
        public List<long> ToPPPIds { get; set; }
        /// <summary>
        /// Gets or Sets Copy PPP Model for recusrive Copy
        /// </summary>
        public List<CopyPPPModel> CopyPPPModelSub { get; set; }
    }

    public class CopyProgramModel
    {
        public CopyProgramModel()
        {

        }
        /// <summary>
        /// Gets or Sets Record Id e.g. If Program is being copies then ProgramID, if Project is being copies then ProjectId
        /// </summary>
        public long RecordId { get; set; }

        /// <summary>
        /// Is gateway copy
        /// </summary>
        public bool IsGateway { get; set; }

        /// <summary>
        /// Is Appointment Code copy
        /// </summary>
        public bool IsAppointmentCode { get; set; }

        /// <summary>
        /// Is Reason Code copy
        /// </summary>
        public bool IsReasonCode { get; set; }

        /// <summary>
        /// Gets or Sets List PPP Ids destination to be copies
        /// </summary>
        public List<long> ToPPPIds { get; set; }
    }

    public class CopyPPPDbModel
    {
        /// <summary>
        /// Gets or Sets Records Id e.g. If Program is being copies then ProgramID, if Project is being copies then ProjectId
        /// </summary>
        public long RecordId { get; set; }
        /// <summary>
        /// Gets or Sets flag if Selected All under a node
        /// </summary>
        public bool SelectAll { get; set; }
        /// <summary>
        /// Gets or Sets Ids if selected All
        /// </summary>
        public string ConfigurationIds { get; set; }
        /// <summary>
        /// Gets or Sets List PPP Ids destination to be copies
        /// </summary>
        public string ToPPPIds { get; set; }
        /// <summary>
        /// Gets or Sets Parent Id
        /// </summary>
        public long? ParentId { get; set; }
    }
}