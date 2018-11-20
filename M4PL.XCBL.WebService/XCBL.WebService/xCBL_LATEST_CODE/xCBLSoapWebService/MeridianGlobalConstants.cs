//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian xCBL Web Service - AWC Timberlake
//Programmer:                                   Nathan Fujimoto
//Date Programmed:                              1/8/2016
//Program Name:                                 Meridian xCBL Web Service
//Purpose:                                      The module contains global constant values that are used in the Meridian xCBL Web Service 
//
//==================================================================================================================================================== 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace xCBLSoapWebService
{
    public class MeridianGlobalConstants
    {
        #region xCBL General Constants
        public const string CREDENTIAL_NAMESPACE = "http://Microsoft.WCF.Documentation";
        public const string CREDENTIAL_HEADER = "Credentials";
        public const string CREDENTIAL_USERNAME = "UserName";
        public const string CREDENTIAL_PASSWORD = "Password";
        public const string CREDENTIAL_HASHKEY = "Hashkey";
        public const string XCBL_CREDENTIAL_HASHKEY = "XcblWebServiceMERIDNow";
        public const string XCBL_AWC_FILE_PREFIX = "AWCBL";
        public const string XCBL_FILE_EXTENSION = ".csv";
        public const string XCBL_XML_EXTENSION = ".xml";
        public const string XCBL_FTP_CSV_PATH_SUFFIX = "/CSV/";
        public const string XCBL_LOCAL_CSV_PATH_SUFFIX = "\\CSV\\";

        public const string XCBL_FILE_DATETIME_FORMAT = "yyMMddhhmmssffff";

        public static readonly string CONFIG_CREATE_LOCAL_CSV = System.Configuration.ConfigurationManager.AppSettings["CreateLocalFiles"].ToString();
        public static readonly string SHOULD_CREATE_LOCAL_FILE = "1";

        //Prod Server config which needs to be uncommented for Production Release
        //public const String XCBL_DATABASE_SERVER_URL = "Server=edge.meridianww.com; DataBase = SYST010MeridianXCBLService; User Id = dev_connection; Password = Password88; Connection Timeout = 0";

        //Local server config -  used for testing local server
        //public const String XCBL_DATABASE_SERVER_URL = @"Server=172.30.255.12\SQL08ENTR2ITERM,51260; DataBase = XCBService;User Id = Bcycle_Users; Password = Bcycle_Users; Connection Timeout = 0";

        //Modified by Ram Nov-24-2016 to make the Configuration dynamic and from Web.config
        public static readonly string XCBL_DATABASE_SERVER_URL = System.Configuration.ConfigurationManager.ConnectionStrings["XcblService"].ToString();
        //End Ram - Configuration dynamic


        #endregion

        #region xCBL Message Acknowledgement Constants
        /**************************************************************************xCBL Message Acknowledge********************************************************************
         * 
         * Structure for Message Acknowledge xCBL response that is returned when calling SendScheduleMessage method
         * 
        **********************************************************************************************************************************************************************/
        public const string MESSAGE_ACKNOWLEDGEMENT_SUCCESS = "Success";
        public const string MESSAGE_ACKNOWLEDGEMENT_FAILURE = "Failure";
        public const string MESSAGE_ACKNOWLEDGEMENT_FAILURE_FTP = "Process successfully but not able to upload on FTP because of 550 error code";

        public const string XML_HEADER = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
        public const string MESSAGE_ACKNOWLEDGEMENT_OPEN_TAG = "<MessageAcknowledgement xmlns:core=\"rrn:org.xcbl:schemas/xcbl/v4_0/core/core.xsd\" xmlns=\"rrn:org.xcbl:schemas/xcbl/v4_0/materialsmanagement/v1_0/materialsmanagement.xsd\">";
        public const string MESSAGE_REQUISITION_ACKNOWLEDGEMENT_OPEN_TAG = "<MessageAcknowledgement xmlns=\"rrn:org.xcbl:schemas/xcbl/v4_0/messagemanagement/v1_0/messagemanagement.xsd\" xmlns:core=\"rrn:org.xcbl:schemas/xcbl/v4_0/core/core.xsd\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">";
        public const string MESSAGE_ACKNOWLEDGEMENT_REFERENCE_NUMBER_OPEN_TAG = "<AcknowledgementReferenceNumber>";
        // Need to include Schedule ID value in AcknowledgementReferenceNumber Tag
        public const string MESSAGE_ACKNOWLEDGEMENT_REFERENCE_NUMBER_CLOSE_TAG = "</AcknowledgementReferenceNumber>";
        public const string MESSAGE_ACKNOWLEDGEMENT_NOTE_OPEN_TAG = "<AcknowledgementNote><Status>";
        // Need to include response value of Success or Failure in Status Tag
        public const string MESSAGE_ACKNOWLEDGEMENT_NOTE_CLOSE_TAG = "</Status></AcknowledgementNote>";
        public const string MESSAGE_ACKNOWLEDGEMENT_CLOSE_TAG = "</MessageAcknowledgement>";
        /*********************************************************************************************************************************************************************/
        #endregion

        #region xCBL Send Schedule Message Constants
        /**************************************************************************xCBL Shipping Schedule**********************************************************************
         * 
         * Structure for expected Shipping Schedule xCBL tags 
         * 
        **********************************************************************************************************************************************************************/
        public const string CSV_HEADER_NAMES = "ScheduleID,ScheduleIssuedDate,OrderNumber,SequenceNumber" +
                            ",Other_FirstStop,Other_Before7,Other_Before9,Other_Before12,Other_SameDay,Other_OwnerOccupied,Other_7,Other_8,Other_9,Other_10" +
                            ",PurposeCoded,ScheduleType,AgencyCoded,Name1,Street,Streetsupplement1,PostalCode,City,RegionCoded," +
                            "ContactName,ContactNumber_1,ContactNumber_2,ContactNumber_3,ContactNumber_4,ContactNumber_5,ContactNumber_6" +
                            ",ShippingInstruction,GPSSystem,Latitude,Longitude,LocationID,EstimatedArrivalDate";
        public const string CSV_HEADER_NAMES_FORMAT = "{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23},{24},{25},{26},{27},{28},{29},{30},{31},{32},{33},{34},{35}";
        public const string XCBL_SHIPPING_SCHEDULE_HEADER = "ShippingScheduleHeader";
        public const string XCBL_SCHEDULE_ID = "//default:ScheduleID";
        public const string XCBL_PURPOSE = "purpose";
        public const string XCBL_SHIPPING_SCHEDULE_HEADER_ID = "ShippingScheduleHeader_ID";
        public const string XCBL_PURPOSE_CODED = "//default:Purpose/core:PurposeCoded";
        public const string XCBL_SCHEDULE_TYPE_CODED = "//default:ScheduleTypeCoded";
        public const string XCBL_SCHEDULE_TYPE_CODED_TEXT = "ScheduleTypeCoded_Text";
        public const string XCBL_SCHEDULE_REFERENCES = "//default:ScheduleReferences";
        public const string XCBL_PURCHASE_ORDER_REFERENCE = "//default:PurchaseOrderReference";
        public const string XCBL_CONTACT_NUMBER = "contactNumber";
        public const string XCBL_LIST_OF_CONTACT_NUMBER_ID = "ListofContactNumber_ID";
        public const string XCBL_CONTACT_NUMBER_VALUE = "ContactNumberValue";
        public const string XCBL_OTHER_SCHEDULE_REFERENCES = "//default:OtherScheduleReferences";
        public const string XCBL_REFERENCE_CODED = "ReferenceCoded";
        public const string XCBL_OTHER_SCHEDULE_REFERENCES_ID = "OtherScheduleReferences_ID";
        public const string XCBL_REFERENCE_DESCRIPTION = "ReferenceDescription";
        public const string XCBL_SELLER_ORDER_NUMBER = "SellerOrderNumber";
        public const string XCBL_CHANGE_ORDER_SEQUENCE_NUMBER = "ChangeOrderSequenceNumber";
        public const string XCBL_SCHEDULE_ISSUED_DATE = "//default:ScheduleIssuedDate";
        public const string XCBL_AGENCY = "Agency";
        public const string XCBL_AGENCY_CODED = "//default:ScheduleParty/default:ShipToParty/core:PartyID/core:Agency/core:AgencyCoded";
        public const string XCBL_NAME_ADDRESS = "NameAddress";
        public const string XCBL_NAME = "//default:ScheduleParty/default:ShipToParty/core:NameAddress/core:Name1";
        public const string XCBL_STREET = "//default:ScheduleParty/default:ShipToParty/core:NameAddress/core:Street";
        public const string XCBL_STREET_SUPPLEMENT = "//default:ScheduleParty/default:ShipToParty/core:NameAddress/core:StreetSupplement1";
        public const string XCBL_POSTAL_CODE = "//default:ScheduleParty/default:ShipToParty/core:NameAddress/core:PostalCode";
        public const string XCBL_CITY = "//default:ScheduleParty/default:ShipToParty/core:NameAddress/core:City";
        public const string XCBL_REGION = "Region";
        public const string XCBL_REGION_CODED = "//default:ScheduleParty/default:ShipToParty/core:NameAddress/core:Region/core:RegionCoded";
        public const string XCBL_PRIMARY_CONTACT = "PrimaryContact";
        public const string XCBL_CONTACT_NAME = "//default:ScheduleParty/default:ShipToParty/core:PrimaryContact/core:ContactName";
        public const string XCBL_LIST_OF_CONTACT_NUMBERS = "//default:ScheduleParty/default:ShipToParty/core:PrimaryContact/core:ListOfContactNumber";
        public const string XCBL_CONTACT_VALUE = "ContactNumberValue";
        public const string XCBL_TRANSPORT_ROUTING = "TransportRouting";
        public const string XCBL_SHIPPING_INSTRUCTIONS = "//default:ListOfTransportRouting/core:TransportRouting/core:ShippingInstructions";
        public const string XCBL_GPS_COORDINATES = "GPSCoordinates";
        public const string XCBL_GPS_SYSTEM = "//default:ListOfTransportRouting/core:TransportRouting/core:TransportLocationList/core:EndTransportLocation/core:Location/core:GPSCoordinates/core:GPSSystem";
        public const string XCBL_LATITUDE = "//default:ListOfTransportRouting/core:TransportRouting/core:TransportLocationList/core:EndTransportLocation/core:Location/core:GPSCoordinates/core:Latitude";
        public const string XCBL_LONGITUDE = "//default:ListOfTransportRouting/core:TransportRouting/core:TransportLocationList/core:EndTransportLocation/core:Location/core:GPSCoordinates/core:Longitude";
        public const string XCBL_LOCATION = "Location";
        public const string XCBL_LOCATION_ID = "//default:ListOfTransportRouting/core:TransportRouting/core:TransportLocationList/core:EndTransportLocation/core:LocationID";
        public const string XCBL_ESTIMATED_ARRIVAL_DATE = "//default:ListOfTransportRouting/core:TransportRouting/core:TransportLocationList/core:EndTransportLocation/core:EstimatedArrivalDate";
        public const string XCBL_ShippingScheule_XML_Https = "tem1:ShipmentOrder";
        public const string XCBL_ShippingScheule_XML_Http = "tem:ShipmentOrder";
        //public const string XCBL_ShippingScheule_XML_Https = "tem1:SubmitDocument";
        //public const string XCBL_ShippingScheule_XML_Http = "tem:SubmitDocument";
        public const string XCBL_REFERENCE_TYPECODE_OTHER = "ReferenceTypeCodedOther";

        public const string XCBL_SP_InsTransactionLog = "InsTransactionLog";
        public const string XCBL_SP_GetXcblAuthenticationUser = "GetXcblAuthenticationUser";

        /*********************************************************************************************************************************************************************/
        #endregion

        #region xCBL Requisition Message Constants

        public const string REQUISITION_CSV_HEADER_NAMES = "ReqNumber,RequisitionIssueDate,RequisitionTypeCoded,RequisitionTypeCodedOther,ReferenceTypeCoded_WorkOrder," +
                                                     "ReferenceTypeCoded_OriginalOrder,ReferenceTypeCoded_Cabinets,ReferenceTypeCoded_Parts,ReferenceTypeCoded_NewOrderNumber," +
                                                     "ReferenceTypeCoded_BOL,ReferenceTypeCoded_Manifest,ReferenceTypeCoded_RequistionType,ReferenceTypeCoded_Domicile,PurposeCoded," +
                                                     "PurposeCodedOther,RequestedShipByDate,ShipToParty,ShipToParty_Name1,ShipToParty_Street,ShipToParty_StreetSupplement1," +
                                                     "ShipToParty_PostalCode,ShipToParty_City,ShipToParty_RegionCoded,ShipFromParty,ShipFromParty_Name1,ShipFromParty_Street," +
                                                     "ShipFromParty_StreetSupplement1,ShipFromParty_PostalCode,ShipFromParty_City,ShipFromParty_RegionCoded,QuantityValue_Cabinets," +
                                                     "UOMCoded_Cabinets,UOMCodedOther_Cabinets,QuantityQualifierCoded_Cabinets,QuantityQualifierCodedOther_Cabinets,QuantityValue_Parts," +
                                                     "UOMCoded_Parts,UOMCodedOther_Parts,QuantityQualifierCoded_Parts,QuantityQualifierCodedOther_Parts,ShippingInstructions," +
                                                     "TransitDirectionCoded,TransitDirectionCodedOther,GPSSystem_StartTransportationLocation,Latitude_StartTransportationLocation," +
                                                     "Longitude_StartTransportationLocation,LocationID_StartTransportationLocation,GPSSystem_EndTransportationLocation," +
                                                     "Latitude_EndTransportationLocation,Longitude_EndTransportationLocation,LocationID_EndTransportationLocation";
        public const string REQUISITION_CSV_HEADER_NAMES_FORMAT = "{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23}," +
                                                            "{24},{25},{26},{27},{28},{29},{30},{31},{32},{33},{34},{35},{36},{37},{38},{39},{40},{41},{42},{43},{44},{45}," +
                                                            "{46},{47},{48},{49},{50}";

        public const string XCBL_REQUISITION_HEADER = "RequisitionHeader";
        public const string XCBL_Requisition_XML_Https = "tem1:Requisition";
        public const string XCBL_Requisition_XML_Http = "tem:Requisition";
        public const string XCBL_REQUISITION_NUMBER = "//default:ReqNumber";
        public const string XCBL_REQUISITION_ISSUE_DATE = "//default:RequisitionIssueDate";
        public const string XCBL_REQUISITION_TYPE = "//default:RequisitionType";
        public const string XCBL_REQUISITION_TYPE_CODED = "//default:RequisitionType/default:RequisitionTypeCoded";
        public const string XCBL_REQUISITION_TYPE_CODED_OTHER = "//default:RequisitionType/default:RequisitionTypeCodedOther";
        public const string XCBL_REQUISITION_PURPOSE = "//default:Purpose";
        public const string XCBL_PURPOSE_CODED_OTHER = "//default:Purpose/core:PurposeCodedOther";
        public const string XCBL_REQUISITION_DATES = "//default:RequisitionDates";
        public const string XCBL_REQUESTED_SHIP_BY_DATE = "//default:RequisitionDates/default:RequestedShipByDate";
        public const string XCBL_REQUISITION_PARTY = "//default:RequisitionParty";

        public const string XCBL_REQUISITION_SHIP_TO_PARTY = "//default:RequisitionParty/default:ShipToParty";
        public const string XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS = "//default:RequisitionParty/default:ShipToParty/core:NameAddress";
        public const string XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_NAME1 = "//default:RequisitionParty/default:ShipToParty/core:NameAddress/core:Name1";
        public const string XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_STREET = "//default:RequisitionParty/default:ShipToParty/core:NameAddress/core:Street";
        public const string XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_STREET_SUPPLEMENT1 = "//default:RequisitionParty/default:ShipToParty/core:NameAddress/core:StreetSupplement1";
        public const string XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_POSTAL_CODE = "//default:RequisitionParty/default:ShipToParty/core:NameAddress/core:PostalCode";
        public const string XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_CITY = "//default:RequisitionParty/default:ShipToParty/core:NameAddress/core:City";
        public const string XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_REGION = "//default:RequisitionParty/default:ShipToParty/core:NameAddress/core:Region";
        public const string XCBL_REQUISITION_SHIP_TO_PARTY_NAME_ADDRESS_REGION_REGIONCODED = "//default:RequisitionParty/default:ShipToParty/core:NameAddress/core:Region/core:RegionCoded";

        public const string XCBL_REQUISITION_SHIP_FROM_PARTY = "//default:RequisitionParty/default:ShipFromParty";
        public const string XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS = "//default:RequisitionParty/default:ShipFromParty/core:NameAddress";
        public const string XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_NAME1 = "//default:RequisitionParty/default:ShipFromParty/core:NameAddress/core:Name1";
        public const string XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_STREET = "//default:RequisitionParty/default:ShipFromParty/core:NameAddress/core:Street";
        public const string XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_STREET_SUPPLEMENT1 = "//default:RequisitionParty/default:ShipFromParty/core:NameAddress/core:StreetSupplement1";
        public const string XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_POSTAL_CODE = "//default:RequisitionParty/default:ShipFromParty/core:NameAddress/core:PostalCode";
        public const string XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_CITY = "//default:RequisitionParty/default:ShipFromParty/core:NameAddress/core:City";
        public const string XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_REGION = "//default:RequisitionParty/default:ShipFromParty/core:NameAddress/core:Region";
        public const string XCBL_REQUISITION_SHIP_FROM_PARTY_NAME_ADDRESS_REGION_REGIONCODED = "//default:RequisitionParty/default:ShipFromParty/core:NameAddress/core:Region/core:RegionCoded";

        public const string XCBL_TRANSPORT_QUANTITIES = "//default:ListOfTransportRouting/core:TransportRouting/core:TransportQuantities";
        public const string XCBL_LIST_OF_QUANTITY_CODED = "//default:ListOfTransportRouting/core:TransportRouting/core:TransportQuantities/core:ListOfQuantityCoded";
        public const string XCBL_QUANTITY_VALUE = "//core:QuantityCoded/core:QuantityValue";
        public const string XCBL_QUANTITYVALUE = "QuantityValue";
        public const string XCBL_UNITOFMEASUREMENT = "UnitOfMeasurement";
        public const string XCBL_QUANTITYQUALIFIERCODED = "QuantityQualifierCoded";
        public const string XCBL_QUANTITYQUALIFIERCODEDOTHER = "QuantityQualifierCodedOther";

        public const string XCBL_UNIT_OF_MEASUREMENT = "//core:QuantityCoded/core:UnitOfMeasurement";
        public const string XCBL_UOM_CODED = "//core:UnitOfMeasurement/core:UOMCoded";
        public const string XCBL_UOM_CODED_OTHER = "//core:UnitOfMeasurement/core:UOMCodedOther";
        public const string XCBL_QUANTITY_QUALIFIER_CODED = "//core:QuantityCoded/core:QuantityQualifierCoded";
        public const string XCBL_QUANTITY_QUALIFIER_CODED_OTHER = "//core:QuantityCoded/core:QuantityQualifierCodedOther";
        public const string XCBL_QUANTITY_QUALIFIER_CABINETS = "cabinets";
        public const string XCBL_QUANTITY_QUALIFIER_PARTS = "parts";
        public const string XCBL_TRANSIT_DIRECTION = "//default:ListOfTransportRouting/core:TransportRouting/core:TransitDirection";
        public const string XCBL_TRANSIT_DIRECTION_CODED = "//core:TransitDirection/core:TransitDirectionCoded";
        public const string XCBL_TRANSIT_DIRECTION_CODED_OTHER = "//core:TransitDirection/core:TransitDirectionCodedOther";
        public const string XCBL_TRANSPORT_LOCATION_LIST = "//default:ListOfTransportRouting/core:TransportRouting/core:TransportLocationList";
        public const string XCBL_START_TRANSPORT = "//core:TransportLocationList/core:StartTransportLocation";
        public const string XCBL_START_TRANSPORT_LOCATION = "//core:StartTransportLocation/core:Location";
        public const string XCBL_START_TRANSPORT_LOCATION_GPS_COORDINATES = "//core:StartTransportLocation/core:Location/core:GPSCoordinates";
        public const string XCBL_START_TRANSPORT_LOCATION_GPS_COORDINATES_GPS_SYSTEM = "//core:StartTransportLocation/core:Location/core:GPSCoordinates/core:GPSSystem";
        public const string XCBL_START_TRANSPORT_LOCATION_GPS_COORDINATES_LATITUDE = "//core:StartTransportLocation/core:Location/core:GPSCoordinates/core:Latitude";
        public const string XCBL_START_TRANSPORT_LOCATION_GPS_COORDINATES_LONGITUDE = "//core:StartTransportLocation/core:Location/core:GPSCoordinates/core:Longitude";
        public const string XCBL_START_TRANSPORT_LOCATION_ID = "//core:StartTransportLocation/core:LocationID";
        public const string XCBL_END_TRANSPORT = "//core:TransportLocationList/core:EndTransportLocation";
        public const string XCBL_END_TRANSPORT_LOCATION = "//core:EndTransportLocation/core:Location";
        public const string XCBL_END_TRANSPORT_LOCATION_GPS_COORDINATES = "//core:EndTransportLocation/core:Location/core:GPSCoordinates";
        public const string XCBL_END_TRANSPORT_LOCATION_GPS_COORDINATES_GPS_SYSTEM = "//core:EndTransportLocation/core:Location/core:GPSCoordinates/core:GPSSystem";
        public const string XCBL_END_TRANSPORT_LOCATION_GPS_COORDINATES_LATITUDE = "//core:EndTransportLocation/core:Location/core:GPSCoordinates/core:Latitude";
        public const string XCBL_END_TRANSPORT_LOCATION_GPS_COORDINATES_LONGITUDE = "//core:EndTransportLocation/core:Location/core:GPSCoordinates/core:Longitude";
        public const string XCBL_END_TRANSPORT_LOCATION_ID = "//core:EndTransportLocation/core:LocationID";


        public const string XCBL_OTHER_REQUISITION_REFERENCES = "//default:OtherRequisitionReferences";
        public const string XCBL_REFERENCE_TYPE_CODED = "//core:ReferenceCoded/core:ReferenceTypeCoded";
        public const string XCBL_REFERENCE_TYPE_CODED_OTHER = "//core:ReferenceTypeCodedOther";
        public const string XCBL_REFERENCE_CODED_PRIMARY_REFERENCE = "//core:PrimaryReference";
        public const string XCBL_REFERENCE_CODED_PRIMARY_REFERENCE_REF_NUM = "//core:PrimaryReference/core:RefNum";
        public const string XCBL_REFERENCE_CODED_PRIMARY_REFERENCE_REF_DATE = "//core:PrimaryReference/core:RefDate";
        public const string XCBL_PRIMARY_REFERENCE = "PrimaryReference";
        public const string XCBL_WORK_ORDER = "workorder";
        public const string XCBL_ORIGINAL_ORDER = "originalorder";
        public const string XCBL_CABINETS = "cabinets";
        public const string XCBL_PARTS = "parts";
        public const string XCBL_BOL = "bol";
        public const string XCBL_MANIFEST = "manifest";
        public const string XCBL_NEW_ORDER_NUMBER = "newordernumber";
        public const string XCBL_REQUISTION_TYPE = "requistiontype";
        public const string XCBL_DOMICILE = "domicile";


        #region Method Names

        public const string METHOD_GET_OTHER_REQUISITION_REFERENCE = "GetOtherRequisitionReferences";
        public const string METHOD_GET_LIST_OF_TRANSPORT_ROUTING = "GetListOfTransportRouting";
        public const string METHOD_GET_REQUISITION_TYPES = "GetRequisitionTypes";
        public const string METHOD_GET_PURPOSES = "GetPurposes";
        public const string METHOD_GET_REQUESTED_SHIP_BY_DATE = "GetRequestedShipByDate";
        public const string METHOD_GET_REQUISITION_PARTY = "GetRequisitionParty";

        #endregion Method Names

        public const string TAG_PREFIXED_WITH_CORE = "core:{0}";


        #endregion xCBL Requisition Message Constants

        #region xCBL Shipping Schedule Response Message Constants

        public const string XCBL_SHIPPING_SCHEDULE_RESPONSE_HEADER = "ShippingScheduleResponseHeader";
        public const string XCBL_ShippingScheuleResponse_XML_Https = "tem1:ShippingScheduleResponse";
        public const string XCBL_ShippingScheuleResponse_XML_Http = "tem:ShippingScheduleResponse";
        public const string XCBL_SCHEDULE_RESPONSE_ID = "//default:ScheduleResponseID";
        public const string XCBL_SCHEDULE_RESPONSE_ISSUE_DATE = "//default:ScheduleResponseIssueDate";
        public const string XCBL_SCHEDULE_RESPONSE_REFERENCE = "//default:ShippingScheduleReference/core:RefNum";
        public const string XCBL_SCHEDULE_RESPONSE_PURPOSE_CODED = "//default:Purpose/core:PurposeCoded";
        public const string XCBL_SCHEDULE_RESPONSE_RESPONSE_TYPE_CODED = "//default:ResponseType/core:ResponseTypeCoded";
        public const string XCBL_SCHEDULE_PURPOSE_CODED = "//default:ShippingScheduleHeader/default:Purpose/core:PurposeCoded";
        public const string SHIPPING_SCHEDULE_RESPONSE_CSV_HEADER_NAMES = "ScheduleResponseID,ScheduleResponseIssuedDate,RefNum,PurposeCoded,ResponseTypeCoded,ShippingScheduleHeader" +
                            ",ScheduleID,ScheduleIssuedDate,OrderNumber,SequenceNumber" +
                            ",Other_FirstStop,Other_Before7,Other_Before9,Other_Before12,Other_SameDay,Other_OwnerOccupied,Other_7,Other_8,Other_9,Other_10" +
                            ",PurposeCoded,ScheduleType,AgencyCoded,Name1,Street,Streetsupplement1,PostalCode,City,RegionCoded" +
                            ",ContactName,ContactNumber_1,ContactNumber_2,ContactNumber_3,ContactNumber_4,ContactNumber_5,ContactNumber_6" +
                            ",ShippingInstruction,GPSSystem,Latitude,Longitude,LocationID,EstimatedArrivalDate";
        public const string SHIPPING_SCHEDULE_RESPONSE_CSV_HEADER_NAMES_FORMAT = "{0},{1},{2},{3},{4},{5},{6},{7},{8},{9},{10},{11},{12},{13},{14},{15},{16},{17},{18},{19},{20},{21},{22},{23},{24},{25},{26},{27},{28},{29},{30},{31},{32},{33},{34},{35},{36},{37},{38},{39},{40},{41}";


        #region Methods

        public const string METHOD_GET_PURPOSE_SCHEDULE_TYPE_CODE_AND_PARTY = "GetPurposeScheduleTypeCodeAndParty";

        #endregion Methods

        #endregion  xCBL Shipping Schedule Response Message Constants
    }
}