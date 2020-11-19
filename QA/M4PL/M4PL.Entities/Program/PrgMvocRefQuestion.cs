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
// Program Name:                                 PrgMvocRefQuestion
// Purpose:                                      Contains objects related to PrgMvocRefQuestion
//==========================================================================================================

namespace M4PL.Entities.Program
{
	/// <summary>
	///
	/// </summary>
	public class PrgMvocRefQuestion : BaseModel
	{
		/// <summary>
		/// Gets or sets the identifier.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public long? MVOCID { get; set; }
		/// <summary>
		/// Gets or Sets VOC Name
		/// </summary>
		public string MVOCIDName { get; set; }

		/// <summary>
		/// Gets or sets the Survey Question Number.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? QueQuestionNumber { get; set; }

		/// <summary>
		/// Gets or sets the Question code
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string QueCode { get; set; }

		/// <summary>
		/// Gets or sets the Survey Question Title
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public string QueTitle { get; set; }

		/// <summary>
		/// Gets or sets the Description
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public byte[] QueDescription { get; set; }

		/// <summary>
		/// Gets or sets the Question Type Id
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? QuesTypeId { get; set; }

		/// <summary>
		/// Gets or sets the Flag for answer as Yes or No
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public bool QueType_YNAnswer { get; set; }

		/// <summary>
		/// Gets or sets the default flag  for answer as Yes or No
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public bool QueType_YNDefault { get; set; }

		/// <summary>
		/// Gets or sets the lowest range for a Question.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? QueType_RangeLo { get; set; }

		/// <summary>
		/// Gets or sets the Highest Range for a Question.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? QueType_RangeHi { get; set; }

		/// <summary>
		/// Gets or sets the Range of Answer.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? QueType_RangeAnswer { get; set; }

		/// <summary>
		/// Gets or sets the Default range.
		/// </summary>
		/// <value>
		/// The identifier.
		/// </value>
		public int? QueType_RangeDefault { get; set; }

		/// <summary>
		/// Gets Or Sets QueDescriptionText
		/// </summary>
		public string QueDescriptionText { get; set; }
	}
}