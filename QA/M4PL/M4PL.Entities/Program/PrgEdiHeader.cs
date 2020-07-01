/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 PrgEdiHeader
Purpose:                                      Contains objects related to PrgEdiHeader
==========================================================================================================*/

using System;
using System.ComponentModel.DataAnnotations;

namespace M4PL.Entities.Program
{
    /// <summary>
    ///
    /// </summary>
    public class PrgEdiHeader : BaseModel
    {
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>
        public long? PehProgramID { get; set; }

        public string PehProgramIDName { get; set; }

        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public int? PehItemNumber { get; set; }
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public string PehEdiCode { get; set; }
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public string PehEdiTitle { get; set; }
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public byte[] PehEdiDescription { get; set; }
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public string PehTradingPartner { get; set; }
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public string PehEdiDocument { get; set; }
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public string PehEdiVersion { get; set; }
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public string PehSCACCode { get; set; }
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public int? PehAttachments { get; set; }
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public DateTime? PehDateStart { get; set; }
        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public DateTime? PehDateEnd { get; set; }

        public bool PehSndRcv { get; set; }


        public bool PehParentEDI { get; set; }
        public string PehInsertCode { get; set; }
        public string PehUpdateCode { get; set; }
        public string PehCancelCode { get; set; }
        public string PehHoldCode { get; set; }
        public string PehOriginalCode { get; set; }
        public string PehReturnCode { get; set; }


        /// <summary>
        /// Gets or sets Insert Code.
        /// </summary>
        /// <value>
        /// The PehInsertCode.
        /// </value>
        public string UDF01 { get; set; }

        /// <summary>
        /// Gets or sets the Update Code.
        /// </summary>
        /// <value>
        /// The PehUpdateCode.
        /// </value>
        public string UDF02 { get; set; }

        /// <summary>
        /// Gets or sets the Cancel Code.
        /// </summary>
        /// <value>
        /// The PehCancelCode.
        /// </value>
        public string UDF03 { get; set; }
        /// <summary>
        /// Gets or sets the Hold Code.
        /// </summary>
        /// <value>
        /// The PehHoldCode.
        /// </value>
        public string UDF04 { get; set; }
        public string UDF05 { get; set; }
        public string UDF06 { get; set; }
        public string UDF07 { get; set; }
        public string UDF08 { get; set; }
        public string UDF09 { get; set; }
        public string UDF10 { get; set; }
        public string PehInOutFolder { get; set; }
        public string PehArchiveFolder { get; set; }
        public string PehProcessFolder { get; set; }
        public string PehFtpServerUrl { get; set; }
        public string PehFtpUsername { get; set; }
        [DataType(DataType.Password)]
        [Display(Name = "FTP Password")]
        public string PehFtpPassword { get; set; }
        public string PehFtpPort { get; set; }
		public bool IsSFTPUsed { get; set; }
	}
}