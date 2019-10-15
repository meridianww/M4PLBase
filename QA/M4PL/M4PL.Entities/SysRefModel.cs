/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 SysRefModel
Purpose:                                      Contains objects related to SysRefModel
==========================================================================================================*/

using System;

namespace M4PL.Entities
{
    /// <summary>
    /// Base Entity to support multilingual
    /// </summary>
    public class SysRefModel
    {
        public long Id { get; set; }
        public long ArbRecordId { get; set; }
        public string LangCode { get; set; }
        public int SysRefId { get; set; }
        public string SysRefName { get; set; }
        public string SysRefDisplayName { get; set; }
        public long ParentId { get; set; }
        public long OrganizationId { get; set; }
        public string RoleCode { get; set; }
        public bool IsFormView { get; set; }
        public object KeyValue { get; set; }
        public int DataCount { get; set; }
        public long CompanyId { get; set; }
	}
}