﻿/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 CustContactCommands
Purpose:                                      Contains commands to call DAL logic for M4PL.DAL.Customer.CustContactCommands
===================================================================================================================*/

using M4PL.Entities.Customer;
using M4PL.Entities.Support;
using System;
using System.Collections.Generic;
using _commands = M4PL.DataAccess.Customer.CustContactCommands;

namespace M4PL.Business.Customer
{
    public class CustContactCommands : BaseCommands<CustContact>, ICustContactCommands
    {
        /// <summary>
        /// Get list of customer contacts data
        /// </summary>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public IList<CustContact> GetPagedData(PagedDataInfo pagedDataInfo)
        {
            return _commands.GetPagedData(ActiveUser, pagedDataInfo);
        }

        /// <summary>
        /// Gets specific customer contacts record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public CustContact Get(long id)
        {
            return _commands.Get(ActiveUser, id);
        }

        /// <summary>
        /// Creates a new customer contacts record
        /// </summary>
        /// <param name="custContact"></param>
        /// <returns></returns>

        public CustContact Post(CustContact custContact)
        {
            return _commands.Post(ActiveUser, custContact);
        }

        /// <summary>
        /// Updates an existing customer contacts record
        /// </summary>
        /// <param name="custContact"></param>
        /// <returns></returns>

        public CustContact Put(CustContact custContact)
        {
            return _commands.Put(ActiveUser, custContact);
        }

        /// <summary>
        /// Deletes a specific customer contacts record based on the userid
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>

        public int Delete(long id)
        {
            return _commands.Delete(ActiveUser, id);
        }

        /// <summary>
        /// Deletes a list of customer contacts record
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>

        public IList<IdRefLangName> Delete(List<long> ids, int statusId)
        {
            return _commands.Delete(ActiveUser, ids, statusId);
        }

        public CustContact Patch(CustContact entity)
        {
            throw new NotImplementedException();
        }
    }
}