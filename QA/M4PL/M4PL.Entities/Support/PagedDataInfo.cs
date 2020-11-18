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
    ///  Gets or Sets Page Level Information and generally used as request params for Data Grids
    /// </summary>
    public class PagedDataInfo : ICloneable<PagedDataInfo>
    {
        /// <summary>
        /// Default constructor
        /// </summary>
        public PagedDataInfo()
        {
            PageId = 1;
            PageNumber = 1;
            PageSize = 5;
        }
        /// <summary>
        /// Sets current instance to newly created instance
        /// </summary>
        /// <param name="pagedDataInfo"></param>
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
            JobCardFilterId = pagedDataInfo.JobCardFilterId;
        }
        /// <summary>
        /// Gets or Sets RecordId for a request e.g. JobId or GatewayId
        /// </summary>
        public long RecordId { get; set; }
        /// <summary>
        /// Gets or Sets ParentId for a request e.g. ProgramId or JobId
        /// </summary>
        public long ParentId { get; set; }
        /// <summary>
        /// Gets or Sets PageId of the current Grid or Page(default is set as 1)
        /// </summary>
        public int PageId { get; set; }
        /// <summary>
        /// Gets or Sets PageNumber for the current Grid or Page(default is set as 1)
        /// </summary>
        public int PageNumber { get; set; }
        /// <summary>
        /// Gets or Sets PageSize for the current Grid or Page(default is set as 5)
        /// </summary>
        public int PageSize { get; set; }
        /// <summary>
        /// Gets or Sets Sorting OrderBy columns for the current Grid e.g. if sorting by Job Id in JobAdvanceReport then OrderBy value would be JobAdvanceReport.Id ASC/DESC
        /// </summary>
        public string OrderBy { get; set; }
        /// <summary>
        /// Gets or Sets Grouping columns for the current Grid (for group by clause in SQL) e.g. JobAdvanceReport.Id
        /// </summary>
        public string GroupBy { get; set; }
        /// <summary>
        /// Gets or Sets filtering(WhereCondition) condition for a GroupBy clause e.g. AND JOBDL000Master.JobGatewayStatus = 'In Transit'
        /// </summary>
        public string GroupByWhereCondition { get; set; }
        /// <summary>
        /// Gets or Sets filtering(WhereCondition) for current Grid e.g. AND JOBDL000Master.JobGatewayStatus = 'In Transit'
        /// </summary>
        public string WhereCondition { get; set; }
        /// <summary>
        /// Output param generally used to set pagination of current Grid 
        /// </summary>
        public int TotalCount { get; set; }
        /// <summary>
        /// (Enum)Gets or Sets current Entity for the request e.g. 5 for Account or 45 for Vendor or 80 for Job 
        /// </summary>
        public EntitiesAlias? Entity { get; set; }
        /// <summary>
        /// Gets or Sets keys/ids for the current request e.g. list of comma seperated ContactIds to be removed from Vendors
        /// </summary>
        public string Contains { get; set; }
        /// <summary>
        /// Gets or Sets Table fields to be selected for a request
        /// </summary>
        public string TableFields { get; set; }
        /// <summary>
        /// Used for Pagination control  e.g. false(for "is next page")
        /// </summary>
        public bool IsNext { get; set; }
        /// <summary>
        /// Used for Pagination control  e.g. false(for "is Last page")
        /// </summary>
        public bool IsEnd { get; set; }
        /// <summary>
        /// Gets or sets AvailablePageSizes for the current Grid or page e.g. "30,50,100"
        /// </summary>
        public string AvailablePageSizes { get; set; }
        /// <summary>
        /// Gets or Sets flag to check if the Job is Parent Entity for current request e.g. For JobAdvanceReport Job must be Prent so the flag would be true
        /// </summary>
        public bool IsJobParentEntity { get; set; }
        /// <summary>
        /// Gets or Sets Parameters for a current request e.g. for Job Card value might be "DashboardCategoryName='NotScheduled'  AND DashboardSubCategoryName = 'Returns'"
        /// </summary>
        public string Params { get; set; }
        /// <summary>
        /// Gets or Sets flag for the current request if the current entity already availavle in Session Provider
        /// </summary>
        public bool IsLoad { get; set; }
        /// <summary>
        /// Gets or Sets Request Params for VOC Report
        /// </summary>
        public Job.JobVOCReportRequest JobVOCReportRequest { get; set; }
        /// <summary>
        /// Gets or Sets filtering condition to be added in the last/end of WhereCondition
        /// </summary>
        public string WhereLastCondition { get; set; }
        /// <summary>
        /// Gets or Sets flag for if the current entity is Job Card
        /// </summary>
        public bool IsJobCardEntity { get; set; }
        /// <summary>
        /// Gets or Sets for current Entity e.g. Customer or Job etc.
        /// </summary>
        public string EntityFor { get; set; }
        /// <summary>
        /// Gets or Sets flag if the current request for Data Grid
        /// </summary>
        public bool IsDataView { get; set; }
        /// <summary>
        /// Gets or Sets Dashboard Category Relation Id for JobCard Entity e.g. 1 for Not Scheduled/In Transit, 2 for Not Scheduled/On Hand etc.
        /// </summary>
        public long JobCardFilterId { get; set; }
        /// <summary>
        /// Gets or Sets flag for the current request for Export or not e.g true if clicked on Export false if request if for Data Grid
        /// </summary>
        public bool IsExport { get; set; }
        public PagedDataInfo Clone()
        {
            return this.MemberwiseClone() as PagedDataInfo;
        }
    }
}