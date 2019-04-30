/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Janardana
Date Programmed:                              10/10/2017
Program Name:                                 SystemAccount
Purpose:                                      Contains objects related to SystemAccount(OpnSezMe)
==========================================================================================================*/

using System;

namespace M4PL.Entities.Administration
{
    /// <summary>
    /// Validation class to store basic validations for system entities
    /// </summary>
    public class SystemAccount : BaseModel
    {
        /// <summary>
        /// Gets or sets the System account for specified contact
        /// </summary>
        /// <value>
        /// The SysUserContactID.
        /// </value>
        public long? SysUserContactID { get; set; }

        /// <summary>
        /// Gets or sets the System account for specified contact name on grid data display
        /// </summary>
        /// <value>
        /// The SysUserContactIDName.
        /// </value>
        public string SysUserContactIDName { get; set; }

        /// <summary>
        /// Gets or sets the Screen Name for the loggedIn contact on application
        /// </summary>
        /// <value>
        /// The SysScreenName.
        /// </value>
        public string SysScreenName { get; set; }

        /// <summary>
        /// Gets or sets the User Password  for login into application
        /// </summary>
        /// <value>
        /// The SysPassword.
        /// </value>
        //[DataType(DataType.Password)]
        public string SysPassword { get; set; }

        /// <summary>
        /// Gets or sets the SysComments
        /// </summary>
        /// <value>
        /// The SysPassword.
        /// </value>
        public byte[] SysComments { get; set; }

        /// <summary>
        /// Gets or sets the System Account User Organization
        /// </summary>
        /// <value>
        /// The SysOrgId.
        /// </value>
        public long? SysOrgId { get; set; }

        public string SysOrgIdName { get; set; }

        /// <summary>
        /// Gets or sets the System Account User RoleCode LoggedIn User's Organization
        /// </summary>
        /// <value>
        /// The SysOrgRoleCode.
        /// </value>
        public long? SysOrgRefRoleId { get; set; }

        /// <summary>
        /// Gets or sets the System account for specified Role Code  on grid data display
        /// </summary>
        /// <value>
        /// The RoleIdName.
        /// </value>
        public string SysOrgRefRoleIdName { get; set; }

        /// <summary>
        /// Gets or sets the user to SysAdmin
        /// </summary>
        /// <value>
        /// The IsSysAdmin.
        /// </value>
        public bool IsSysAdmin { get; set; }

        /// <summary>
        /// Gets or sets the System Account User's Login attempts Count,
        /// </summary>
        /// <value>
        /// The SysAttempts.
        /// </value>
        public int SysAttempts { get; set; }

        /// <summary>
        /// Gets or sets System Account User is to check for LoggedIn Or Not
        /// </summary>
        /// <value>
        /// The SysLoggedIn.
        /// </value>
        public bool SysLoggedIn { get; set; }

        /// <summary>
        /// Gets or sets the Count of logins For System Account User
        /// </summary>
        /// <value>
        /// The SysLoggedInCount.
        /// </value>
        public int SysLoggedInCount { get; set; }

        /// <summary>
        /// Gets or sets the System Account User Last Attempt
        /// </summary>
        /// <value>
        /// The SysDateLastAttempt.
        /// </value>
        public DateTime? SysDateLastAttempt { get; set; }

        /// <summary>
        /// Gets or sets the System Account User Login Time
        /// </summary>
        /// <value>
        /// The SysLoggedInStart.
        /// </value>
        public DateTime? SysLoggedInStart { get; set; }

        /// <summary>
        /// Gets or sets the System Account User LogOut Time
        /// </summary>
        /// <value>
        /// The SysLoggedInEnd.
        /// </value>
        public DateTime? SysLoggedInEnd { get; set; }

        public bool IsSysAdminPrev{ get; set; }

        public bool UpdateRoles { get; set; }
    }
}