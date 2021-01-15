using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace M4PL.Entities.JobService
{
    /// <summary>
    /// Model class for Job/Order Details
    /// </summary>
    public class OrderDetails
    {
        /// <summary>
        /// default constructor
        /// </summary>
        public OrderDetails()
        {
            OrderGatewayDetails = new List<OrderGatewayDetails>();
            //OrderDocumentDetails = new List<OrderDocumentDetails>();
        }
        /// <summary>
        /// Gets or Sets Job Id
        /// </summary>
        public long Id { get; set; }
        /// <summary>
        /// Gets or Sets Customer Number
        /// </summary>
        public string CustomerSalesOrder { get; set; }
        /// <summary>
        /// Gets or Sets Current Gateway Status
        /// </summary>
        public string GatewayStatus { get; set; }
        /// <summary>
        /// Gets or Sets Delivery Date Planned
        /// </summary>
        public DateTime? DeliveryDatePlanned { get; set; }
        /// <summary>
        /// Gets or Sets Arrival Date Planned
        /// </summary>
        public DateTime? ArrivalDatePlanned { get; set; }
        /// <summary>
        /// Gets or Sets Job Delivery DateTime Actual
        /// </summary>
        public DateTime? JobDeliveryDateTimeActual { get; set; }
        /// <summary>
        /// Gets or Sets BOL Number
        /// </summary>
        public string BOL { get; set; }
        /// <summary>
        /// Gets or Sets Manifest No
        /// </summary>
        public string ManifestNo { get; set; }
        /// <summary>
        /// Gets or Sets Order Date
        /// </summary>
        public DateTime? OrderDate { get; set; }
        /// <summary>
        /// Gets or Sets Shipment Date
        /// </summary>
        public DateTime? ShipmentDate { get; set; }
        /// <summary>
        /// Gets or Sets Job Delivery Date Time Base line Date
        /// </summary>
        public DateTime? JobDeliveryDateTimeBaseline { get; set; }
        /// <summary>
        /// Gets or Sets Customer Id
        /// </summary>
        public long? CustomerId { get; set; }
        /// <summary>
        /// Gets or Sets Customer Code
        /// </summary>
        public string CustomerCode { get; set; }
        /// <summary>
        /// Gets or Sets Order Type
        /// </summary>
        public string GwyOrderType { get; set; }
        /// <summary>
        /// Gets or Sets Shipment Type
        /// </summary>
        public string GwyShipmentType { get; set; }
        /// <summary>
        /// Gets or Sets permission flag for Job
        /// </summary>
        public bool IsJobPermission { get; set; }
        /// <summary>
		/// Gets or sets the job delivery site poc for job delivery.
		/// </summary>
		/// <value>
		/// The JobDeliverySitePOC.
		/// </value>
		public string JobDeliverySitePOC { get; set; }

        /// <summary>
        /// Gets or sets the .
        /// </summary>
        /// <value>
        /// The JobDeliverySitePOCPhone for job delivery.
        /// </value>
        public string JobDeliverySitePOCPhone { get; set; }

        /// <summary>
        /// Gets or sets the job delivery poc email for job delivery.
        /// </summary>
        /// <value>
        /// The JobDeliverySitePOCEmail.
        /// </value>
        public string JobDeliverySitePOCEmail { get; set; }

        /// <summary>
        /// Gets or sets the .
        /// </summary>
        /// <value>
        /// The JobDeliverySiteName.
        /// </value>
        public string JobDeliverySiteName { get; set; }

        /// <summary>
        /// Gets or sets  job delivery the street address for job delivery.
        /// </summary>
        /// <value>
        /// The JobDeliveryStreetAddress.
        /// </value>
        public string JobDeliveryStreetAddress { get; set; }

        /// <summary>
        /// Gets or sets the identifier street address2 for job delivery.
        /// </summary>
        /// <value>
        /// The JobDeliveryStreetAddress2.
        /// </value>
        public string JobDeliveryStreetAddress2 { get; set; }


        /// <summary>
        /// Gets or sets the identifier street address3 for job delivery.
        /// </summary>
        /// <value>
        /// The JobDeliveryStreetAddress3.
        /// </value>
        public string JobDeliveryStreetAddress3 { get; set; }

        /// <summary>
        /// Gets or sets the identifier street address4 for job delivery.
        /// </summary>
        /// <value>
        /// The JobDeliveryStreetAddress4.
        /// </value>
        public string JobDeliveryStreetAddress4 { get; set; }

        /// <summary>
        /// Gets or sets the delivery city for job delivery.
        /// </summary>
        /// <value>
        /// The JobDeliveryCity.
        /// </value>
        public string JobDeliveryCity { get; set; }

        /// <summary>
        /// Gets or sets the state province fo job delivery.
        /// </summary>
        /// <value>
        /// The JobDeliveryStateProvince.
        /// </value>
        public string JobDeliveryState { get; set; }

        /// <summary>
        /// Gets or sets the postal code for job delivery.
        /// </summary>
        /// <value>
        /// The JobDeliveryPostalCode.
        /// </value>
        public string JobDeliveryPostalCode { get; set; }

        /// <summary>
        /// Gets or sets the delivery country.
        /// </summary>
        /// <value>
        /// The JobDeliveryCountry.
        /// </value>
        public string JobDeliveryCountry { get; set; }

        /// <summary>
		/// Gets or sets the origin site Poc.
		/// </summary>
		/// <value>
		/// The JobOriginSitePOC.
		/// </value>
		public string JobOriginSitePOC { get; set; }

        /// <summary>
        /// Gets or sets the origin site poc phone.
        /// </summary>
        /// <value>
        /// The JobOriginSitePOCPhone.
        /// </value>
        public string JobOriginSitePOCPhone { get; set; }

        /// <summary>
        /// Gets or sets the email.
        /// </summary>
        /// <value>
        /// The JobOriginSitePOCEmail.
        /// </value>
        public string JobOriginSitePOCEmail { get; set; }

        /// <summary>
        /// Gets or sets the site name.
        /// </summary>
        /// <value>
        /// The JobOriginSiteName.
        /// </value>
        public string JobOriginSiteName { get; set; }

        /// <summary>
        /// Gets or sets the street address.
        /// </summary>
        /// <value>
        /// The JobOriginStreetAddress.
        /// </value>
        public string JobOriginStreetAddress { get; set; }

        /// <summary>
        /// Gets or sets the street address2.
        /// </summary>
        /// <value>
        /// The JobOriginStreetAddress2.
        /// </value>
        public string JobOriginStreetAddress2 { get; set; }

        /// <summary>
        /// Gets or sets the street address3.
        /// </summary>
        /// <value>
        /// The JobOriginStreetAddress3.
        /// </value>
        public string JobOriginStreetAddress3 { get; set; }
        /// <summary>
        /// Gets or sets the street address4.
        /// </summary>
        /// <value>
        /// The JobOriginStreetAddress4.
        /// </value>
        public string JobOriginStreetAddress4 { get; set; }

        /// <summary>
        /// Gets or sets the city.
        /// </summary>
        /// <value>
        /// The JobOriginCity.
        /// </value>
        public string JobOriginCity { get; set; }

        /// <summary>
        /// Gets or sets the state province.
        /// </summary>
        /// <value>
        /// The JobOriginStateProvince.
        /// </value>
        public string JobOriginState { get; set; }

        /// <summary>
        /// Gets or sets the postalcode.
        /// </summary>
        /// <value>
        /// The JobOriginPostalCode.
        /// </value>
        public string JobOriginPostalCode { get; set; }

        /// <summary>
        /// Gets or sets the country.
        /// </summary>
        /// <value>
        /// The JobOriginCountry.
        /// </value>
        public string JobOriginCountry { get; set; }
        /// <summary>
        /// Gets or Sets List of Job Gateways
        /// </summary>
        public List<OrderGatewayDetails> OrderGatewayDetails { get; set; }
        //public List<OrderDocumentDetails> OrderDocumentDetails { get; set; }

        /// <summary>
        /// Gets or Sets List of job seller poc
        /// </summary>
        public string JobSellerSitePOC { get; set; }
        /// <summary>
        /// Gets or Sets List of job seller poc email
        /// </summary>
        public string JobSellerSitePOCEmail { get; set; }
        /// <summary>
        /// Gets or Sets List of job seller poc phone
        /// </summary>
        public string JobSellerSitePOCPhone { get; set; }
        /// <summary>
        /// Gets or Sets List of job seller poc address
        /// </summary>
        public string JobSellerStreetAddress { get; set; }
        /// <summary>
        /// Gets or Sets List of job seller poc address2
        /// </summary>
        public string JobSellerStreetAddress2 { get; set; }
        /// <summary>
        /// Gets or Sets List of job seller poc address3
        /// </summary>
        public string JobSellerStreetAddress3 { get; set; }
        /// <summary>
        /// Gets or Sets List of job seller poc address4
        /// </summary>
        public string JobSellerStreetAddress4 { get; set; }
        /// <summary>
        /// Gets or Sets List of job seller city
        /// </summary>
        public string JobSellerCity { get; set; }
        /// <summary>
        /// Gets or Sets List of job seller state
        /// </summary>
        public string JobSellerState { get; set; }
        /// <summary>
        /// Gets or Sets List of job seller postal code
        /// </summary>
        public string JobSellerPostalCode { get; set; }
        /// <summary>
        /// Gets or Sets JobCubesUnitTypeIdName
        /// </summary>
        public string JobCubesUnitTypeIdName { get; set; }
        /// <summary>
        /// Gets or Sets JobWeightUnitTypeIdName
        /// </summary>
        public string JobWeightUnitTypeIdName { get; set; }
        /// <summary>
        /// Gets or Sets JobTotalWeight
        /// </summary>
        public decimal JobTotalWeight { get; set; }
        /// <summary>
		/// Gets or Sets count of JobServiceActual
		/// </summary>
		public int? JobServiceActual { get; set; }
        /// <summary>
        /// Gets or Sets JobDriverAlert
        /// </summary>
        public string JobDriverAlert { get; set; }
        /// <summary>
		/// Gets or Sets JobQtyOrdered
		/// </summary>
		public int? JobQtyOrdered { get; set; }
        /// <summary>
        /// Gets or Sets JobQtyActual
        /// </summary>
        public int? JobQtyActual { get; set; }
        /// <summary>
        /// Gets or Sets JobQtyUnitTypeIdName
        /// </summary>
        public string JobQtyUnitTypeIdName { get; set; }
        /// <summary>
        /// Gets or Sets JobPartsOrdered
        /// </summary>
        public int? JobPartsOrdered { get; set; }
        /// <summary>
        /// Gets or Sets JobPartsActual
        /// </summary>
        public int? JobPartsActual { get; set; }
        /// <summary>
        /// Gets or Sets JobTotalCubes
        /// </summary>
        public decimal? JobTotalCubes { get; set; }
        /// <summary>
		/// Gets or Sets count of JobServiceOrder
		/// </summary>
		public int? JobServiceOrder { get; set; }
    }
}