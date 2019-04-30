﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 SessionInfo
Purpose:                                      Contains objects related to SessionInfo
==========================================================================================================*/
using System.Collections.Generic;

namespace M4PL.Entities.Support
{
    public class SessionInfo
    {
        public EntitiesAlias Entity { get; set; }
        public bool ToggleFilter { get; set; }
        public bool PreviousToggleFilter { get; set; }
        public bool AdvanceFilter { get; set; }
        public Dictionary<string, string> Filters { get; set; }
        public object GridViewFilteringState { get; set; }
        public object GridViewColumnState { get; set; }
        public bool GridViewColumnStateReset { get; set; }
        public object GridViewColumnGroupingState { get; set; }
        public PagedDataInfo PagedDataInfo { get; set; }
        public List<long> RecordIds { get; set; }
        public bool IsCut { get; set; }
        public string CurrentLayout { get; set; }
        public string OpenedTabs { get; set; }
    }
}