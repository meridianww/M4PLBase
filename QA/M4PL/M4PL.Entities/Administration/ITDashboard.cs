using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.Administration
{
    public class ITDashboard : BaseModel
    {
        public long DashboardCategoryRelationId { get; set; }
        public long RecordCount { get; set; }
        public string DashboardName { get; set; }
        public string DashboardCategoryDisplayName { get; set; }
        public string DashboardSubCategoryDisplayName { get; set; }
        public string BackGroundColor { get; set; }
        public string FontColor { get; set; }
        public string DashboardCategoryName { get; set; }
        public string DashboardSubCategoryName { get; set; }
        public int SortOrder { get; set; }
        public string Name { get; set; }
        public long CardCount { get; set; }
        public string CardType { get; set; }
        public string CardBackgroupColor { get; set; }
        public MvcRoute CardRoute { get; set; }
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
                    var cancelRoute = new MvcRoute(EntitiesAlias.ITDashboard, "DataView", "Administration");
                    cancelRoute.OwnerCbPanel = "AppCbPanel";
                    cancelRoute.EntityName = "ITDashboard";
                    cancelRoute.Url = string.Empty;
                    return string.Format("function(s, form, strRoute){{ M4PLWindow.FormView.OnCancel(s,  {0}, \'{1}\');}}", FormId, Newtonsoft.Json.JsonConvert.SerializeObject(cancelRoute));
                }

                return _cancelClick;
            }
            set { _cancelClick = value; }
        }
    }
}
