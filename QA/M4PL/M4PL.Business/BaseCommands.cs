/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=================================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 BaseCommands
Purpose:
===================================================================================================================*/

using M4PL.Entities.Support;

namespace M4PL.Business
{
    public abstract class BaseCommands<TEntity>
    {
        public ActiveUser ActiveUser { get; set; }
    }
}