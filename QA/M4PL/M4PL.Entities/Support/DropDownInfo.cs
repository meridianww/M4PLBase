#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//==========================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/04/2017
// Program Name:                                 DropDownInfo
// Purpose:                                      Contains objects related to DropDownInfo
//==========================================================================================================

namespace M4PL.Entities.Support
{
    /// <summary>
    /// Model for Drop down info
    /// </summary>
    public class DropDownInfo
    {
        /// <summary>
        /// DropDownInfo constructor
        /// </summary>
        public DropDownInfo()
        {
            PageId = 1;
            PageNumber = 1;
            PageSize = 30;
        }
        /// <summary>
        /// all drop down deatils in overloaded constructor
        /// </summary>
        /// <param name="dropDownInfo"></param>
        public DropDownInfo(DropDownInfo dropDownInfo)
        {
            RecordId = dropDownInfo.RecordId;
            ParentId = dropDownInfo.ParentId;
            PageId = dropDownInfo.PageId;
            PageNumber = dropDownInfo.PageNumber;
            PageSize = dropDownInfo.PageSize;
            OrderBy = dropDownInfo.OrderBy;
            WhereCondition = dropDownInfo.WhereCondition;
            TotalCount = dropDownInfo.TotalCount;
            Entity = dropDownInfo.Entity;
            Contains = dropDownInfo.Contains;
            TableFields = dropDownInfo.TableFields;
            ColumnName = dropDownInfo.ColumnName;
            IsRequiredAll = dropDownInfo.IsRequiredAll;
            ControlAction = dropDownInfo.ControlAction;
            WhereConditionExtention = dropDownInfo.WhereConditionExtention;
            //isException = dropDownInfo.isException;
        }

        /// <summary>
        /// Get or Set for RecordId
        /// </summary>
        public long RecordId { get; set; }
        /// <summary>
        /// Get or Set for ParentId
        /// </summary>
        public long ParentId { get; set; }
        /// <summary>
        /// Get or Set for PageId
        /// </summary>
        public int PageId { get; set; }
        /// <summary>
        /// Get or Set for PageNumber
        /// </summary>
        public int PageNumber { get; set; }
        /// <summary>
        /// Get or Set for PageSize
        /// </summary>
        public int PageSize { get; set; }
        /// <summary>
        /// Get or Set for OrderBy
        /// </summary>
        public string OrderBy { get; set; }
        /// <summary>
        /// Get or Set for WhereCondition
        /// </summary>
        public string WhereCondition { get; set; }
        /// <summary>
        /// Get or Set for TotalCount
        /// </summary>
        public int TotalCount { get; set; }
        /// <summary>
        /// Get or Set for Entity
        /// </summary>
        public EntitiesAlias? Entity { get; set; }
        /// <summary>
        /// Get or Set for Contains
        /// </summary>
        public string Contains { get; set; }
        /// <summary>
        /// Get or Set for TableFields
        /// </summary>
        public string TableFields { get; set; }
        /// <summary>
        /// Get or Set for PrimaryKeyValue
        /// </summary>
        public string PrimaryKeyValue { get; set; }
        /// <summary>
        /// Get or Set for PrimaryKeyName
        /// </summary>
        public string PrimaryKeyName { get; set; }
        /// <summary>
        /// Get or Set for ColumnName
        /// </summary>
        public string ColumnName { get; set; }
        /// <summary>
        /// Get or Set for EntityFor
        /// </summary>
        public EntitiesAlias? EntityFor { get; set; }
        /// <summary>
        /// Get or Set for ParentEntity
        /// </summary>
        public EntitiesAlias? ParentEntity { get; set; }
        /// <summary>
        /// Get or Set for CompanyId
        /// </summary>
        public long? CompanyId { get; set; }
        /// <summary>
        /// Get or Set for JobSiteCode
        /// </summary>
        public string JobSiteCode { get; set; }
        /// <summary>
        /// Get or Set for IsRequiredAll
        /// </summary>
        public bool IsRequiredAll { get; set; }
        /// <summary>
        /// Get or Set for ProgramIdCode
        /// </summary>
        public string ProgramIdCode { get; set; }
        /// <summary>
        /// Get or Set for SelectedCountry
        /// </summary>
        public string SelectedCountry { get; set; }
        /// <summary>
        /// Get or Set for ControlAction
        /// </summary>
        public string ControlAction { get; set; }
        /// <summary>
        /// Get or Set for WhereConditionExtention
        /// </summary>
        public string WhereConditionExtention { get; set; }
    }
}