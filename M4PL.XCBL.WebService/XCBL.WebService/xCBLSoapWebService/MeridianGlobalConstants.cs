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
        public const String CREDENTIAL_NAMESPACE = "http://Microsoft.WCF.Documentation";
        public const String CREDENTIAL_HEADER = "Credentials";
        public const String CREDENTIAL_USERNAME = "UserName";
        public const String CREDENTIAL_PASSWORD = "Password";
        public const String CREDENTIAL_HASHKEY = "Hashkey";
        public const String XCBL_CREDENTIAL_HASHKEY = "XcblWebServiceMERIDNow";
        public const String XCBL_AWC_FILE_PREFIX = "AWCBL";
        public const String XCBL_FILE_EXTENSION = ".csv";
        public const String XCBL_XML_EXTENSION = ".xml";

        public const String XCBL_FILE_DATETIME_FORMAT = "yyMMddhhmmssffff";

        //Modified by Ram jun-20-2016 to make the Configuration dynamic and from Web.config
        public static readonly String FTP_SERVER_CSV_URL = System.Configuration.ConfigurationManager.AppSettings["FTPCSVPath"].ToString();
        public static readonly String FTP_SERVER_XML_URL = System.Configuration.ConfigurationManager.AppSettings["FTPXMLPath"].ToString();
        //End Ram - Configuration dynamic

        public const String XCBL_DATABASE_SERVER_URL = "Server=edge.meridianww.com; DataBase = SYST010MeridianXCBLService; User Id = dev_connection; Password = Password88; Connection Timeout = 0";
        #endregion

        #region xCBL Message Acknowledgement Constants
        /**************************************************************************xCBL Message Acknowledge********************************************************************
         * 
         * Structure for Message Acknowledge xCBL response that is returned when calling SendScheduleMessage method
         * 
        **********************************************************************************************************************************************************************/
        public const String MESSAGE_ACKNOWLEDGEMENT_SUCCESS = "Success";
        public const String MESSAGE_ACKNOWLEDGEMENT_FAILURE = "Failure";

        public const String XML_HEADER = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
        public const String MESSAGE_ACKNOWLEDGEMENT_OPEN_TAG = "<MessageAcknowledgement xmlns:core=\"rrn:org.xcbl:schemas/xcbl/v4_0/core/core.xsd\" xmlns=\"rrn:org.xcbl:schemas/xcbl/v4_0/materialsmanagement/v1_0/materialsmanagement.xsd\">";
        public const String MESSAGE_ACKNOWLEDGEMENT_REFERENCE_NUMBER_OPEN_TAG = "<AcknowledgementReferenceNumber>";
        // Need to include Schedule ID value in AcknowledgementReferenceNumber Tag
        public const String MESSAGE_ACKNOWLEDGEMENT_REFERENCE_NUMBER_CLOSE_TAG = "</AcknowledgementReferenceNumber>";
        public const String MESSAGE_ACKNOWLEDGEMENT_NOTE_OPEN_TAG = "<AcknowledgementNote><Status>";
        // Need to include response value of Success or Failure in Status Tag
        public const String MESSAGE_ACKNOWLEDGEMENT_NOTE_CLOSE_TAG = "</Status></AcknowledgementNote>";
        public const String MESSAGE_ACKNOWLEDGEMENT_CLOSE_TAG = "</MessageAcknowledgement>";
        /*********************************************************************************************************************************************************************/
        #endregion

        #region xCBL Send Schedule Message Constants
        /**************************************************************************xCBL Shipping Schedule**********************************************************************
         * 
         * Structure for expected Shipping Schedule xCBL tags 
         * 
        **********************************************************************************************************************************************************************/
        public const String CSV_HEADER_NAMES = "ScheduleID,ScheduleIssuedDate,OrderNumber,SequenceNumber," +
                        "Other_FirstStop,Other_Before7,Other_Before9,Other_Before12,Other_SameDay,Other_OwnerOccupied,Other_7,Other_8,Other_9,Other_10,PurposeCoded,ScheduleType," +
                        "AgencyCoded,Name1,Street,Streetsupplement1,PostalCode,City,RegionCoded,ContactName,ContactNumber_1,ContactNumber_2,ContactNumber_3,ContactNumber_4,ContactNumber_5,ContactNumber_6,ShippingInstruction,"
                        + "GPSSystem,Latitude,Longitude,LocationID,EstimatedArrivalDate";
        public const String XCBL_CORE_NAMESPACE = "rrn:org.xcbl:schemas/xcbl/v4_0/core/core.xsd";
        public const String XCBL_SHIPPING_SCHEDULE_HEADER = "ShippingScheduleHeader";
        public const String XCBL_SCHEDULE_ID = "default:ScheduleID";
        public const String XCBL_PURPOSE = "purpose";
        public const String XCBL_SHIPPING_SCHEDULE_HEADER_ID = "ShippingScheduleHeader_ID";
        public const String XCBL_PURPOSE_CODED = "//default:Purpose/core:PurposeCoded";
        public const String XCBL_SCHEDULE_TYPE_CODED = "//default:ScheduleTypeCoded";
        public const String XCBL_SCHEDULE_TYPE_CODED_TEXT = "ScheduleTypeCoded_Text";
        public const String XCBL_SCHEDULE_REFERENCES = "//default:ScheduleReferences";
        public const String XCBL_PURCHASE_ORDER_REFERENCE = "default:PurchaseOrderReference";
        public const String XCBL_CONTACT_NUMBER = "contactNumber";
        public const String XCBL_LIST_OF_CONTACT_NUMBER_ID = "ListofContactNumber_ID";
        public const String XCBL_CONTACT_NUMBER_VALUE = "ContactNumberValue";
        public const String XCBL_OTHER_SCHEDULE_REFERENCES = "default:OtherScheduleReferences";
        public const String XCBL_REFERENCE_CODED = "ReferenceCoded";
        public const String XCBL_OTHER_SCHEDULE_REFERENCES_ID = "OtherScheduleReferences_ID";
        public const String XCBL_REFERENCE_DESCRIPTION = "ReferenceDescription";
        public const String XCBL_SELLER_ORDER_NUMBER = "SellerOrderNumber";
        public const String XCBL_CHANGE_ORDER_SEQUENCE_NUMBER = "ChangeOrderSequenceNumber";
        public const String XCBL_SCHEDULE_ISSUED_DATE = "default:ScheduleIssuedDate";
        public const String XCBL_AGENCY = "Agency";
        public const String XCBL_AGENCY_CODED = "//default:ScheduleParty/default:ShipToParty/core:PartyID/core:Agency/core:AgencyCoded";
        public const String XCBL_NAME_ADDRESS = "NameAddress";
        public const String XCBL_NAME = "//default:ScheduleParty/default:ShipToParty/core:NameAddress/core:Name1";
        public const String XCBL_STREET = "//default:ScheduleParty/default:ShipToParty/core:NameAddress/core:Street";
        public const String XCBL_STREET_SUPPLEMENT = "//default:ScheduleParty/default:ShipToParty/core:NameAddress/core:StreetSupplement1";
        public const String XCBL_POSTAL_CODE = "//default:ScheduleParty/default:ShipToParty/core:NameAddress/core:PostalCode";
        public const String XCBL_CITY = "//default:ScheduleParty/default:ShipToParty/core:NameAddress/core:City";
        public const String XCBL_REGION = "Region";
        public const String XCBL_REGION_CODED = "//default:ScheduleParty/default:ShipToParty/core:NameAddress/core:Region/core:RegionCoded";
        public const String XCBL_PRIMARY_CONTACT = "PrimaryContact";
        public const String XCBL_CONTACT_NAME = "//default:ScheduleParty/default:ShipToParty/core:PrimaryContact/core:ContactName";
        public const String XCBL_LIST_OF_CONTACT_NUMBERS = "//default:ScheduleParty/default:ShipToParty/core:PrimaryContact/core:ListOfContactNumber";
        public const String XCBL_CONTACT_VALUE = "ContactNumberValue";
        public const String XCBL_TRANSPORT_ROUTING = "TransportRouting";
        public const String XCBL_SHIPPING_INSTRUCTIONS = "//default:ListOfTransportRouting/core:TransportRouting/core:ShippingInstructions";
        public const String XCBL_GPS_COORDINATES = "GPSCoordinates";
        public const String XCBL_GPS_SYSTEM = "//default:ListOfTransportRouting/core:TransportRouting/core:TransportLocationList/core:EndTransportLocation/core:Location/core:GPSCoordinates/core:GPSSystem";
        public const String XCBL_LATITUDE = "//default:ListOfTransportRouting/core:TransportRouting/core:TransportLocationList/core:EndTransportLocation/core:Location/core:GPSCoordinates/core:Latitude";
        public const String XCBL_LONGITUDE = "//default:ListOfTransportRouting/core:TransportRouting/core:TransportLocationList/core:EndTransportLocation/core:Location/core:GPSCoordinates/core:Longitude";
        public const String XCBL_LOCATION = "Location";
        public const String XCBL_LOCATION_ID = "//default:ListOfTransportRouting/core:TransportRouting/core:TransportLocationList/core:EndTransportLocation/core:LocationID";
        public const String XCBL_END_TRANSPORT_LOCATION = "EndTransportLocation";
        public const String XCBL_ESTIMATED_ARRIVAL_DATE = "//default:ListOfTransportRouting/core:TransportRouting/core:TransportLocationList/core:EndTransportLocation/core:EstimatedArrivalDate";
        public const string XCBL_ShippingScheule_XML_Https = "tem1:SubmitDocument";
        public const string XCBL_ShippingScheule_XML_Http = "tem:SubmitDocument";
        /*********************************************************************************************************************************************************************/
        #endregion
    }
}