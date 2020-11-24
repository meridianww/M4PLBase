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
// Program Name:                                 ConditionalOperator
// Purpose:                                      Contains objects related to ConditionalOperator
//==========================================================================================================
namespace M4PL.Entities.Support
{
	/// <summary>
	/// Model class for Conditional Operator
	/// </summary>
	public class ConditionalOperator
	{
		/// <summary>
		/// Gets or Sets Relational Operator as enum e.g. 0 for AND, 1 for OR etc
		/// </summary>
		public RelationalOperator Operator { get; set; }
		/// <summary>
		/// Gets or Sets Systerm Reference Name e.g. == for equals to
		/// </summary>
		public string SysRefName { get; set; }
		/// <summary>
		/// Gets or Sets Language Name e.g. EN for English 
		/// </summary>
		public string LangName { get; set; }
		/// <summary>
		/// Gets or Sets Flag if Is Default
		/// </summary>
		public bool IsDefault { get; set; }
	}
}