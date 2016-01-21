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
        void Meridian_EncrpytCredentials(ref XCBLService xmldoc);
        // TODO: Add your service operations here
    }
    

    [DataContract]
    public class XCBLService
    {
        /// <summary>
        /// string - XCBl data uploaded by the client
        /// </summary>
        [DataMember]      
        public string XCBLDocument { get; set; }

        /// <summary>
        ///string - Xcbl File name 
        /// </summary>
        [DataMember]
        public string XCBL_FileName { get; set; }

        /// <summary>
        ///Object - Xcbl user objects 
        /// </summary>
        [DataMember]
        public XCBL_User XCBLUser { get; set; }


    }



    #region XCBL_User Class
    /// <summary>
    /// The XCBL_User class is an class object to store the authentication credentials retrieve from MER000Authentication table and used throughout the project for transaction logging
    /// </summary>
    [DataContract]
    public class XCBL_User
    {
        /// <summary>
        /// The xCBL Web Service Username 
        /// </summary>
        [DataMember]
        public String WebUsername { get; set; }

        /// <summary>
        /// The xCBL Web Service Password
        /// </summary>
        [DataMember]
        public String WebPassword { get; set; }        

        /// <summary>
        /// The xCBL Web Service Hashkey for the User
        /// </summary>
        [DataMember]
        public String Hashkey { get; set; }

        /// <summary>
        /// The FTP Username to upload CSV files
        /// </summary>
        [DataMember]
        public String FtpUsername { get; set; }

        /// <summary>
        /// The FTP Password to upload CSV files
        /// </summary>
        [DataMember]
        public String FtpPassword { get; set; }

        /// <summary>
        /// The FTP Server URL
        /// </summary>
        [DataMember]
        public String FtpServerUrl { get; set; }

        /// <summary>
        /// The Contact Name for the Web Service to contact if an issue is encountered
        /// </summary>
        [DataMember]
        public String WebContactName { get; set; }

        /// <summary>
        /// The Company name of the Contact 
        /// </summary>
        [DataMember]
        public String WebContactCompany { get; set; }

        /// <summary>
        /// The Email address of the Contact
        /// </summary>
        [DataMember]
        public String WebContactEmail { get; set; }

        /// <summary>
        /// The first Phone Number option of the Contact
        /// </summary>
        [DataMember]
        public String WebContactPhone1 { get; set; }

        /// <summary>
        /// The second Phone Number option of the contact
        /// </summary>
        [DataMember]
        public String WebContactPhone2 { get; set; }

        /// <summary>
        /// If the user record is enabled or disabled
        /// </summary>
        [DataMember]
        public Boolean Enabled { get; set; }

    }
    #endregion
}
