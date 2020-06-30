/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 PrgShipApptmtReasonCode
Purpose:                                      Contains objects related to PrgShipApptmtReasonCode
==========================================================================================================*/

namespace M4PL.Entities.Program
{
    /// <summary>
    ///
    /// </summary>
    public class PrgShipApptmtReasonCode : BaseModel
    {
        /// <summary>
        /// Gets or sets the organization identifier.
        /// </summary>
        /// <value>
        /// The PacOrgID.
        /// </value>
        public long? PacOrgID { get; set; }

        public string PacOrgIDName { get; set; }

        /// <summary>
        /// Gets or sets the program identifier.
        /// </summary>
        /// <value>
        /// The PacProgramID.
        /// </value>

        public long? PacProgramID { get; set; }
        public string PacProgramIDName { get; set; }
        /// <summary>
        /// Gets or sets the sorting order.
        /// </summary>
        /// <value>
        /// The PacApptItem.
        /// </value>

        public int? PacApptItem { get; set; }
        /// <summary>
        /// Gets or sets the reason code.
        /// </summary>
        /// <value>
        /// The PacApptReasonCode.
        /// </value>

        public string PacApptReasonCode { get; set; }
        /// <summary>
        /// Gets or sets the length.
        /// </summary>
        /// <value>
        /// The PacApptLength.
        /// </value>

        public int? PacApptLength { get; set; }
        /// <summary>
        /// Gets or sets the internal code.
        /// </summary>
        /// <value>
        /// The PacApptInternalCode.
        /// </value>

        public string PacApptInternalCode { get; set; }
        /// <summary>
        /// Gets or sets the priority Code.
        /// </summary>
        /// <value>
        /// The PacApptPriorityCode.
        /// </value>

        public string PacApptPriorityCode { get; set; }
        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The PacApptTitle.
        /// </value>

        public string PacApptTitle { get; set; }
        /// <summary>
        /// Gets or sets the description.
        /// </summary>
        /// <value>
        /// The PacApptDescription.
        /// </value>

        public byte[] PacApptDescription { get; set; }
        /// <summary>
        /// Gets or sets the comment.
        /// </summary>
        /// <value>
        /// The PacApptComment.
        /// </value>

        public byte[] PacApptComment { get; set; }
        /// <summary>
        /// Gets or sets the category code identifier.
        /// </summary>
        /// <value>
        /// The PacApptCategoryCode.
        /// </value>

        public int? PacApptCategoryCodeId { get; set; }
        /// <summary>
        /// Gets or sets the Usercode01.
        /// </summary>
        /// <value>
        /// The PacApptUser01Code.
        /// </value>

        public string PacApptUser01Code { get; set; }
        /// <summary>
        /// Gets or sets the Usercode02.
        /// </summary>
        /// <value>
        /// The PacApptUser02Code.
        /// </value>

        public string PacApptUser02Code { get; set; }
        /// <summary>
        /// Gets or sets the Usercode03.
        /// </summary>
        /// <value>
        /// The PacApptUser03Code.
        /// </value>

        public string PacApptUser03Code { get; set; }
        /// <summary>
        /// Gets or sets the Usercode04.
        /// </summary>
        /// <value>
        /// The PacApptUser04Code.
        /// </value>

        public string PacApptUser04Code { get; set; }
        /// <summary>
        /// Gets or sets the Usercode05.
        /// </summary>
        /// <value>
        /// The PacApptUser05Code.
        /// </value>

        public string PacApptUser05Code { get; set; }
    }
}