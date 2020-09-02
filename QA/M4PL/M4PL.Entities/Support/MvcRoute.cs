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
// Program Name:                                 MvcRoute
// Purpose:                                      Contains objects related to MvcRoute
//==========================================================================================================

using System.Collections.Generic;

namespace M4PL.Entities.Support
{
    /// <summary>
    /// MVC Route class defines the URL Pattern and handler information, maps the user's request to the respective Controller and Action method
    /// </summary>
    public class MvcRoute
    {
        public MvcRoute()
        {
        }

        public MvcRoute(MvcRoute route)
        {
            if (route != null)
            {
                Action = route.Action;
                Entity = route.Entity;
                Area = route.Area;
                RecordId = route.RecordId;
                ParentRecordId = route.ParentRecordId;
                Filters = route.Filters;
                IsPopup = route.IsPopup;
                EntityName = route.EntityName;
                Url = route.Url;
                OwnerCbPanel = route.OwnerCbPanel;
                ParentEntity = route.ParentEntity;
                TabIndex = route.TabIndex;
                PreviousRecordId = route.PreviousRecordId;
                CompanyId = route.CompanyId;
                IsPBSReport = route.IsPBSReport;
                IsJobParentEntityUpdated = route.IsJobParentEntityUpdated;
            }
        }

        public MvcRoute(EntitiesAlias entity, string action, string area)
        {
            Entity = entity;
            Action = action;
            Area = area;
        }

        public MvcRoute(MvcRoute route, long recordId) : this(route)
        {
            RecordId = recordId;
            IsJobParentEntityUpdated = route.IsJobParentEntityUpdated;
        }

        public MvcRoute(MvcRoute route, string action, long recordId) : this(route)
        {
            RecordId = recordId;
            Action = action;
            IsJobParentEntityUpdated = route.IsJobParentEntityUpdated;
        }

        public MvcRoute(MvcRoute route, string action, long recordId, long recordIdToCopy, string ownerCbPanel) : this(route)
        {
            RecordId = recordId;
            Action = action;
            RecordIdToCopy = recordIdToCopy;
            OwnerCbPanel = ownerCbPanel;
            IsJobParentEntityUpdated = route.IsJobParentEntityUpdated;
        }

        public MvcRoute(MvcRoute route, string action) : this(route)
        {
            Action = action;
            Location = route.Location;
            StartDate = route.StartDate;
            EndDate = route.EndDate;
            IsPBSReport = route.IsPBSReport;
            IsEdit = route.IsEdit;
            IsJobParentEntityUpdated = route.IsJobParentEntityUpdated;
            JobIds = route.JobIds;
        }

        public MvcRoute(MvcRoute route, string action, long? companyId) : this(route)
        {
            Action = action;
            CompanyId = companyId;
            IsJobParentEntityUpdated = route.IsJobParentEntityUpdated;
        }

        /// <summary>
        /// Action Name
        /// </summary>
        public string Action { get; set; }

        /// <summary>
        /// Entity Name
        /// </summary>
        public EntitiesAlias Entity { get; set; }
        /// <summary>
        /// Area if any
        /// </summary>
        public string Area { get; set; }
        public long RecordId { get; set; }
        public long? PreviousRecordId { get; set; }
        public long ParentRecordId { get; set; }
        public string EntityName { get; set; }
        public Filter Filters { get; set; }
        public bool IsPopup { get; set; }
        public string Controller { get { return Entity.ToString(); } }
        public string Url { get; set; }
        public EntitiesAlias ParentEntity { get; set; }
        public string OwnerCbPanel { get; set; }
        public int TabIndex { get; set; }
        public long RecordIdToCopy { get; set; }
        public long? CompanyId { get; set; }
        public List<string> Location { get; set; }
        public List<string> JobIds { get; set; }
        public System.DateTime? StartDate { get; set; }
        public System.DateTime? EndDate { get; set; }
        public bool IsPBSReport { get; set; }
        public bool IsEdit { get; set; }
        public bool IsJobParentEntityUpdated { get; set; }
    }
}
