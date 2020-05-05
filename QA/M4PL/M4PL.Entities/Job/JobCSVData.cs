/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Prashant Aggarwal
Date Programmed:                              02/04/2020
Program Name:                                 JobCSVData
Purpose:                                      Contains objects related to Job CSV Data
==========================================================================================================*/
namespace M4PL.Entities.Job
{
	public class JobCSVData
	{
		public long ProgramId { get; set; }

		public byte[] FileContent { get; set; }

        public string FileContentBase64 { get; set; }
    }
}
