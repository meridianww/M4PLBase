using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;

namespace M4PL.Web.SignalR.Hubs
{
    [HubName("jobNotifier")]
    public class JobHub : Hub
    {
        private readonly JobNotifier _jobNotifier;
        public JobHub():this(JobNotifier.Instance)
        {

        }
        public JobHub(JobNotifier jobNotifier)
        {
            _jobNotifier = jobNotifier;
        }
        public void Hello()
        {
            Clients.All.hello();
        }
        public void notify(string jobId, string client)
        {
            _jobNotifier.BroadCastJobNotification(jobId, client);
        }
    }
}