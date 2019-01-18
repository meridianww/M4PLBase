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

        public void InitiateStartTimer(bool isFirstTimeCall = false)
        {
            var startTime = MeridianGlobalConstants.PBS_QUERY_START_TIME;
            var timeParts = startTime.Split(new char[1] { ':' });
            var dateNow = DateTime.Now;
            var date = new DateTime(dateNow.Year, dateNow.Month, dateNow.Day, int.Parse(timeParts[0]), int.Parse(timeParts[1]), 00);

            TimeSpan ts = (date > dateNow) ? (date - dateNow) : date.AddDays(1) - dateNow;
            serviceStartTimer.Interval = ts.TotalMilliseconds;
            serviceStartTimer.AutoReset = false;
            serviceStartTimer.Enabled = false;
            serviceStartTimer.Elapsed += ServiceStartTimer_Elapsed;
            serviceStartTimer.Start();

            if (isFirstTimeCall)
                ServiceStartTimer_Elapsed(null, null);
        }

        private void ServiceStartTimer_Elapsed(object sender, ElapsedEventArgs e)
        {
            StartFrequencyTimer();
            serviceStartTimer.Stop();
            InitiateStartTimer();
        }

        public void InitiateEndTimer()
        {
            var endTime = MeridianGlobalConstants.PBS_QUERY_END_TIME;
            endTime = !string.IsNullOrWhiteSpace(endTime) ? endTime : MeridianGlobalConstants.DEFAULT_PBS_QUERY_END_TIME;
            var timeParts = endTime.Split(new char[1] { ':' });
            var dateNow = DateTime.Now;
            var date = new DateTime(dateNow.Year, dateNow.Month, dateNow.Day, int.Parse(timeParts[0]), int.Parse(timeParts[1]), 00);

            TimeSpan ts = (date > dateNow) ? (date - dateNow) : date.AddDays(1) - dateNow;
            serviceEndTimer.Interval = ts.TotalMilliseconds;
            serviceEndTimer.AutoReset = false;
            serviceEndTimer.Enabled = false;
            serviceEndTimer.Elapsed += ServiceEndTimer_Elapsed;
            serviceEndTimer.Start();
        }

        private void ServiceEndTimer_Elapsed(object sender, ElapsedEventArgs e)
        {
            StopFrequencyTimer();
            serviceEndTimer.Stop();
            InitiateEndTimer();
        }

        public void StartFrequencyTimer()
        {
            if (!pbsFrequencyTimer.Enabled)
            {
                pbsFrequencyTimer.AutoReset = true;
                pbsFrequencyTimer.Enabled = false;
                pbsFrequencyTimer.Elapsed += new ElapsedEventHandler(GetAllOrder);
                pbsFrequencyTimer.Start();
                GetAllOrder(null, null);
            }
        }

        public void StopFrequencyTimer()
        {
            while (IsProcessing)
            {
                Thread.Sleep(500);
            }
            pbsFrequencyTimer.Stop();
        }

        private void GetAllOrder(object sender, ElapsedEventArgs e)
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