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
//Programmer:                                   Kirty Anurag
//Date Programmed:                              10/10/2017
//Program Name:                                 JobCargos
//Purpose:                                      End point to interact with Act Role module
//====================================================================================================================================================*/

using M4PL.API.Filters;
using M4PL.Business.Job;
using M4PL.Entities;
using M4PL.Entities.Job;
using M4PL.Entities.Support;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace M4PL.API.Controllers
{
   
    [CustomAuthorize]
    [RoutePrefix("api/JobCargos")]
    public class JobCargosController : ApiController
    {
        private readonly IJobCargoCommands _jobCargoCommands;

        /// <summary>
        /// Function to get Job's Cargo details
        /// </summary>
        /// <param name="jobCargoCommands"></param>
        public JobCargosController(IJobCargoCommands jobCargoCommands)
          
        {
            _jobCargoCommands = jobCargoCommands;
        }

        /// <summary>
        /// PagedData method is used to get limited recordset with Total count based on pagedDataInfo values.
        /// </summary>
        /// <param name="pagedDataInfo">
        /// This parameter require field values like PageNumber,PageSize,OrderBy,GroupBy,GroupByWhereCondition,WhereCondition,IsNext,IsEnd etc.
        /// </param>
        /// <returns>
        /// Returns response as queryable records list based on pagedDataInfo filter values with fields status ,result.
        /// </returns>
        [CustomQueryable]
        [HttpPost]
        [Route("PagedData")]
        public virtual IQueryable<JobCargo> PagedData(PagedDataInfo pagedDataInfo)
        {
            _jobCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCargoCommands.GetPagedData(pagedDataInfo).AsQueryable();
        }

        /// <summary>
        /// Get method gets the single record based on numeric Id parameter passed for the jobCargo.
        /// </summary>
        /// <param name="id">Refer to  Record Id as numeric value.</param>
        /// <returns>Returns response as single object.</returns>
        [HttpGet]
        //[Route("{id}")]
        public virtual JobCargo Get(long id)
        {
            _jobCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCargoCommands.Get(id);
        }

        /// <summary>
        /// Post method is used to add a new single record for new jobCargo object passed as parameter.
        /// </summary>
        /// <param name="jobCargo">Refers to jobCargo object to add.</param>
        /// <returns>Returns response as object newly added.</returns>
        [HttpPost]
        public virtual JobCargo Post(JobCargo jobCargo)
        {
            _jobCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCargoCommands.Post(jobCargo);
        }

        /// <summary>
        /// Put method is used to update record values completely based on jobCargo object passed.
        /// </summary>
        /// <param name="jobCargo">Refers to jobCargo object to update.</param>
        /// <returns>Returns updated single object.</returns>
        [HttpPut]
        public virtual JobCargo Put(JobCargo jobCargo)
        {
            _jobCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCargoCommands.Put(jobCargo);
        }

        /// <summary>
        /// Delete method is used to make a single record archive.
        /// </summary>
        /// <param name="id">Refers to numeric value of record to archive.</param>
        /// <returns>Returns response as numeric value.</returns>
        [HttpDelete]
        protected virtual int Delete(long id)
        {
            _jobCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCargoCommands.Delete(id);
        }

        /// <summary>
        /// DeleteList method is used to delete a multiple records for ids passed as comma seprated list of string.
        /// </summary>
        /// <param name="ids">Refers to comma seprated ids as string.</param>
        /// <param name="statusId">Refers to numeric value, It can have value 3 to make record archive.</param>
        /// <returns>Returns response as list of IdRefLangName objects.</returns>
        [HttpDelete]
        [Route("DeleteList")]
        public virtual IList<IdRefLangName> DeleteList(string ids, int statusId)
        {
            _jobCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCargoCommands.Delete(ids.Split(',').Select(long.Parse).ToList(), statusId);
        }

        /// <summary>
        /// Patch method is used to update partially or completely record values based on jobCargo object passed.
        /// </summary>
        /// <param name="jobCargo">Refers object to update.</param>
        /// <returns>Returns response as updated single object.</returns>
        [HttpPatch]
        public virtual JobCargo Patch(JobCargo jobCargo)
        {
            _jobCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCargoCommands.Patch(jobCargo);
        }
        /// <summary>
        /// CreateCargoException method creates a new cargo exception code, exception reason and install status for a particular Order/Job cargo.
        /// </summary>
        /// <param name="jobCargoException">
        /// This parameter require field values ExceptionCode(type string),ExceptionReason(type string), InstallStatus(type string), CargoQuantity(type integer), Optional parameter CgoReasonCodeOSD(type string) and Optional parameter CgoDateLastScan(type DateTime).
        /// </param>
        /// <param name="cargoId">Order/Job cargoId(type numeric).</param>
        /// <returns>
        /// Returns response as StatusModel object for newly created Cargo Exception.
        /// </returns>
        [CustomAuthorize]
        [HttpPost]
        [Route("CreateCargoException")]
        public StatusModel CreateCargoException(JobCargoException jobCargoException, long cargoId)
        {
            _jobCargoCommands.ActiveUser = Models.ApiContext.ActiveUser;
            return _jobCargoCommands.CreateCargoException(jobCargoException, cargoId);
        }
    }
}