#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved. 
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group. 
******************************************************************************/
#endregion Copyright



//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kamal
//Date Programmed:                              04/18/2020
//Program Name:                                 JobSignature
//Purpose:                                      End point to interact with Signature module
//====================================================================================================================================================*/


using M4PL.Business.Signature;
using M4PL.Entities.Signature;
using System.Web.Http;

namespace M4PL.API.Controllers
{
    /// <summary>
    /// JobSignatureController
    /// </summary>
    [AllowAnonymous]
    [RoutePrefix("api/Signature")]
    public class JobSignatureController : BaseApiController<JobSignature>
    {
        /// <summary>
        /// Field to assign
        /// </summary>
        public readonly IJobSignatureCommands _jobSignatureCommands;

        /// <summary>
        /// constructor
        /// </summary>
        /// <param name="jobSignatureCommands"></param>
        public JobSignatureController(IJobSignatureCommands jobSignatureCommands) : base(jobSignatureCommands)
        {
            _jobSignatureCommands = jobSignatureCommands;
        }

        /// <summary>
        /// Insert job signature
        /// </summary>
        /// <param name="jobSignature"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("jobSignature")]
        public bool InsertJobSignature(JobSignature jobSignature)
        {
            return _jobSignatureCommands.InsertJobSignature(jobSignature);
        }
    }
}
