using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;
using Microsoft.AspNet.SignalR.Hubs;

namespace M4PL.API.SignalR.Hubs
{
    [HubName("jobNotifier")]
    public class JobHub : Hub
    {
        public void Hello()
        {
            Clients.All.hello();
        }
        public void notify(string jobId,string client)
        {
            Clients.All.notifyJobForm(jobId,client);
        }
    }
}