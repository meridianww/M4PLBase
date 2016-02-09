﻿//Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian xCBL Web Service - AWC Timberlake
//Programmer:                                   Nathan Fujimoto
//Date Programmed:                              2/6/2016
//Program Name:                                 Meridian xCBL Web Service
//Purpose:                                      The web service uses XmlElement as the parameter for the method
//
//==================================================================================================================================================== 
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.Web.Services.Description;
using System.Web.Services.Protocols;
using System.Xml;
using System.Xml.Linq;

namespace xCBLSoapWebService
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface IMeridianService
    {
        [OperationContract]
        [SoapDocumentMethod(ParameterStyle = SoapParameterStyle.Bare)]
        XElement SubmitDocument(XmlElement ShippingSchedule);
    }

}
