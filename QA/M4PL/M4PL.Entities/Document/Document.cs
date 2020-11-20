#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

namespace M4PL.Entities.Document
{
	/// <summary>
	/// Model class for Document Data
	/// </summary>
	public class DocumentData
	{
		/// <summary>
		/// Gets or Sets Document Name 
		/// </summary>
		public string DocumentName { get; set; }
		/// <summary>
		/// Gets or Sets Document in varbinary format
		/// </summary>
		public byte[] DocumentContent { get; set; }
		/// <summary>
		/// Gets or Sets Document Extension
		/// </summary>
		public string DocumentExtension { get; set; }
		/// <summary>
		/// Gets or Sets document HTML
		/// </summary>
		public string DocumentHtml { get; set; }
		/// <summary>
		/// Gets or Sets Type of Document
		/// </summary>
		public string DocumentType { get; set; }
		/// <summary>
		/// Gets or Sets Content Type
		/// </summary>
		public string ContentType { get; set; }
	}
}