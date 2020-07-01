/*Copyright(2019) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
=============================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Kamal
Date Programmed:                              04/18/2020
Program Name:                                 IJobSignatureCommands
Purpose:                                      Set of rules for IJobSignatureCommands
=============================================================================================================*/

using M4PL.Entities.Signature;

namespace M4PL.Business.Signature
{
    public interface IJobSignatureCommands : IBaseCommands<JobSignature>
    {
        bool InsertJobSignature(JobSignature jobSignature);
    }
}
