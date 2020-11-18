#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

namespace M4PL.Entities.XCBL.Electrolux
{
    public class DeliveryUpdateProcessingData
    {
        /// <summary>
        /// Gets or Sets ID of JobDL070DeliveryUpdateProcessingLog
        /// </summary>
        public long Id { get; set; }
        /// <summary>
        /// Gets or Sets flag if the update is processed
        /// </summary>
        public bool IsProcessed { get; set; }
        /// <summary>
        /// Gets or Sets JobId
        /// </summary>
        public long JobId { get; set; }
        /// <summary>
        /// Gets or Sets Order Number
        /// </summary>
        public string OrderNumber { get; set; }
    }
}
