/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ColumnSetting
Purpose:                                      Contains objects related to ColumnSetting
==========================================================================================================*/

namespace M4PL.Entities.Support
{
    /// <summary>
    ///
    /// </summary>
    public class ColumnSetting
    {
        public long Id { get; set; }

        /// <summary>
        /// Gets or sets the selected table name from the look up.
        /// </summary>
        /// <value>
        /// The ColTableName.
        /// </value>
        public string ColTableName { get; set; }

        /// <summary>
        /// Gets or sets the column name of the slected table.
        /// </summary>
        /// <value>
        /// The ColColumnName.
        /// </value>

        public string ColColumnName { get; set; }

        /// <summary>
        /// Gets or sets the alias cname of the column.
        /// </summary>
        /// <value>
        /// The ColAliasName.
        /// </value>

        public string ColAliasName { get; set; }

        /// <summary>
        /// Gets or sets the grid alias cname of the column.
        /// </summary>
        /// <value>
        /// The ColAliasName.
        /// </value>

        public string ColGridAliasName { get; set; }

        /// <summary>
        /// Gets or sets the ColLookupId.
        /// </summary>
        /// <value>
        /// The ColLookupId.
        /// </value>

        public int ColLookupId { get; set; }

        public string ColLookupCode { get; set; }

        /// <summary>
        /// Gets or sets the identifier.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>

        public string ColCaption { get; set; }

        /// <summary>
        /// Gets or sets the description.
        /// </summary>
        /// <value>
        /// The ColDescription.
        /// </value>

        public string ColDescription { get; set; }

        /// <summary>
        /// Gets or sets the sorting order.
        /// </summary>
        /// <value>
        /// The ColSortOrder.
        /// </value>

        public int ColSortOrder { get; set; }

        /// <summary>
        /// Gets or sets the visiblity of the column.
        /// </summary>
        /// <value>
        /// The ColIsVisible.
        /// </value>

        public bool ColIsVisible { get; set; }

        /// <summary>
        /// Gets or sets the column has to be readonly.
        /// </summary>
        /// <value>
        /// The ColIsReadOnly.
        /// </value>

        public bool ColIsReadOnly { get; set; }

        /// <summary>
        /// Gets or sets the column as default.
        /// </summary>
        /// <value>
        /// The ColIsDefault.
        /// </value>

        public bool ColIsDefault { get; set; }

        /// <summary>
        /// Gets or sets the columns choosen by the user.
        /// </summary>
        /// <value>
        /// The ColIsFreezed.
        /// </value>

        public bool ColIsFreezed { get; set; }

        /// <summary>
        /// Gets or sets the columns choosen by the user.
        /// </summary>
        /// <value>
        /// The ColIsGroupBy.
        /// </value>

        public bool ColIsGroupBy { get; set; }

        /// <summary>
        /// Gets or sets the required option flag.
        /// </summary>
        /// <value>
        /// The IsRequired.
        /// </value>

        public bool IsRequired { get; set; }

        /// <summary>
        /// Gets or sets the required message for the column.
        /// </summary>
        /// <value>
        /// The RequiredMessage.
        /// </value>

        public string RequiredMessage { get; set; }

        /// <summary>
        /// Gets or sets the unique option flag.
        /// </summary>
        /// <value>
        /// The IsUnique.
        /// </value>
        public bool IsUnique { get; set; }

        /// <summary>
        /// Gets or sets the unique message for the column.
        /// </summary>
        /// <value>
        /// The UniqueMessage.
        /// </value>

        public string UniqueMessage { get; set; }

        /// <summary>
        /// Gets or sets the data type.
        /// </summary>
        /// <value>
        /// The DataType.
        /// </value>

        public string DataType { get; set; }

        /// <summary>
        /// Gets or sets the maximum length.
        /// </summary>
        /// <value>
        /// The MaxLength.
        /// </value>

        public int MaxLength { get; set; }

        /// <summary>
        /// Gets or sets HasValidation.
        /// </summary>
        /// <value>
        /// The HasValidation.
        /// </value>

        public bool HasValidation { get; set; }

        /// <summary>
        /// Gets or sets the grid layout.
        /// </summary>
        /// <value>
        /// The GridLayout.
        /// </value>

        public string GridLayout { get; set; }

        /// <summary>
        /// Gets or sets the Relational entity name.
        /// </summary>
        public string RelationalEntity { get; set; }

        /// <summary>
        /// Display format for the specific column
        /// </summary>
        public string ColDisplayFormat { get; set; }

        public bool GlobalIsVisible { get; set; }

        public bool ColAllowNegativeValue { get; set; }

        public string ColMask { get; set; }
    }
}