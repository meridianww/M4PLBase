﻿#region Copyright
/******************************************************************************
* Copyright (C) 2016-2020 Meridian Worldwide Transportation Group - All Rights Reserved.
*
* Proprietary and confidential. Unauthorized copying of this file, via any
* medium is strictly prohibited without the explicit permission of Meridian Worldwide Transportation Group.
******************************************************************************/
#endregion Copyright

//=============================================================================================================
// Program Title:                                Meridian 4th Party Logistics(M4PL)
// Programmer:                                   Kirty Anurag
// Date Programmed:                              10/10/2017
// Program Name:                                 ProgramCommands
// Purpose:                                      Contains commands to perform CRUD on Program
//=============================================================================================================

using M4PL.DataAccess.SQLSerializer.Serializer;
using M4PL.Entities;
using M4PL.Entities.Event;
using M4PL.Entities.Program;
using M4PL.Entities.Support;
using M4PL.Utilities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace M4PL.DataAccess.Program
{
    public class PrgEventManagementCommands : BaseCommands<PrgEventManagement>
    {
        /// <summary>
        /// Gets list of Program records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="pagedDataInfo"></param>
        /// <returns></returns>
        public static IList<PrgEventManagement> GetPagedData(ActiveUser activeUser, PagedDataInfo pagedDataInfo)
        {
            return GetPagedData(activeUser, pagedDataInfo, StoredProceduresConstant.GetEventManagementView, EntitiesAlias.PrgEventManagement);
        }

        /// <summary>
        /// Gets the specific Program record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static PrgEventManagement Get(ActiveUser activeUser, long id)
        {
            // return new PrgEventManagement() { Id = 1, IsBodyHtml = true, EventName = "POD Upload", EventTypeId = 4, StatusId = 1, EventShortName = "PU", FromMail = "prashant.aggarwal@dreamorbit.com", Description = "This is test email.", ToEmail = "kirty.anurag@dreamorbit.com", CcEMail = "Manoj.kumar@dreamorbit.com" };

            SetCollection sets = new SetCollection();
            sets.AddSet<EventSubscriber>("ToEmailEventSubscriberRelation");
            sets.AddSet<EventSubscriber>("CCEmailEventSubscriberRelation");
            sets.AddSet<PrgEventManagement>("Event");

            var parameters = new List<Parameter>
                   {
                       new Parameter("@EventId", id),
                   };
            SetCollection setCollection = GetSetCollection(sets, activeUser, parameters, StoredProceduresConstant.GetEventManagement);

            var ToEmailEventSubscriberRelation = sets.GetSet<EventSubscriber>("ToEmailEventSubscriberRelation");
            var CCEmailEventSubscriberRelation = sets.GetSet<EventSubscriber>("CCEmailEventSubscriberRelation");
            var eventDetails = sets.GetSet<PrgEventManagement>("Event").ToList().FirstOrDefault();
            if (eventDetails != null)
            {
                eventDetails.SubscribersSelectedForToEmail = ToEmailEventSubscriberRelation;
                eventDetails.SubscribersSelectedForCCEmail = CCEmailEventSubscriberRelation;
            }
            return eventDetails;
        }

        /// <summary>
        /// Creates a new Program record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgEventManagement"></param>
        /// <returns></returns>

        public static PrgEventManagement Post(ActiveUser activeUser, PrgEventManagement prgEventManagement)
        {
            var parameters = GetParameters(prgEventManagement);
            parameters.AddRange(activeUser.PostDefaultParams(prgEventManagement));
            var result = SqlSerializer.Default.ExecuteScalar<int>(StoredProceduresConstant.InsEventManagement, parameters.ToArray(), storedProcedure: true);
            return Get(activeUser, result);
        }

        /// <summary>
        /// Updates the existing Program recordrecords
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="prgEventManagement"></param>
        /// <returns></returns>

        public static PrgEventManagement Put(ActiveUser activeUser, PrgEventManagement prgEventManagement)
        {
            var parameters = GetParameters(prgEventManagement);
            parameters.AddRange(activeUser.PutDefaultParams(prgEventManagement.Id, prgEventManagement));
            parameters.Add(new Parameter("@EventId", prgEventManagement.Id));
            var result = SqlSerializer.Default.ExecuteScalar<int>(StoredProceduresConstant.UpdProgramEventManagement, parameters.ToArray(), storedProcedure: true);
            return Get(activeUser, prgEventManagement.Id);
        }

        /// <summary>
        /// Deletes a specific Program record
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="id"></param>
        /// <returns></returns>

        public static int Delete(ActiveUser activeUser, long id)
        {
            //return Delete(activeUser, id, StoredProceduresConstant.DeleteOrganizationActRole);
            return 0;
        }

        /// <summary>
        /// Deletes list of Program records
        /// </summary>
        /// <param name="activeUser"></param>
        /// <param name="ids"></param>
        /// <returns></returns>

        public static IList<IdRefLangName> Delete(ActiveUser activeUser, List<long> ids, int statusId)
        {
            return Delete(activeUser, ids, EntitiesAlias.PrgEventManagement, statusId, ReservedKeysEnum.StatusId);
        }

        public static List<EventSubscriber> GetEventSubscriber()
        {
            var parameters = new List<Parameter>
            {
            };
            var result = SqlSerializer.Default.DeserializeMultiRecords<EventSubscriber>(StoredProceduresConstant.GetEventSubscriber, parameters.ToArray(), storedProcedure: true);
            return result;
        }



        /// <summary>
        /// Gets list of parameters required for the Program Module
        /// </summary>
        /// <param name="PrgEventManagement"></param>
        /// <returns></returns>

        private static List<Parameter> GetParameters(Entities.Program.PrgEventManagement PrgEventManagement)
        {

            PrgEventManagement.SubscriberAndSubscriberTypeMappingList = new List<Entities.Event.EventSubscriberAndSubscriberType>();

            SetCollection sets = new SetCollection();
            sets.AddSet<EventSubscriber>("EventSubscriber");
            sets.AddSet<EventSubscriberType>("EventSubscriberType");

            var parameters = new List<Parameter>
            {

            };
            SetCollection setCollection = GetSetCollection(sets, new ActiveUser(), parameters, StoredProceduresConstant.GetEventSubscriberAndSubscriberType);

            var eventSubscriber = sets.GetSet<EventSubscriber>("EventSubscriber");
            var eventSubscriberType = sets.GetSet<EventSubscriberType>("EventSubscriberType");

            var toEmailSubscribers = !string.IsNullOrEmpty(PrgEventManagement.ToEmailSubscribers)
                ? PrgEventManagement.ToEmailSubscribers.Split(',') : null;
            var ccEmailSubscribers = !string.IsNullOrEmpty(PrgEventManagement.CcEMailSubscribers)
                ? PrgEventManagement.CcEMailSubscribers.Split(',') : null;

            int toEmailSubscriberTypeId = eventSubscriberType.Find(obj => obj.EventSubscriberTypeName == "To").Id;
            int ccEmailSubscriberTypeId = eventSubscriberType.Find(obj => obj.EventSubscriberTypeName == "CC").Id;

            if (toEmailSubscribers != null)
            {
                foreach (var item in toEmailSubscribers)
                {
                    var subscriberId = eventSubscriber.Find(obj => obj.SubscriberDescription == item).Id;
                    PrgEventManagement.SubscriberAndSubscriberTypeMappingList.Add(new Entities.Event.EventSubscriberAndSubscriberType() { SubscriberId = subscriberId, SubscriberTypeId = toEmailSubscriberTypeId });
                }
            }
            if (ccEmailSubscribers != null)
            {
                foreach (var item in ccEmailSubscribers)
                {
                    var subscriberId = eventSubscriber.Find(obj => obj.SubscriberDescription == item).Id;
                    PrgEventManagement.SubscriberAndSubscriberTypeMappingList.Add(new Entities.Event.EventSubscriberAndSubscriberType() { SubscriberId = subscriberId, SubscriberTypeId = ccEmailSubscriberTypeId });
                }
            }


            var subscriberAndSubscriberTypeMapping = PrgEventManagement.SubscriberAndSubscriberTypeMappingList.ToDataTable();
            var parameters2 = new List<Parameter>
            {
                new Parameter("@EventName",PrgEventManagement.EventName),
                new Parameter("@EventShortName",PrgEventManagement.EventShortName),
                new Parameter("@FromMail",PrgEventManagement.FromMail),
                new Parameter("@Description",PrgEventManagement.Description),
                new Parameter("@XSLTPath",""),
                new Parameter("@EventTypeId",PrgEventManagement.EventTypeId),
                new Parameter("@StatusId",PrgEventManagement.StatusId),
                new Parameter("@ParentId",PrgEventManagement.ParentId),
                new Parameter("@IsBodyHtml",PrgEventManagement.IsBodyHtml),
                new Parameter("@Subject",PrgEventManagement.Subject),
                new Parameter("@ToEmailAddress",PrgEventManagement.ToEmail),
                new Parameter("@CCEmailAddress",PrgEventManagement.CcEmail),
                new Parameter("@uttEventSubscriber",subscriberAndSubscriberTypeMapping,"dbo.uttEventSubscriber")
            };
            return parameters2;
        }
    }
}