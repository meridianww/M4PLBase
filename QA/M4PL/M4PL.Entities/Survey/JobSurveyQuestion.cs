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
// Program Name:                                 JobSurveyQuestion
// Purpose:                                      Contains model for JobSurveyQuestion
//=============================================================================================================

namespace M4PL.Entities.Survey
{
    /// <summary>
    /// Model Class for Job Survey Question
    /// </summary>
    public class JobSurveyQuestion
    {
        /// <summary>
        /// Gets or Sets Question Id
        /// </summary>
        public long QuestionId { get; set; }
        /// <summary>
        /// Gets or Sets Question Number
        /// </summary>
        public int QuestionNumber { get; set; }
        /// <summary>
        /// Gets or Sets Title
        /// </summary>
        public string Title { get; set; }
        /// <summary>
        /// Gets or Sets Question Description
        /// </summary>
        public string QuestionDescription { get; set; }
        /// <summary>
        /// Gets or Sets Question TypeId
        /// </summary>
        public int QuestionTypeId { get; set; }
        /// <summary>
        /// Gets or Sets Question TypeId Name
        /// </summary>
        public string QuestionTypeIdName { get; set; }
        /// <summary>
        /// Gets or Sets Start Range
        /// </summary>
        public int StartRange { get; set; }
        /// <summary>
        /// Gets or Sets End Range
        /// </summary>
        public int EndRange { get; set; }
        /// <summary>
        /// Gets or Sets Agree Text
        /// </summary>
        public string AgreeText { get; set; }
        /// <summary>
        /// Gets or Sets Agree TextId
        /// </summary>
        public int AgreeTextId { get; set; }
        /// <summary>
        /// Gets or Sets DisAgree Text
        /// </summary>
        public string DisAgreeText { get; set; }
        /// <summary>
        /// Gets or Sets DisAgree TextId
        /// </summary>
        public int DisAgreeTextId { get; set; }
        /// <summary>
        /// Gets or Sets Selected Answer
        /// </summary>
        public string SelectedAnswer { get; set; }

    }
}
