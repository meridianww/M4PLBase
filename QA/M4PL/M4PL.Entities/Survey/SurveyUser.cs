#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Prashant Aggarwal
// Date Programmed:                              09/11/2019
// Program Name:                                 JobSurvey
// Purpose:                                      Contains model for SurveyUser
//=============================================================================================================

namespace M4PL.Entities.Survey
{
    /// <summary>
    /// Model for Survey Users
    /// </summary>
    public class SurveyUser
    {
        /// <summary>
        /// Gets or Sets Id for Survey User Table ([dbo].[SVYUSER000Master])
        /// </summary>
        public long Id { get; set; }
        /// <summary>
        /// Gets or Sets Survey User's Name
        /// </summary>
        public string Name { get; set; }
        /// <summary>
        /// Gets or Sets Age of Survey User
        /// </summary>
        public int? Age { get; set; }
        /// <summary>
        /// Gets or Sets GenderID of Survey User
        /// </summary>
        public int? GenderId { get; set; }
        /// <summary>
        /// Gets or Sets Entity Type Identifier e.g. JobNo for VOC
        /// </summary>
        public string EntityTypeId { get; set; }
        /// <summary>
        /// Gets or Sets Entity Type e.g. Job
        /// </summary>
        public string EntityType { get; set; }
        /// <summary>
        /// Gets or Sets User Id
        /// </summary>
        public long? UserId { get; set; }
        /// <summary>
        /// Gets or Sets Id of Survey e.g. VOC Id
        /// </summary>
        public long? SurveyId { get; set; }
        /// <summary>
        /// Gets or Sets Feedback
        /// </summary>
        public string Feedback { get; set; }
        /// <summary>
        /// Gets or Sets COntact #
        /// </summary>
        public string Contract { get; set; }
        /// <summary>
        /// Gets or Sets Location
        /// </summary>
        public string Location { get; set; }
        /// <summary>
        /// Gets or Sets Delivered details
        /// </summary>
        public string Delivered { get; set; }
        /// <summary>
        /// Gets or Sets Driver's Number
        /// </summary>
        public string DriverNo { get; set; }
        /// <summary>
        /// Gets or Sets Driver Details
        /// </summary>
        public string Driver { get; set; }
        /// <summary>
        /// Gets or Sets Customer's Name
        /// </summary>
        public string CustName { get; set; }
    }
}
