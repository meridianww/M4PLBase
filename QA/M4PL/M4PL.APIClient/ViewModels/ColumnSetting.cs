/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              13/10/2017
//Program Name:                                 ColumnSetting
//Purpose:                                      Represents ColumnSetting Details
//====================================================================================================================================================*/

using System;

namespace M4PL.APIClient.ViewModels
{
    public class ColumnSetting : ICloneable
    {
        public object Clone()
        {
            return this.MemberwiseClone();
        }

        public ColumnSetting DeepCopy()
        {
            ColumnSetting columnSetting = (ColumnSetting)this.MemberwiseClone();
            if (!string.IsNullOrEmpty(ColTableName))
                columnSetting.ColTableName = String.Copy(ColTableName);
            if (!string.IsNullOrEmpty(ColColumnName))
                columnSetting.ColColumnName = String.Copy(ColColumnName);
            if (!string.IsNullOrEmpty(ColAliasName))
                columnSetting.ColAliasName = String.Copy(ColAliasName);
            if (!string.IsNullOrEmpty(ColLookupCode))
                columnSetting.ColLookupCode = String.Copy(ColLookupCode);
            if (!string.IsNullOrEmpty(ColCaption))
                columnSetting.ColCaption = String.Copy(ColCaption);
            if (!string.IsNullOrEmpty(ColDescription))
                columnSetting.ColDescription = String.Copy(ColDescription);
            if (!string.IsNullOrEmpty(RequiredMessage))
                columnSetting.RequiredMessage = String.Copy(RequiredMessage);
            if (!string.IsNullOrEmpty(UniqueMessage))
                columnSetting.UniqueMessage = String.Copy(UniqueMessage);
            if (!string.IsNullOrEmpty(DataType))
                columnSetting.DataType = String.Copy(DataType);
            if (!string.IsNullOrEmpty(GridLayout))
                columnSetting.GridLayout = String.Copy(GridLayout);
            if (!string.IsNullOrEmpty(RelationalEntity))
                columnSetting.RelationalEntity = String.Copy(RelationalEntity);
            if (!string.IsNullOrEmpty(ColDisplayFormat))
                columnSetting.ColDisplayFormat = String.Copy(ColDisplayFormat);
            if (!string.IsNullOrEmpty(ColMask))
                columnSetting.ColMask = String.Copy(ColMask);
            return columnSetting;
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

        public bool ColIsGroupBy { get; set; }

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

        public string ColMask { get; set; }
    }
}