#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

namespace M4PL.Entities.XCBL
{
    /// <summary>
    /// XCBL Model class to Get or Set Details
    /// </summary>
    public class XCBLToM4PLRequest
    {
        /// <summary>
        /// Gets or Sets Id for the Entity
        /// </summary>
        public int EntityId { get; set; }
        /// <summary>
        /// Dynamic Request object which will be converted based on requirement e.g. Converted as SummaryHeader model to insert into Summary Header table
        /// </summary>
        public object Request { get; set; }
    }
}
