﻿/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Akhil
//Date Programmed:                              10/10/2017
//Program Name:                                 CustomerDocumentReference
//Purpose:                                      End point to interact with CustomerDocumentReference module
//====================================================================================================================================================*/

using M4PL.Business.Customer;
using M4PL.Entities.Customer;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    [RoutePrefix("api/CustDocReferences")]
    public class CustDocReferencesController : BaseApiController<CustDocReference>
    {
        private readonly ICustDocReferenceCommands _custDocReferenceCommands;

        /// <summary>
        /// Fucntion to get Customer's Document Reference details
        /// </summary>
        /// <param name="custDocReferenceCommands"></param>
        public CustDocReferencesController(ICustDocReferenceCommands custDocReferenceCommands)
            : base(custDocReferenceCommands)
        {
            _custDocReferenceCommands = custDocReferenceCommands;
        }
    }
}