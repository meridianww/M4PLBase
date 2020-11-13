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
// Program Name:                                 SysRefModel
// Purpose:                                      Contains objects related to SysRefModel
//==========================================================================================================

namespace M4PL.Entities
{
    /// <summary>
    /// Base Entity to support multilingual
    /// </summary>
    public class SysRefModel
    {
        /// <summary>
        /// Gets or Sets Record Id
        /// </summary>
        public long Id { get; set; }
        /// <summary>
        /// Gets or Sets Arb Record Id generary used to get Varbinary for the current Entity
        /// </summary>
        public long ArbRecordId { get; set; }
        /// <summary>
        /// Gets or Sets Language e.g. EN for English
        /// </summary>
        public string LangCode { get; set; }
        /// <summary>
        /// Gets or Sets Reference Id e.g. State Id could be a SysRefId for a customer
        /// </summary>
        public int SysRefId { get; set; }
        /// <summary>
        /// Gets or Sets Reference Name e.g. State Name could be a SysRefName for a customer
        /// </summary>
        public string SysRefName { get; set; }
        /// <summary>
        /// Gets or Sets Reference display Name e.g. State Display Name could be a SysRefDisplayName for a customer
        /// </summary>
        public string SysRefDisplayName { get; set; }
        /// <summary>
        /// Gets or Sets Parent ID e.g. ProgramId could be ParentId for a Job
        /// </summary>
        public long ParentId { get; set; }
        /// <summary>
        /// Gets or Sets Organization Id
        /// </summary>
        public long OrganizationId { get; set; }
        /// <summary>
        /// Gets or Sets Role Code e.g. M4PL Admin
        /// </summary>
        public string RoleCode { get; set; }
        /// <summary>
        /// Gets or Sets flag for the current request if the request is for Form View
        /// </summary>
        public bool IsFormView { get; set; }
        /// <summary>
        /// Gets or Sets All Record for a grouping Info 
        /// </summary>
        public object KeyValue { get; set; }
        /// <summary>
        /// Gets or Sets Data Count
        /// </summary>
        public int DataCount { get; set; }
        /// <summary>
        /// Gets or Sets Company Id
        /// </summary>
        public long CompanyId { get; set; }
    }
}