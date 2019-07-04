/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/04/2017
Program Name:                                 DropDownInfo
Purpose:                                      Contains objects related to DropDownInfo
==========================================================================================================*/

namespace M4PL.Entities.Support
{
    public class DropDownInfo
    {
        public DropDownInfo()
        {
            PageId = 1;
            PageNumber = 1;
            PageSize = 30;
        }

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
        }

        public long RecordId { get; set; }
        public long ParentId { get; set; }
        public int PageId { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public string OrderBy { get; set; }
        public string WhereCondition { get; set; }
        public int TotalCount { get; set; }
        public EntitiesAlias? Entity { get; set; }
        public string Contains { get; set; }
        public string TableFields { get; set; }
        public string PrimaryKeyValue { get; set; }
        public string PrimaryKeyName { get; set; }
        public string ColumnName { get; set; }
        public EntitiesAlias? EntityFor { get; set; }
        public EntitiesAlias? ParentEntity { get; set; }
    }
}
