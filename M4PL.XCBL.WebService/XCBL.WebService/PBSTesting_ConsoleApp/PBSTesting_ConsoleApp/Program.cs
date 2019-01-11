using System;
using System.Configuration;
using System.Linq;
using System.Threading;
using System.Net.Http;
using System.ServiceModel;

namespace PBSTesting_ConsoleApp
{
    class Program
    {
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
            var allOrderNumbers = ConfigurationManager.AppSettings["OrderNumbers"].Split(',');
            runByUser = ConfigurationManager.AppSettings["RunByUser"];
            delayInMilliSeconds = Convert.ToInt32(ConfigurationManager.AppSettings["DelayInMilliSeconds"].ToString());
            useServiceReference = Convert.ToBoolean(ConfigurationManager.AppSettings["UseServiceReference"].ToString());
            var totalFailures = CallPBSServiceAndUpdateFile(allOrderNumbers);
            Console.ReadLine();
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
