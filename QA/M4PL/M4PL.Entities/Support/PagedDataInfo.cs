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
// Date Programmed:                              10/10/2017
// Program Name:                                 PagedDataInfo
// Purpose:                                      Contains objects related to PagedDataInfo
//==========================================================================================================

using M4PL.Utilities;

namespace M4PL.Entities.Support
{
    /// <summary>
    ///  PagedDataInfo provides page-level containers that can pass data between controllers and views.
    ///  Provides array-like access to page data that is shared between pages, layout pages, and partial pages
    /// </summary>
    public class PagedDataInfo : ICloneable<PagedDataInfo>
    {
        public PagedDataInfo()
        {
            PageId = 1;
            PageNumber = 1;
            PageSize = 5;
        }

        public PagedDataInfo(PagedDataInfo pagedDataInfo)
        {
            RecordId = pagedDataInfo.RecordId;
            ParentId = pagedDataInfo.ParentId;
            PageId = pagedDataInfo.PageId;
            PageNumber = pagedDataInfo.PageNumber;
            PageSize = pagedDataInfo.PageSize;
            OrderBy = pagedDataInfo.OrderBy;
            GroupBy = pagedDataInfo.GroupBy;
            GroupByWhereCondition = pagedDataInfo.GroupByWhereCondition;
            WhereCondition = pagedDataInfo.WhereCondition;
            TotalCount = pagedDataInfo.TotalCount;
            Entity = pagedDataInfo.Entity;
            Contains = pagedDataInfo.Contains;
            TableFields = pagedDataInfo.TableFields;
            IsNext = pagedDataInfo.IsNext;
            IsEnd = pagedDataInfo.IsEnd;
            AvailablePageSizes = pagedDataInfo.AvailablePageSizes;
            IsJobParentEntity = pagedDataInfo.IsJobParentEntity;
            IsJobCardEntity = pagedDataInfo.IsJobCardEntity;
            EntityFor = pagedDataInfo.EntityFor;
        }

        public long RecordId { get; set; }
        public long ParentId { get; set; }
        public int PageId { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public string OrderBy { get; set; }
        public string GroupBy { get; set; }
        public string GroupByWhereCondition { get; set; }
        public string WhereCondition { get; set; }
        public int TotalCount { get; set; }
        public EntitiesAlias? Entity { get; set; }
        public string Contains { get; set; }
        public string TableFields { get; set; }
        public bool IsNext { get; set; }
        public bool IsEnd { get; set; }
        public string AvailablePageSizes { get; set; }
        public bool IsJobParentEntity { get; set; }
        public string Params { get; set; }
        public bool IsLoad { get; set; }
        public Job.JobVOCReportRequest JobVOCReportRequest { get; set; }
        public string WhereLastCondition { get; set; }
        public bool IsJobCardEntity { get; set; }
        public string EntityFor { get; set; }
        public bool IsDataView { get; set; }
        public PagedDataInfo Clone()
        {
            return this.MemberwiseClone() as PagedDataInfo;
        }
    }
}