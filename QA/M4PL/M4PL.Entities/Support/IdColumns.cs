/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 IdColumns
Purpose:                                      Contains objects related to IdColumns
==========================================================================================================*/

namespace M4PL.Entities.Support
{
    public class IdColumns
    {
        /// <summary>
        ///
        /// </summary>
        public IdColumns()
        {
        }

        public IdColumns(int id, params string[] columns)
        {
            Id = id;
            Columns = columns;
        }

        public int Id { get; set; }

        public string[] Columns { get; set; }
    }
}