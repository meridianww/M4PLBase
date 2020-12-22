using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace M4PL.Web.SignalR.Hubs
{
    public class JobNotifier
    {
        private JobNotifier(IHubConnectionContext<dynamic> clients)
        {
            Clients = clients;
        }
        private readonly static Lazy<JobNotifier> _instance = new Lazy<JobNotifier>(
            () => new JobNotifier(GlobalHost.ConnectionManager.GetHubContext<JobHub>().Clients));

        private IHubConnectionContext<dynamic> Clients
        {
            get;
            set;
        }
        public static JobNotifier Instance
        {
            get
            {
                return _instance.Value;
            }
        }
        public void BroadCastJobNotification(string jobId)
        {
            Clients.All.notifyJobForm(jobId);
        }
    }
}