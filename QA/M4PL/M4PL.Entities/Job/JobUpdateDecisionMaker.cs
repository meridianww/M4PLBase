namespace M4PL.Entities.Job
{
    public class JobUpdateDecisionMaker
    {
        public string ActionCode { get; set; }
        public string xCBLColumnName { get; set; }
        public string JobColumnName { get; set; }
        public bool IsAutoUpdate { get; set; }
        public string XCBLTableName { get; set; }

    }
}
