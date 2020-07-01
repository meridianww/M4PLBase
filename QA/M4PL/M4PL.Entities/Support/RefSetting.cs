namespace M4PL.Entities.Support
{
    public class RefSetting
    {
        public EntitiesAlias Entity { get; set; }
        public string EntityName { get; set; }
        public string Name { get; set; }
        public string Value { get; set; }
        public string ValueType { get; set; }
        public bool IsOverWritable { get; set; }
        public bool IsSysAdmin { get; set; }

    }
}
