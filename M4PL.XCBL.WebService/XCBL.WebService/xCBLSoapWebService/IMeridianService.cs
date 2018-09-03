//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian xCBL Web Service - AWC Timberlake
//Programmer:                                   Nathan Fujimoto
//Date Programmed:                              2/6/2016
//Program Name:                                 Meridian xCBL Web Service
//Purpose:                                      The web service uses XmlElement as the parameter for the method
//
//==================================================================================================================================================== 
using System.ServiceModel;
using System.Web.Services.Protocols;
using System.Xml.Linq;

namespace xCBLSoapWebService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract(Namespace = "http://tempuri.org")]
    public interface IMeridianService
    {
        [OperationContract]
        [SoapDocumentMethod(ParameterStyle = SoapParameterStyle.Bare)]
        XElement SubmitDocument();
    }

}
