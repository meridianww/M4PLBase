#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System;

namespace M4PL.Entities
{
    public class ChangeHistory
    {
        public string OrigionalData { get; set; }
        public string ChangedData { get; set; }
        public string ChangedBy { get; set; }
        public DateTime ChangedDate { get; set; }
    }
}
