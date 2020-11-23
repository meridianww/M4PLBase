#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 JobGatewayComplete
// Purpose:                                      Contains objects related to JobGatewayComplete
//==========================================================================================================
namespace M4PL.Entities.Support
{
    /// <summary>
    /// Model Class for Job Gateway Complete
    /// </summary>
    public class JobGatewayComplete : SysRefModel
    {
        /// <summary>
        /// Gets or Sets JobID
        /// </summary>
        public long JobID { get; set; }
        /// <summary>
        /// Gets or Sets ProgramID
        /// </summary>
        public long? ProgramID { get; set; }
        /// <summary>
        /// Gets or Sets GwyGatewayCode
        /// </summary>
        public string GwyGatewayCode { get; set; }
        /// <summary>
        /// Gets or Sets GwyGatewayTitle
        /// </summary>
        public string GwyGatewayTitle { get; set; }
        /// <summary>
        /// Gets or Sets GwyShipStatusReasonCode
        /// </summary>
        public string GwyShipStatusReasonCode { get; set; }
        /// <summary>
        /// Gets or Sets GwyShipApptmtReasonCode
        /// </summary>
        public string GwyShipApptmtReasonCode { get; set; }
        /// <summary>
        /// Gets or Sets GatewayTypeId
        /// </summary>
        public int GatewayTypeId { get; set; }
        /// <summary>
        /// Gets or Sets UpdatedValue
        /// </summary>
        public string UpdatedValue { get; set; }
        /// <summary>
        /// Gets or Sets ActualValue
        /// </summary>
        public string ActualValue { get; set; }


    }
}