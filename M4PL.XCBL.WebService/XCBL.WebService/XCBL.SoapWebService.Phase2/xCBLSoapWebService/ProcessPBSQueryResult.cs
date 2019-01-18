using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Timers;
using System.Web;

namespace xCBLSoapWebService
{
    public class ProcessPBSQueryResult
    {
        private static readonly object padLock = new object();

        private static ProcessPBSQueryResult instance = null;

        public Dictionary<string, PBSData> AllPBSOrder = new Dictionary<string, PBSData>();

        private static System.Timers.Timer pbsFrequencyTimer = new System.Timers.Timer(TimeSpan.FromMinutes(MeridianGlobalConstants.PBS_QUERY_FREQUENCY).TotalMilliseconds);

        private static System.Timers.Timer serviceStartTimer = new System.Timers.Timer();

        private static System.Timers.Timer serviceEndTimer = new System.Timers.Timer();

        private static bool IsProcessing = false;

        ProcessPBSQueryResult()
        {

        }

        //It will give instance of ProcessPBSQueryResult and if Processing 
        //is going on(to fetch data from service and fill to 'AllPBSOrder')
        //then it will make caller wait for process to be finished.
        public static ProcessPBSQueryResult Instance
        {
            get
            {
                lock (padLock)
                {
                    if (instance == null)
                        instance = new ProcessPBSQueryResult();

                    while (IsProcessing)
                    {
                        Thread.Sleep(500);
                    }

                    return instance;
                }
            }
        }

        public void InitiateFrequencyTimer()
        {
            pbsFrequencyTimer.AutoReset = true;
            pbsFrequencyTimer.Enabled = false;
            pbsFrequencyTimer.Elapsed += PbsFrequencyTimer_Elapsed;
            pbsFrequencyTimer.Start();
            GetAllOrder();
        }

        private void PbsFrequencyTimer_Elapsed(object sender, ElapsedEventArgs e)
        {
            var dateNow = DateTime.Now;
            var startTime = MeridianGlobalConstants.PBS_QUERY_START_TIME;
            var startTimeParts = startTime.Split(new char[1] { ':' });
            var startDateTime = new DateTime(dateNow.Year, dateNow.Month, dateNow.Day, int.Parse(startTimeParts[0]), int.Parse(startTimeParts[1]), 00);

            var endTime = MeridianGlobalConstants.PBS_QUERY_END_TIME;
            endTime = !string.IsNullOrWhiteSpace(endTime) ? endTime : MeridianGlobalConstants.DEFAULT_PBS_QUERY_END_TIME;
            var endTimeParts = endTime.Split(new char[1] { ':' });
            var endDateTime = new DateTime(dateNow.Year, dateNow.Month, dateNow.Day, int.Parse(endTimeParts[0]), int.Parse(endTimeParts[1]), 00);

            if ((dateNow >= startDateTime) && (dateNow <= endDateTime))
            {
                GetAllOrder();
            }
        }

        private void GetAllOrder()
        {
            IsProcessing = true;
            AllPBSOrder = new Dictionary<string, PBSData>();
            using (HttpClient client = new HttpClient())
            {
                var sqlQuery = string.Format(MeridianGlobalConstants.PBS_WEB_SERVICE, MeridianGlobalConstants.PBS_WEB_SERVICE_QUERY, MeridianGlobalConstants.CONFIG_PBS_WEB_SERVICE_USER_NAME, MeridianGlobalConstants.CONFIG_PBS_WEB_SERVICE_PASSWORD);
                var res = client.GetAsync(sqlQuery).Result;
                var resultString = client.GetStringAsync(MeridianGlobalConstants.PBS_OUTPUT_FILE).Result;
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
                                        pbsData.DestinationRegionCoded = string.Format(MeridianGlobalConstants.XCBL_US_CODE + values[29]);
                                        pbsData.DestinationPostalCode = values[30];

                                        if (!AllPBSOrder.ContainsKey(pbsData.OrderNumber))
                                            AllPBSOrder.Add(pbsData.OrderNumber, pbsData);
                                    }
                                }
                                else
                                {
                                    MeridianSystemLibrary.LogTransaction(null, null, "GetAllOrder", "02.25", "Warning - Values lenght less then 29", "Warning - Values lenght less then 29 from PBS WebService", null, null, null, null, "Warning 02.25 : Values lenght less then 29");
                                }
                            }
                        }
                    }
                    else
                    {
                        MeridianSystemLibrary.LogTransaction(null, null, "GetAllOrder", "02.26", "Warning - PBS File Lines Count < 2", "Warning - PBS File Lines Count < 2 from PBS WebService", null, null, null, null, "Warning 02.26 : PBS File Lines Count < 2");
                    }
                }
                else
                {
                    MeridianSystemLibrary.LogTransaction(null, null, "GetAllOrder", "02.27", "Warning - Empty PBS text file", "Warning - Empty PBS text file from PBS WebService", null, null, null, null, "Warning 02.27 : Empty Text File");
                }
            }
            IsProcessing = false;
        }
    }
}