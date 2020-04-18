/*Copyright (2016) Meridian Worldwide Transportation Group
//All Rights Reserved Worldwide
//====================================================================================================================================================
//Program Title:                                Meridian 4th Party Logistics(M4PL)
//Programmer:                                   Kamal
//Date Programmed:                              04/18/2020
//Program Name:                                 JobSignature
//Purpose:                                      End point to interact with Signature module
//====================================================================================================================================================*/


using System.Web.Http;
using M4PL.Business.Signature;
using M4PL.Entities.Signature;

/// <summary>
/// Job Signature Controller
/// </summary>
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
        public bool InsertJobSignature(JobSignature jobSignature)
        {
            return _jobSignatureCommands.InsertJobSignature(jobSignature);
        }
    }
}
