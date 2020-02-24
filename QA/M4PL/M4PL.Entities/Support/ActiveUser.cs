/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ActiveUser
Purpose:                                      Contains objects related to ActiveUser
==========================================================================================================*/

using System;
using System.Collections.Generic;

namespace M4PL.Entities.Support
{
    /// <summary>
    /// Active User class provides the basic and required information about the user accessing the system
    /// </summary>
    public class ActiveUser
    {
        /// <summary>
        /// Gets or sets the user identifier.
        /// </summary>
        /// <value>
        /// The user identifier.
        /// </value>
        public long UserId { get; set; }

        /// <summary>
        /// Gets or sets the user as admin.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>
        public bool IsSysAdmin { get; set; }

        /// <summary>
        /// checks whether the user is authenticated.
        /// </summary>
        /// <value>
        /// The IsAuthenticated.
        /// </value>
        public bool IsAuthenticated { get; set; }

        /// <summary>
        /// Gets or sets the user name.
        /// </summary>
        /// <value>
        /// The identifier.
        /// </value>
        public string UserName { get; set; }

        /// <summary>
        /// Gets or sets the contact identifier.
        /// </summary>
        /// <value>
        /// The  contact identifier.
        /// </value>
        public long ContactId { get; set; }

        /// <summary>
        /// Gets or sets the ERP identifier.
        /// </summary>
        /// <value>
        /// The ERP identifier.
        /// </value>
        public string ERPId { get; set; }

        /// <summary>
        /// Gets or sets the outlook identifier.
        /// </summary>
        /// <value>
        /// The outlook identifier.
        /// </value>
        public string OutlookId { get; set; }

        /// <summary>
        /// Gets or sets the lang type identifier.
        /// </summary>
        /// <value>
        /// The LangCode.
        /// </value>
        public string LangCode { get; set; }

        /// <summary>
        /// Gets or sets the auth token.
        /// </summary>
        /// <value>
        /// The AuthToken.
        /// </value>
        public string AuthToken { get; set; }

        /// <summary>
        /// Gets or sets the organization identifier.
        /// </summary>
        /// <value>
        /// The organization identifier.
        /// </value>
        public long OrganizationId { get; set; }


        /// <summary>
        /// Gets or sets the organization Code.
        /// </summary>
        /// <value>
        /// The OrganizationCode.
        /// </value>
        public string OrganizationCode { get; set; }


        /// <summary>
        /// Gets or sets the organization name.
        /// </summary>
        /// <value>
        /// The OrganizationName.
        /// </value>
        public string OrganizationName { get; set; }

        /// <summary>
        /// Gets or sets the current organization image.
        /// </summary>
        /// <value>
        /// The OrganizationImage.
        /// </value>
        public byte[] OrganizationImage { get; set; }

        /// <summary>
        /// Gets or sets the role Id.
        /// </summary>
        /// <value>
        /// The roleId.
        /// </value>
        public long RoleId { get; set; }

        /// <summary>
        /// Gets or sets the role type.
        /// </summary>
        /// <value>
        /// The rolecode.
        /// </value>
        public string RoleCode { get; set; }

		/// <summary>
		/// Gets or sets the last acccess datetime.
		/// </summary>
		/// <value>
		/// The LastAccessDateTime.
		/// </value>
		public DateTime LastAccessDateTime { get; set; }

        /// <summary>
        ///  Gets or sets the SysSetting
        /// </summary>
        /// <value>
        /// The SysSetting.
        /// </value>

        /// <summary>
        /// Gets or sets the role of the user.
        /// </summary>
        /// <value>
        /// The Roles.
        /// </value>
        public IList<Role> Roles { get; set; }

        public string SystemMessage { get; set; }

        /// <summary>
        /// Maintain the last route for refresh the page.
        /// </summary>
        public MvcRoute LastRoute { get; set; }

        /// <summary>
        /// Maintain the RecordId and EntityAlias for Paste Record purpose 
        /// </summary>
        public MvcRoute CopiedRecord { get; set; }

		/// <summary>
		/// Maintain the Current route for refresh the page.
		/// </summary>
		public MvcRoute CurrentRoute { get; set; }

        /// <summary>
		/// Maintain the Report route for refresh the page.
		/// </summary>
		public MvcRoute ReportRoute { get; set; }
    }
}