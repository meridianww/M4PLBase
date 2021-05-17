#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright

using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest
{
    [XmlRoot(ElementName = "DeliveryUpdate")]
    public class DeliveryUpdate
    {
        /// <summary>
        /// Gets or Sets Service Provider e.g. Meridian
        /// </summary>
        [XmlElement(ElementName = "ServiceProvider")]
        public string ServiceProvider { get; set; }
        /// <summary>
        /// Gets or Sets Service Provider ID e.g. JobID
        /// </summary>
        [XmlElement(ElementName = "ServiceProviderID")]
        public string ServiceProviderID { get; set; }
        /// <summary>
        /// Gets or Sets Order Number e.g. Contract #
        /// </summary>
        [XmlElement(ElementName = "OrderNumber")]
        public string OrderNumber { get; set; }
        /// <summary>
        /// Gets or Sets Order Date 
        /// </summary>
        [XmlElement(ElementName = "OrderDate")]
        public string OrderDate { get; set; }
        /// <summary>
        /// Gets or Sets SP Transaction ID e.g. JobID
        /// </summary>
        [XmlElement(ElementName = "SPTransactionID")]
        public string SPTransactionID { get; set; }
        /// <summary>
        /// Gets or Sets Install Status e.g. Out for delivery or Scheduled etc.
        /// </summary>
        [XmlElement(ElementName = "InstallStatus")]
        public string InstallStatus { get; set; }
        /// <summary>
        /// Gets or Sets Install Status TS e.g. If Install Status is not empty then  Date Entered or empty
        /// </summary>
        [XmlElement(ElementName = "InstallStatusTS")]
        public string InstallStatusTS { get; set; }
        /// <summary>
        /// Gets or Sets Planned Installation Date 
        /// </summary>
        [XmlElement(ElementName = "PlannedInstallDate")]
        public string PlannedInstallDate { get; set; }
        /// <summary>
        /// Gets or Sets Scheduled Installation Date
        /// </summary>
        [XmlElement(ElementName = "ScheduledInstallDate")]
        public string ScheduledInstallDate { get; set; }
        /// <summary>
        /// Gets or Sets Actual Installation Date 
        /// </summary>
        [XmlElement(ElementName = "ActualInstallDate")]
        public string ActualInstallDate { get; set; }
        /// <summary>
        /// Gets or Sets Rescheduled Installation date if re scheduled
        /// </summary>
        [XmlElement(ElementName = "RescheduledInstallDate")]
        public string RescheduledInstallDate { get; set; }
        /// <summary>
        /// Gets or Sets Reason for ReScheduling
        /// </summary>
        [XmlElement(ElementName = "RescheduleReason")]
        public string RescheduleReason { get; set; }
        /// <summary>
        /// Gets or Sets Cancellation date if any cancellation Action is Added
        /// </summary>
        [XmlElement(ElementName = "CancelDate")]
        public string CancelDate { get; set; }
        /// <summary>
        /// Gets or Sets Reason for Cancellation if any cancellation Action is Added
        /// </summary>
        [XmlElement(ElementName = "CancelReason")]
        public string CancelReason { get; set; }
        [XmlElement(ElementName = "AttemptReason")]
        public string AttemptReason { get; set; }
        /// <summary>
        /// Gets or Sets Exception Details if added
        /// </summary>
        [XmlElement(ElementName = "Exceptions")]
        public Exceptions Exceptions { get; set; }
        /// <summary>
        /// Gets or Sets User Notes
        /// </summary>
        [XmlElement(ElementName = "UserNotes")]
        public string UserNotes { get; set; }
        /// <summary>
        /// Gets or Sets Order URL e.g.  http://m4pl.meridianww.com//?jobId=191179
        /// </summary>
        [XmlElement(ElementName = "OrderURL")]
        public string OrderURL { get; set; }
        /// <summary>
        /// Gets or Sets POD details
        /// </summary>
        [XmlElement(ElementName = "POD")]
        public POD POD { get; set; }
        /// <summary>
        /// Gets or Sets Additional Comments
        /// </summary>
        [XmlElement(ElementName = "AdditionalComments")]
        public string AdditionalComments { get; set; }
        /// <summary>
        /// Gets or Sets Order Line Details
        /// </summary>
        [XmlElement(ElementName = "OrderLineDetail")]
        public OrderLineDetails OrderLineDetail { get; set; }
    }
}
