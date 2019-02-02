using System;
using System.Configuration;
using System.Linq;
using System.Threading;
using System.Net.Http;
using System.ServiceModel;
using System.Collections.Generic;
using System.Text;
using System.Xml;

namespace PBSTesting_ConsoleApp
{
    class Program
    {
        public Dictionary<string, PBSData> AllPBSOrder = new Dictionary<string, PBSData>();
        static string destinationName = null;
        static string orderNumber = null;
        static string destinationStreet = null;
        static string destinationStreetSupplement1 = null;
        static string destinationPostalCode = null;
        static string destinationCity = null;
        static string destinationRegionCoded = null;
        static string scheduledShipmentDateInString = null;
        static string scheduledDeliveryDateInString = null;
        static int delayInMilliSeconds = 0;
        static bool useServiceReference = true;
        static string runByUser = string.Empty;
        static PBS_ServiceReference.Service1Soap soapClient = new PBS_ServiceReference.Service1SoapClient("Service1Soap");

        static void Main(string[] args)
        {
            if (ConfigurationManager.AppSettings["CheckAWCCall"].Equals("1", StringComparison.OrdinalIgnoreCase))
            {
                using (var client = new System.Net.WebClient())
                {
                    var data = CreateShippingScheduleResponse();
                    var requestData = Encoding.ASCII.GetBytes(data);
                    client.Headers.Add("Content-Type", "text/xml;charset=utf-8");
                    client.Headers.Add("SOAPAction", "ShippingScheduleResponseProcess");
                    try
                    {
                        var responseData = client.UploadData("https://biztalkprod.woodmark.com/Maestro/WcfService_Maestro.svc", requestData);
                        var response = Encoding.ASCII.GetString(responseData);
                    }
                    catch (Exception ex)
                    {

                    }
                    finally
                    {
                        client.Dispose();
                    }
                }
            }
            else
            {
                Console.BackgroundColor = ConsoleColor.Black;
                var prgObject = new Program();
                prgObject.CallPBSAndUpdateVariable();
                if (prgObject.AllPBSOrder.Count > 0)
                {
                    do
                    {
                        Console.BackgroundColor = ConsoleColor.Black;
                        Console.WriteLine("Please enter 'n' If you want to stop order search or 'y' if you want to continue");
                        var currentInput = Console.ReadLine();
                        if (currentInput.Trim() == "n")
                        {
                            break;
                        }
                        else
                        {
                            prgObject.GetOrderFromCachedResult(prgObject);
                        }
                    } while (true);
                }
                else
                {
                    Console.BackgroundColor = ConsoleColor.Red;
                    Console.ForegroundColor = ConsoleColor.White;
                    Console.WriteLine("NO ORDERS IN CACHE");
                }
            }
        }

        internal static string CreateShippingScheduleResponse()
        {
            try
            {
                var shippingScheduleResponseGUID = Guid.NewGuid().ToString();
                StringBuilder request = new StringBuilder();

                request.Append("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
                request.Append("<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns=\"rrn:org.xcbl:schemas/xcbl/v4_0/materialsmanagement/v1_0/materialsmanagement.xsd\" xmlns:core=\"rrn:org.xcbl:schemas/xcbl/v4_0/core/core.xsd\">");
                request.Append("<soapenv:Header>");
                request.Append("<Credentials>");
                request.Append("<UserName>");
                request.Append("3b9SNVmfSlme4A00+AZ+Cg==");
                request.Append("</UserName>");
                request.Append("<Password>");
                request.Append("u91I8BcvlOOfDTt7ocx1Cg==");
                request.Append("</Password>");
                request.Append("<Hashkey>");
                request.Append("XcblWebServiceMERIDNow");
                request.Append("</Hashkey>");
                request.Append("</Credentials>");
                request.Append("</soapenv:Header>");
                request.Append("<soapenv:Body>");
                request.Append("<ShippingScheduleResponse>");
                request.Append("<ShippingScheduleResponseHeader>");
                request.Append("<ScheduleResponseID>");
                request.Append(shippingScheduleResponseGUID);
                request.Append("</ScheduleResponseID>");
                request.Append("<ScheduleResponseIssueDate>");
                request.Append(DateTime.Now.ToString("yyyy-MM-ddTHH:mm:ss.fff"));
                request.Append("</ScheduleResponseIssueDate>");
                request.Append("<ShippingScheduleReference>");
                request.Append("<core:RefNum>");
                request.Append(ConfigurationManager.AppSettings["OrderNumber"]);
                request.Append("</core:RefNum>");
                request.Append("</ShippingScheduleReference>");
                request.Append("<Purpose>");
                request.Append("<core:PurposeCoded>");
                request.Append("Confirmation");
                request.Append("</core:PurposeCoded>");
                request.Append("</Purpose>");
                request.Append("<ResponseType>");
                request.Append("<core:ResponseTypeCoded>");
                request.Append("Accepted");
                request.Append("</core:ResponseTypeCoded>");
                request.Append("</ResponseType>");
                request.Append("<ShippingScheduleHeader>");
                request.Append(MyData());
                request.Append("</ShippingScheduleHeader>");
                request.Append("</ShippingScheduleResponseHeader>");
                request.Append("</ShippingScheduleResponse>");
                request.Append("</soapenv:Body>");
                request.Append("</soapenv:Envelope>");

                var currentXmlDocument = new XmlDocument();
                currentXmlDocument.LoadXml(request.ToString());
                return request.ToString();
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        public static string MyData()
        {
            var str = new StringBuilder();
            str.Append("          <ScheduleID>E7A32636-4C0F-459B-8539-3DA4A42AB5C6</ScheduleID>");
            str.Append("          <ScheduleIssuedDate>2019-01-09T07:56:03.71</ScheduleIssuedDate>");
            str.Append("          <ScheduleReferences>");
            str.Append("            <PurchaseOrderReference>");
            str.Append("              <core:SellerOrderNumber>R3 15827530</core:SellerOrderNumber>");
            str.Append("              <core:ChangeOrderSequenceNumber>0</core:ChangeOrderSequenceNumber>");
            str.Append("            </PurchaseOrderReference>");
            str.Append("            <OtherScheduleReferences>");
            str.Append("              <core:ReferenceCoded>");
            str.Append("                <core:ReferenceTypeCoded>Other</core:ReferenceTypeCoded>");
            str.Append("                <core:ReferenceTypeCodedOther>FirstStop</core:ReferenceTypeCodedOther>");
            str.Append("                <core:ReferenceDescription>N</core:ReferenceDescription>");
            str.Append("              </core:ReferenceCoded>");
            str.Append("              <core:ReferenceCoded>");
            str.Append("                <core:ReferenceTypeCoded>Other</core:ReferenceTypeCoded>");
            str.Append("                <core:ReferenceTypeCodedOther>Before7</core:ReferenceTypeCodedOther>");
            str.Append("                <core:ReferenceDescription>N</core:ReferenceDescription>");
            str.Append("              </core:ReferenceCoded>");
            str.Append("              <core:ReferenceCoded>");
            str.Append("                <core:ReferenceTypeCoded>Other</core:ReferenceTypeCoded>");
            str.Append("                <core:ReferenceTypeCodedOther>Before9</core:ReferenceTypeCodedOther>");
            str.Append("                <core:ReferenceDescription>N</core:ReferenceDescription>");
            str.Append("              </core:ReferenceCoded>");
            str.Append("              <core:ReferenceCoded>");
            str.Append("                <core:ReferenceTypeCoded>Other</core:ReferenceTypeCoded>");
            str.Append("                <core:ReferenceTypeCodedOther>Before12</core:ReferenceTypeCodedOther>");
            str.Append("                <core:ReferenceDescription>N</core:ReferenceDescription>");
            str.Append("              </core:ReferenceCoded>");
            str.Append("              <core:ReferenceCoded>");
            str.Append("                <core:ReferenceTypeCoded>Other</core:ReferenceTypeCoded>");
            str.Append("                <core:ReferenceTypeCodedOther>SameDay</core:ReferenceTypeCodedOther>");
            str.Append("                <core:ReferenceDescription>N</core:ReferenceDescription>");
            str.Append("              </core:ReferenceCoded>");
            str.Append("              <core:ReferenceCoded>");
            str.Append("                <core:ReferenceTypeCoded>Other</core:ReferenceTypeCoded>");
            str.Append("                <core:ReferenceTypeCodedOther>HomeOwnerOccupied</core:ReferenceTypeCodedOther>");
            str.Append("                <core:ReferenceDescription>N</core:ReferenceDescription>");
            str.Append("              </core:ReferenceCoded>");
            str.Append("              <core:ReferenceCoded>");
            str.Append("                <core:ReferenceTypeCoded>Other</core:ReferenceTypeCoded>");
            str.Append("                <core:ReferenceTypeCodedOther>WorkOrderNumber</core:ReferenceTypeCodedOther>");
            str.Append("                <core:ReferenceDescription>1325879</core:ReferenceDescription>");
            str.Append("              </core:ReferenceCoded>");
            str.Append("              <core:ReferenceCoded>");
            str.Append("                <core:ReferenceTypeCoded>Other</core:ReferenceTypeCoded>");
            str.Append("                <core:ReferenceTypeCodedOther>SSID</core:ReferenceTypeCodedOther>");
            str.Append("                <core:ReferenceDescription>63539</core:ReferenceDescription>");
            str.Append("              </core:ReferenceCoded>");
            str.Append("            </OtherScheduleReferences>");
            str.Append("          </ScheduleReferences>");
            str.Append("          <ReleaseNumber>MER</ReleaseNumber>");
            str.Append("          <Purpose>");
            str.Append("            <core:PurposeCoded>Original</core:PurposeCoded>");
            str.Append("          </Purpose>");
            str.Append("          <ScheduleTypeCoded>DeliveryBased</ScheduleTypeCoded>");
            str.Append("          <ScheduleParty>");
            str.Append("            <ShipToParty>");
            str.Append("              <core:PartyID>");
            str.Append("                <core:Agency>");
            str.Append("                  <core:AgencyCoded>AssignedByMarketPlace</core:AgencyCoded>");
            str.Append("                </core:Agency>");
            str.Append("                <core:Ident>5EBCA679-0FB0-40AD-B1E1-39A67A0BDB7B</core:Ident>");
            str.Append("              </core:PartyID>");
            str.Append("              <core:NameAddress>");
            str.Append("                <core:Name1>Adams Homes - Lakeview</core:Name1>");
            str.Append("                <core:Street>2194 MIRANDA DR LOT 4</core:Street>");
            str.Append("                <core:StreetSupplement1>Lakeview</core:StreetSupplement1>");
            str.Append("                <core:PostalCode>30260</core:PostalCode>");
            str.Append("                <core:City>MORROW</core:City>");
            str.Append("                <core:Region>");
            str.Append("                  <core:RegionCoded>USGA</core:RegionCoded>");
            str.Append("                </core:Region>");
            str.Append("              </core:NameAddress>");
            str.Append("              <core:PrimaryContact>");
            str.Append("                <core:ContactName>CHulsey</core:ContactName>");
            str.Append("                <core:ListOfContactNumber>");
            str.Append("                  <core:ContactNumber>");
            str.Append("                    <core:ContactNumberValue>000-000-0000</core:ContactNumberValue>");
            str.Append("                    <core:ContactNumberTypeCoded>TelephoneNumber</core:ContactNumberTypeCoded>");
            str.Append("                  </core:ContactNumber>");
            str.Append("                </core:ListOfContactNumber>");
            str.Append("              </core:PrimaryContact>");
            str.Append("            </ShipToParty>");
            str.Append("          </ScheduleParty>");
            str.Append("          <ListOfTransportRouting>");
            str.Append("            <core:TransportRouting>");
            str.Append("              <core:ShippingInstructions>Townhome community</core:ShippingInstructions>");
            str.Append("              <core:TransportLocationList>");
            str.Append("                <core:EndTransportLocation>");
            str.Append("                  <core:Location>");
            str.Append("                    <core:GPSCoordinates>");
            str.Append("                      <core:GPSSystem>Timberlake Connect</core:GPSSystem>");
            str.Append("                      <core:Latitude>33.61106109619140</core:Latitude>");
            str.Append("                      <core:Longitude>-84.3174819946289</core:Longitude>");
            str.Append("                    </core:GPSCoordinates>");
            str.Append("                  </core:Location>");
            str.Append("                  <core:LocationID>0</core:LocationID>");
            str.Append("                  <core:EstimatedArrivalDate>2019-01-25T00:00:00</core:EstimatedArrivalDate>");
            str.Append("                </core:EndTransportLocation>");
            str.Append("              </core:TransportLocationList>");
            str.Append("            </core:TransportRouting>");
            str.Append("          </ListOfTransportRouting>");
            return str.ToString();
        }

        private void GetOrderFromCachedResult(Program prgObject)
        {
            Console.BackgroundColor = ConsoleColor.Black;
            Console.WriteLine("Please Enter Order Number To Check");
            var currentOrderNumber = Console.ReadLine();
            if (prgObject.AllPBSOrder.ContainsKey(currentOrderNumber.Trim()))
            {
                Console.BackgroundColor = ConsoleColor.Green;
                Console.ForegroundColor = ConsoleColor.White;
                Console.WriteLine("ORDER {0} IS AVAILABLE IN CACHE", currentOrderNumber);
            }
            else
            {
                Console.BackgroundColor = ConsoleColor.Red;
                Console.ForegroundColor = ConsoleColor.White;
                Console.WriteLine("ORDER {0} IS NOT AVAILABLE IN CACHE", currentOrderNumber);
            }
        }

        private void CallPBSAndUpdateVariable()
        {
            AllPBSOrder = new Dictionary<string, PBSData>();
            using (HttpClient client = new HttpClient())
            {
                var sqlQuery = string.Format("http://70.96.86.243/VOCWS/Service1.asmx/SQLtoCSV_File?strSQL={0}&User=vocnew&Password=vocnf", "SELECT+*+FROM+vwXCBL+WHERE+ShprNo='AWC'");
                var res = client.GetAsync(sqlQuery).Result;
                var resultString = client.GetStringAsync("http://70.96.86.243/voc/voc.txt").Result;
                if (!string.IsNullOrWhiteSpace(resultString))
                {
                    var lines = resultString.Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.None);
                    if (lines.Count() > 1)
                    {

                        for (int i = 1; i < lines.Length; i++)
                        {
                            if (!string.IsNullOrWhiteSpace(lines[i]))
                            {
                                var values = lines[i].Split(',');
                                if (values.Length > 29)
                                {
                                    DateTimeOffset deliveryDate;
                                    if (DateTimeOffset.TryParse(values[1], out deliveryDate))
                                    {
                                        PBSData pbsData = new PBSData();
                                        pbsData.DeliveryDate = values[1];
                                        pbsData.ShipmentDate = values[2];
                                        pbsData.IsScheduled = values[3];
                                        pbsData.OrderNumber = values[11];
                                        pbsData.DestinationName = values[25];
                                        pbsData.DestinationStreet = values[26];
                                        pbsData.DestinationStreetSupplyment1 = values[27];
                                        pbsData.DestinationCity = values[28];
                                        pbsData.DestinationRegionCoded = string.Format("US" + values[29]);
                                        pbsData.DestinationPostalCode = values[30];

                                        if (!AllPBSOrder.ContainsKey(pbsData.OrderNumber))
                                            AllPBSOrder.Add(pbsData.OrderNumber, pbsData);
                                    }
                                }
                                else
                                {
                                    Console.BackgroundColor = ConsoleColor.Red;
                                    Console.ForegroundColor = ConsoleColor.White;
                                    Console.WriteLine("VALUES LENGTH LESS THEN 29");
                                }
                            }
                        }
                    }
                    else
                    {
                        Console.BackgroundColor = ConsoleColor.Red;
                        Console.ForegroundColor = ConsoleColor.White;
                        Console.WriteLine("LINE NUMBER IS LESS THEN 2");
                    }
                }
                else
                {
                    Console.BackgroundColor = ConsoleColor.Red;
                    Console.ForegroundColor = ConsoleColor.White;
                    Console.WriteLine("FAILURE EMPTY RESULT.");
                }
            }
        }

        private static int CallPBSServiceAndUpdateFile(string[] allOrderNumbers)
        {
            int totalSuccess = 0;
            int totalFailure = 0;
            int totalException = 0;

            using (HttpClient client = new HttpClient())
            {
                foreach (string sOrderNumber in allOrderNumbers)
                {
                    //Calling the PBS service with valid data to fetch fresh record
                    Console.BackgroundColor = ConsoleColor.Black;
                    Console.WriteLine(string.Format("   Making call to PBS for OrderNumber: {0}", sOrderNumber));
                    var sqlQuery = string.Format("SELECT+*+FROM+vwXCBL+WHERE+ShprNo='AWC'+AND+HbNo='{0}'", sOrderNumber);
                    var sqltoCSV_FileUrl = string.Format("http://70.96.86.243/VOCWS/Service1.asmx/SQLtoCSV_File?strSQL={0}&User=vocnew&Password=vocnf", sqlQuery);
                    try
                    {
                        if (useServiceReference)
                        {
                            var queryWithAuth = string.Format("strSQL={0}&User=vocnew&Password=vocnf", sqlQuery);
                            var res = soapClient.SQLtoCSV_File(sqlQuery, "vocnew", "vocnf");
                        }
                        else
                        {
                            var res = client.GetAsync(sqltoCSV_FileUrl).Result;
                        }
                        if (delayInMilliSeconds > 0)
                            Thread.Sleep(delayInMilliSeconds);
                        CallPBSService(ref totalSuccess, ref totalFailure, ref totalException, sOrderNumber);
                    }
                    catch (Exception ex)
                    {
                        totalException += 1;
                        Console.BackgroundColor = ConsoleColor.DarkYellow;
                        Console.ForegroundColor = ConsoleColor.White;
                        Console.WriteLine(string.Format("   {2} : Exception by SQLtoCSV_File for  order number {0} is - {1}", sOrderNumber, ex.Message, totalException));
                    }
                }
            }

            Console.BackgroundColor = ConsoleColor.Black;
            Console.WriteLine();
            Console.WriteLine();
            Console.WriteLine("Final Results -----");
            Console.BackgroundColor = ConsoleColor.DarkGreen;
            Console.ForegroundColor = ConsoleColor.White;
            Console.WriteLine(string.Format("   For User: {0}, TOTAL SUCCESS:{1} OUT OF {2}", runByUser, totalSuccess, allOrderNumbers.Length));
            Console.BackgroundColor = ConsoleColor.DarkRed;
            Console.ForegroundColor = ConsoleColor.White;
            Console.WriteLine(string.Format("   For User: {0}, TOTAL FAILURE:{1}  OUT OF {2} ", runByUser, totalFailure, allOrderNumbers.Length));
            Console.BackgroundColor = ConsoleColor.DarkYellow;
            Console.ForegroundColor = ConsoleColor.White;
            Console.WriteLine(string.Format("   For User: {0}, TOTAL Exceptions:{1} ", runByUser, totalException));

            return totalFailure + totalException;
        }

        private static void CallPBSService(ref int totalSuccess, ref int totalFailure, ref int totalException, string currentOrderNumber)
        {
            try
            {
                destinationName = string.Empty;
                orderNumber = string.Empty;
                destinationStreet = string.Empty;
                destinationStreetSupplement1 = string.Empty;
                destinationPostalCode = string.Empty;
                destinationCity = string.Empty;
                destinationRegionCoded = string.Empty;
                scheduledShipmentDateInString = string.Empty;
                scheduledDeliveryDateInString = string.Empty;


                using (HttpClient client2 = new HttpClient())
                {
                    var result = client2.GetStringAsync("http://70.96.86.243/voc/voc.txt").Result;

                    /* Below code will use after getting data from WebService */
                    //Parse the stream
                    if (!string.IsNullOrWhiteSpace(result))
                    {
                        var lines = result.Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.None);

                        if (lines.Count() > 1)
                        {
                            var values = lines[1].Split(',');
                            if (values.Length > 29)//Since taking 30 last index
                            {
                                scheduledDeliveryDateInString = values[1];
                                scheduledShipmentDateInString = values[2];
                                orderNumber = values[11];
                                destinationName = values[25];
                                destinationStreet = values[26];
                                destinationStreetSupplement1 = values[27];
                                destinationCity = values[28];
                                destinationRegionCoded = string.Format("US" + values[29]);
                                destinationPostalCode = values[30];

                                if (!string.IsNullOrWhiteSpace(orderNumber) && currentOrderNumber.Equals(orderNumber.Trim(), StringComparison.OrdinalIgnoreCase))
                                {
                                    totalSuccess += 1;
                                    Console.BackgroundColor = ConsoleColor.Green;
                                    Console.ForegroundColor = ConsoleColor.White;
                                    Console.WriteLine(string.Format("   {1} : SUCCESS PBS Service Call for Order Number {0} ", currentOrderNumber, totalSuccess));
                                }
                                else
                                {
                                    totalFailure += 1;
                                    Console.BackgroundColor = ConsoleColor.Red;
                                    Console.ForegroundColor = ConsoleColor.White;
                                    Console.WriteLine(string.Format("   {1} : FAILURE ORDER NUMBER NOT MATCHED {0} with and VOC.txt File {2}.", currentOrderNumber, totalFailure, orderNumber));

                                }

                            }
                            else
                            {
                                totalFailure += 1;
                                Console.BackgroundColor = ConsoleColor.DarkBlue;
                                Console.ForegroundColor = ConsoleColor.White;
                                Console.WriteLine(string.Format("   {1} : FAILURE LENGTH < 30 for order number {0}", currentOrderNumber, totalFailure));
                            }

                        }
                        else
                        {
                            totalFailure += 1;
                            Console.BackgroundColor = ConsoleColor.Blue;
                            Console.ForegroundColor = ConsoleColor.White;
                            Console.WriteLine(string.Format("   {1} : FAILURE Line Count < 2 for Order Number {0} .", currentOrderNumber, totalFailure));
                        }

                    }
                    else
                    {
                        totalFailure += 1;
                        Console.BackgroundColor = ConsoleColor.Red;
                        Console.ForegroundColor = ConsoleColor.White;
                        Console.WriteLine(string.Format("   {1} : FAILURE EMPTY RESULT for Order Number {0} .", currentOrderNumber, totalFailure));
                    }
                }


            }
            catch (Exception ex)
            {
                totalException += 1;
                Console.BackgroundColor = ConsoleColor.DarkYellow;
                Console.ForegroundColor = ConsoleColor.White;
                Console.WriteLine(string.Format("   {2} : Exception for Order Number {0} is - {1}", currentOrderNumber, ex.Message, totalException));
            }
        }
    }
}
