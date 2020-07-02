#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

namespace M4PL.Entities.Job
{
    public class JobCardTileDetail : BaseModel
    {
        public long DashboardCategoryRelationId { get; set; }

        public long RecordCount { get; set; }
        public string DashboardName { get; set; }
        public string DashboardCategoryDisplayName { get; set; }
        public string DashboardSubCategoryDisplayName { get; set; }
        public string BackGroundColor { get; set; }
        public string FontColor { get; set; }
        public string DashboardCategoryName { get; set; }
        public string DashboardSubCategoryName { get; set; }
    }
}
