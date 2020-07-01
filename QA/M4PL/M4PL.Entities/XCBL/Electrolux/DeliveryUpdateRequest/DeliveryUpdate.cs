using System.Xml.Serialization;

namespace M4PL.Entities.XCBL.Electrolux.DeliveryUpdateRequest
{
    [XmlRoot(ElementName = "DeliveryUpdate")]
    public class DeliveryUpdate
    {
        [XmlElement(ElementName = "ServiceProvider")]
        public string ServiceProvider { get; set; }
        [XmlElement(ElementName = "ServiceProviderID")]
        public string ServiceProviderID { get; set; }
        [XmlElement(ElementName = "OrderNumber")]
        public string OrderNumber { get; set; }
        [XmlElement(ElementName = "OrderDate")]
        public string OrderDate { get; set; }
        [XmlElement(ElementName = "SPTransactionID")]
        public string SPTransactionID { get; set; }
        [XmlElement(ElementName = "InstallStatus")]
        public string InstallStatus { get; set; }
        [XmlElement(ElementName = "InstallStatusTS")]
        public string InstallStatusTS { get; set; }
        [XmlElement(ElementName = "PlannedInstallDate")]
        public string PlannedInstallDate { get; set; }
        [XmlElement(ElementName = "ScheduledInstallDate")]
        public string ScheduledInstallDate { get; set; }
        [XmlElement(ElementName = "ActualInstallDate")]
        public string ActualInstallDate { get; set; }
        [XmlElement(ElementName = "RescheduledInstallDate")]
        public string RescheduledInstallDate { get; set; }
        [XmlElement(ElementName = "RescheduleReason")]
        public string RescheduleReason { get; set; }
        [XmlElement(ElementName = "CancelDate")]
        public string CancelDate { get; set; }
        [XmlElement(ElementName = "CancelReason")]
        public string CancelReason { get; set; }
        [XmlElement(ElementName = "Exceptions")]
        public Exceptions Exceptions { get; set; }
        [XmlElement(ElementName = "UserNotes")]
        public string UserNotes { get; set; }
        [XmlElement(ElementName = "OrderURL")]
        public string OrderURL { get; set; }
        [XmlElement(ElementName = "POD")]
        public POD POD { get; set; }
        [XmlElement(ElementName = "AdditionalComments")]
        public string AdditionalComments { get; set; }
        [XmlElement(ElementName = "OrderLineDetail")]
        public OrderLineDetails OrderLineDetail { get; set; }
    }
}
