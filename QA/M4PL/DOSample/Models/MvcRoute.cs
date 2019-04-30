using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DOSample.Models
{
    public class MvcRoute
    {
        public MvcRoute()
        {
        }

        public MvcRoute(MvcRoute route)
        {
            Action = route.Action;
            Controller = route.Controller;
            Area = route.Area;
            RecordId = route.RecordId;
            ParentRecordId = route.ParentRecordId;
            IsPopup = route.IsPopup;
            EntityName = route.EntityName;
            Url = route.Url;
            OwnerCbPanel = route.OwnerCbPanel;
        }

        public MvcRoute(string controller, string action, string area)
        {
            Controller = controller;
            Action = action;
            Area = area;
        }

        public MvcRoute(MvcRoute route, long recordId) : this(route)
        {
            RecordId = recordId;
        }

        public MvcRoute(MvcRoute route, string action, long recordId) : this(route)
        {
            RecordId = recordId;
            Action = action;
        }

        public MvcRoute(MvcRoute route, string action) : this(route)
        {
            Action = action;
        }

        /// <summary>
        /// Action Name
        /// </summary>
        public string Action { get; set; }


        /// <summary>
        /// Area if any
        /// </summary>
        public string Area { get; set; }

        public long RecordId { get; set; }

        public long ParentRecordId { get; set; }

        public string EntityName { get; set; }

        public bool IsPopup { get; set; }

        public string Controller { get; set; }

        public string Url { get; set; }

        public string OwnerCbPanel { get; set; }
    }
}