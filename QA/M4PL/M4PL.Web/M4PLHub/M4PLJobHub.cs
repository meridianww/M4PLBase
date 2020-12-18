using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.SignalR;

namespace M4PL.Web.M4PLHub
{
    public class M4PLJobHub : Hub
    {
        public void SayHello(String message)
        {
            Clients.All.hello(message);
        }
    }
}