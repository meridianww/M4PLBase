/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 JobCargo
Purpose:                                      Contains objects related to JobCargo
==========================================================================================================*/

namespace M4PL.Entities.Job
{
    /// <summary>
    ///
    /// </summary>
    public class JobCargo : BaseModel
    {
        /// <summary>
        /// Gets or sets the Job identifier.
        /// </summary>
        /// <value>
        /// The Job identifier.
        /// </value>
        public long? JobID { get; set; }

        public string JobIDName { get; set; }

        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>
        public int? CgoLineItem { get; set; }

        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public string CgoPartNumCode { get; set; }

        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>
        public string CgoTitle { get; set; }

        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public string CgoSerialNumber { get; set; }

        public int? CgoPackagingTypeId { get; set; }

        public string CgoPackagingTypeIdName { get; set; }

        public string CgoMasterCartonLabel { get; set; }

        public decimal CgoWeight { get; set; }

        public int? CgoWeightUnitsId { get; set; }

        public string CgoWeightUnitsIdName { get; set; }

        public decimal CgoLength { get; set; }

        public decimal CgoWidth { get; set; }

        public decimal CgoHeight { get; set; }

        public int? CgoVolumeUnitsId { get; set; }

        public string CgoVolumeUnitsIdName { get; set; }

        public decimal CgoCubes { get; set; }

        public decimal CgoQtyExpected { get; set; }

        public decimal CgoQtyOnHand { get; set; }

        public decimal CgoQtyDamaged { get; set; }

        public decimal CgoQtyOnHold { get; set; }

        public decimal CgoQtyShortOver { get; set; }

        public int? CgoQtyUnitsId { get; set; }

        public string CgoQtyUnitsIdName { get; set; }

        public string CgoReasonCodeOSD { get; set; }

        public string CgoReasonCodeHold { get; set; }


        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>
        public int? CgoSeverityCode { get; set; }

        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public string CgoProcessingFlags { get; set; }

        public bool JobCompleted { get; set; }

        public string CgoLatitude { get; set; }

        public string CgoLongitude { get; set; }

        public decimal CgoQtyOrdered { get; set; }
    }
}