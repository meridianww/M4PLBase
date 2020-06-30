/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kirty Anurag
Date Programmed:                              10/10/2017
Program Name:                                 SystemReference
Purpose:                                      Contains objects related to SystemReference
==========================================================================================================*/

using System;

namespace M4PL.Entities.Administration
{
    /// <summary>
    /// System Reference class to create and maintain modules in the system
    /// </summary>
    public class SystemReference
    {
        public int Id { get; set; }

        public string LangCode { get; set; }

        /// <summary>
        /// Gets or sets the LookupId
        /// </summary>
        /// <value>
        /// The LookupId.
        /// </value>
        public int SysLookupId { get; set; }

        public string SysLookupCode { get; set; }

        /// <summary>
        /// Gets or sets the system option name.
        /// </summary>
        /// <value>
        /// The SysOptionName.
        /// </value>
        public string SysOptionName { get; set; }

        /// <summary>
        /// Gets or sets the system sorting order.
        /// </summary>
        /// <value>
        /// The SysSortOrder.
        /// </value>
        public int SysSortOrder { get; set; }

        /// <summary>
        ///Gets or sets the module as default..
        /// </summary>
        /// <value>
        /// The SysDefault.
        /// </value>
        public bool SysDefault { get; set; }

        /// <summary>
        /// Gets or sets the column's status.
        /// </summary>
        /// <value>
        /// The Column Status.
        /// </value>
        public bool IsSysAdmin { get; set; }

        public int? StatusId { get; set; }

        public DateTime DateEntered { get; set; }

        public DateTime? DateChanged { get; set; }

        public string EnteredBy { get; set; }

        public string ChangedBy { get; set; }

        public bool IsFormView { get; set; }
    }
}