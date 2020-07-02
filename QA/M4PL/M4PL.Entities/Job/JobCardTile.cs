#region Copyright

/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/

#endregion Copyright

using M4PL.Entities.Support;

namespace M4PL.Entities.Job
{
	public class JobCardTile : BaseReportModel
	{
		public JobCardTile()
		{
		}

		public JobCardTile(BaseReportModel baseReportModel) : base(baseReportModel)
		{
		}

		public long CustomerId { get; set; }

		//public long Id { get; set; }
		public string BackGroundColor { get; set; }

		public string FontColor { get; set; }

		public string Name { get; set; }
		public long CardCount { get; set; }
		public string CardType { get; set; }
		public string CardBackgroupColor { get; set; }
		public MvcRoute CardRoute { get; set; }

		public string DashboardCategoryName { get; set; }
		public string DashboardSubCategoryName { get; set; }

		private string _formId;
		private string _cancelClick;

		public string FormId
		{
			get
			{
				if (string.IsNullOrEmpty(_formId))
					return "CardView";//This formName dependent on _NavigationPanePartial's 'SaveRecordPopup' ItemClick Method.
				return _formId;
			}
			set { _formId = value; }
		}

		public string CancelClick
		{
			get
			{
				if (string.IsNullOrEmpty(_cancelClick) && CardCount > 0)
				{
					var cancelRoute = new MvcRoute(EntitiesAlias.JobCard, "DataView", "Job");
					cancelRoute.OwnerCbPanel = "AppCbPanel";
					cancelRoute.EntityName = "JobCard";
					cancelRoute.Url = string.Empty;
					return string.Format("function(s, form, strRoute){{ M4PLWindow.FormView.OnCancel(s,  {0}, \'{1}\');}}", FormId, Newtonsoft.Json.JsonConvert.SerializeObject(cancelRoute));
				}

				return _cancelClick;
			}
			set { _cancelClick = value; }
		}
	}
}