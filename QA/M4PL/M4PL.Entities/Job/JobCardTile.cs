using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities.Support;

namespace M4PL.Entities.Job
{
    public class JobCardTile  : BaseModel
    {
        public long CustomerId { get; set; }
        public string CustCode { get; set; }

        public string Name { get; set; }
        public long CardCount { get; set; }
        public string CardType { get; set; }
        public MvcRoute CardRoute { get; set; }

        private string _formId;
        private string _cancelClick;
        public string FormId
        {
            get
            {
                if (string.IsNullOrEmpty(_formId))
                    return  "CardView";//This formName dependent on _NavigationPanePartial's 'SaveRecordPopup' ItemClick Method.
                return _formId;
            }
            set { _formId = value; }
        }
        public string CancelClick
        {
            get
            {
                if (string.IsNullOrEmpty(_cancelClick))
                {                    
                    var cancelRoute = new MvcRoute(EntitiesAlias.JobCard, "DataView", "Job");
                    cancelRoute.OwnerCbPanel = "AppCbPanel";
                    cancelRoute.EntityName ="JobCard";
                    cancelRoute.Url = string.Empty;
                    cancelRoute.Location = CardType +','+ Name;
                    return string.Format("function(s, form, strRoute){{ M4PLWindow.FormView.OnCancel(s,  {0}, \'{1}\');}}", FormId, Newtonsoft.Json.JsonConvert.SerializeObject(cancelRoute));
                }

                return _cancelClick;
            }
            set { _cancelClick = value; }
        }
    }
}
