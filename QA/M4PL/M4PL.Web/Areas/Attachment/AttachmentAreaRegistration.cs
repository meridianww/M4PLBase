#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 AttachmentAreaRegistration
//Purpose:                                      Contains route related to AttachmentArea
//====================================================================================================================================================*/
using System.Web.Mvc;

namespace M4PL.Web.Areas.Attachment
{
	public class AttachmentAreaRegistration : AreaRegistration
	{
		public override string AreaName
		{
			get
			{
				return "Attachment";
			}
		}

		public override void RegisterArea(AreaRegistrationContext context)
		{
			context.MapRoute(
				"Attachment_default",
				"Attachment/{controller}/{action}/{id}",
				new { action = "Index", id = UrlParameter.Optional }
			);
		}
	}
}