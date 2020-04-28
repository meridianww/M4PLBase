/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 Login
Purpose:                                      Contains objects related to Login
==========================================================================================================*/

using System.ComponentModel.DataAnnotations;

namespace M4PL.Entities.Support
{
    /// <summary>
    /// Login class is the gateway for the system and performs authenication and authorization based on the credential supplied
    /// Prevents unauthorized access
    /// </summary>
    public class Login
    {
        /// <summary>
        /// Gets or sets the username.
        /// </summary>
        /// <value>The username.</value>
        public string Username { get; set; }

        /// <summary>
        /// Gets or sets the password.
        /// </summary>
        /// <value>The password.</value>
        [DataType(DataType.Password)]
        public string Password { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [remember me].
        /// </summary>
        /// <value><c>true</c> if [remember me]; otherwise, <c>false</c>.</value>
        public bool RememberMe { get; set; }

        /// <summary>
        /// Gets or sets the client identifier.
        /// </summary>
        /// <value>
        /// The client identifier.
        /// </value>
        public string ClientId { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [force login].
        /// </summary>
        /// <value>
        ///   <c>true</c> if [force login]; otherwise, <c>false</c>.
        /// </value>
        public bool ForceLogin { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether [switch organization].
        /// </summary>
        /// <value>
        ///   <c>true</c> if [SwitchedOrganizationId> 0]; otherwise, <c>false</c>.
        /// </value>
        public long OrganizationId { get; set; }


        public long JobId { get; set; }
    }
}