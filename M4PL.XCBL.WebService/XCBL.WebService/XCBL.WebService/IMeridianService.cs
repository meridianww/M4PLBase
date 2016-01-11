using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.Xml;

namespace XCBL.WebService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface IMeridianService
    {
        [OperationContract]
        string Meridian_SendScheduleMessage(XCBLService xmldoc);

        [OperationContract]
        XCBLService Meridian_EncrpytCredentials(ref XCBLService xmldoc);
        // TODO: Add your service operations here
    }
    

    [DataContract]
    public class XCBLService
    {
        [DataMember]
        public byte[] XmlDocument { get; set; }

        [DataMember]
        public string Username { get; set; }
        
        [DataMember]
        public string Password { get; set; }

        [DataMember]
        public string HashKey { get; set; }

    }
}
