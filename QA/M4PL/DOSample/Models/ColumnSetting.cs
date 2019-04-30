using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DOSample.Models
{
    public class ColumnSetting : ICloneable
    {
        public object Clone()
        {
            return this.MemberwiseClone();
        }

        public long Id { get; set; }

        public string ColTableName { get; set; }

        public string ColColumnName { get; set; }

        public string ColAliasName { get; set; }

        public int ColLookupId { get; set; }

        public string ColLookupCode { get; set; }

        public string ColCaption { get; set; }

        public string ColDescription { get; set; }

        public int ColSortOrder { get; set; }

        public bool ColIsVisible { get; set; }

        public bool ColIsReadOnly { get; set; }

        public bool ColIsDefault { get; set; }

        public bool ColIsFreezed { get; set; }

        public bool IsRequired { get; set; }

        public string RequiredMessage { get; set; }

        public bool IsUnique { get; set; }

        public string UniqueMessage { get; set; }

        public string DataType { get; set; }

        public int MaxLength { get; set; }

        public bool HasValidation { get; set; }

        public string GridLayout { get; set; }

        public string RelationalEntity { get; set; }

        public string ColDisplayFormat { get; set; }

        public bool GlobalIsVisible { get; set; }
        public bool ColAllowNegativeValue { get; set; }

        public bool IsGrouped { get; set; }
    }

}