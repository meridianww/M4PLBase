/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 {EntityName}
Purpose:                                      Contains objects related to { EntityName }
==========================================================================================================*/

namespace M4PL.Entities.Program
{
    /// <summary>
    ///
    /// </summary>
    public class PrgShipStatusReasonCode : BaseModel
    {
        /// <summary>
        /// Gets or sets the organization identifier.
        /// </summary>
        /// <value>
        /// The organization identifier.
        /// </value>
        public long? PscOrgID { get; set; }

        public string PscOrgIDName { get; set; }

        /// <summary>
        /// Gets or sets the program identifier.
        /// </summary>
        /// <value>
        /// The program identifier.
        /// </value>
        public long? PscProgramID { get; set; }

        public string PscProgramIDName { get; set; }

        /// <summary>
        /// Gets or sets the ship item.
        /// </summary>
        /// <value>
        /// The PscShipItem.
        /// </value>
        public int? PscShipItem { get; set; }

        /// <summary>
        /// Gets or sets the reason code.
        /// </summary>
        /// <value>
        /// The PscShipReasonCode.
        /// </value>
        public string PscShipReasonCode { get; set; }

        /// <summary>
        /// Gets or sets the length for the shipment.
        /// </summary>
        /// <value>
        /// The PscShipLength.
        /// </value>
        public int? PscShipLength { get; set; }

        /// <summary>
        /// Gets or sets the internal code.
        /// </summary>
        /// <value>
        /// The PscShipInternalCode.
        /// </value>
        public string PscShipInternalCode { get; set; }

        /// <summary>
        /// Gets or sets the prioritycode.
        /// </summary>
        /// <value>
        /// The PscShipPriorityCode.
        /// </value>
        public string PscShipPriorityCode { get; set; }

        /// <summary>
        /// Gets or sets the title.
        /// </summary>
        /// <value>
        /// The PscShipTitle.
        /// </value>
        public string PscShipTitle { get; set; }

        /// <summary>
        /// Gets or sets the description.
        /// </summary>
        /// <value>
        /// The PscShipDescription.
        /// </value>
        public byte[] PscShipDescription { get; set; }

        /// <summary>
        /// Gets or sets the comment.
        /// </summary>
        /// <value>
        /// The PscShipComment.
        /// </value>
        public byte[] PscShipComment { get; set; }

        /// <summary>
        /// Gets or sets the category code.
        /// </summary>
        /// <value>
        /// The PscShipCategoryCode.
        /// </value>
        public string PscShipCategoryCode { get; set; }

        /// <summary>
        /// Gets or sets the usercode01.
        /// </summary>
        /// <value>
        /// The PscShipUser01Code.
        /// </value>
        public string PscShipUser01Code { get; set; }

        /// <summary>
        /// Gets or sets the usercode02.
        /// </summary>
        /// <value>
        /// The PscShipUser02Code.
        /// </value>
        public string PscShipUser02Code { get; set; }

        /// <summary>
        /// Gets or sets the usercode03.
        /// </summary>
        /// <value>
        /// The PscShipUser03Code.
        /// </value>
        public string PscShipUser03Code { get; set; }

        /// <summary>
        /// Gets or sets the usercode04.
        /// </summary>
        /// <value>
        /// The PscShipUser04Code.
        /// </value>
        public string PscShipUser04Code { get; set; }

        /// <summary>
        /// Gets or sets the usercode05.
        /// </summary>
        /// <value>
        /// The PscShipUser0Code.
        /// </value>
        public string PscShipUser05Code { get; set; }
    }
}