using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using M4PL.Entities.Support;

namespace M4PL.Entities.Job
{
    public class JobCardTemplate  : BaseModel
    {
        public long CustomerId { get; set; }
        public string CustCode { get; set; }

        public string Name { get; set; }
        public long Count { get; set; }

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
                    cancelRoute.Location = Name;
                    return string.Format("function(s, form, strRoute){{ M4PLWindow.FormView.OnCancel(s,  {0}, \'{1}\');}}", FormId, Newtonsoft.Json.JsonConvert.SerializeObject(cancelRoute));
                }

                return _cancelClick;
            }
            set { _cancelClick = value; }
        }


        //#region Get the data from Sp
        //public string CustTitle { get; set; }
        //public DateTime? JobOrderedDate { get; set; }
        //public string JobBOL { get; set; }
        //public DateTime? JobOriginDateTimePlanned { get; set; }
        //public DateTime? JobDeliveryDateTimePlanned { get; set; }
        ////public int StatusId { get; set; }
        //public string JobGatewayStatus { get; set; }
        //public string JobDeliverySiteName { get; set; }
        //public string JobCustomerSalesOrder { get; set; }
        //public string JobManifestNo { get; set; }
        //public string PlantIDCode { get; set; }
        //public string JobSellerSiteName { get; set; }
        //public string JobDeliveryStreetAddress { get; set; }
        //public string JobDeliveryStreetAddress2 { get; set; }
        //public string JobDeliveryCity { get; set; }
        //public string JobDeliveryState { get; set; }
        //public string JobDeliveryPostalCode { get; set; }
        //public string JobDeliverySitePOC { get; set; }
        //public string JobDeliverySitePOCPhone { get; set; }
        //public string JobDeliverySitePOCPhone2 { get; set; }
        //public string JobSellerSitePOCEmail { get; set; }
        //public string JobServiceMode { get; set; }
        //public DateTime? JobOriginDateTimeActual { get; set; }
        //public DateTime? JobDeliveryDateTimeActual { get; set; }
        //public string JobCustomerPurchaseOrder { get; set; }
        //public decimal? JobTotalCubes { get; set; }
        //public decimal? TotalParts { get; set; }
        //public string JobNotes { get; set; }
        //public string JobCarrierContract { get; set; }
        //public decimal? TotalQuantity { get; set; }
        //public string JobSiteCode { get; set; }
        //#endregion
    }
}
