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
