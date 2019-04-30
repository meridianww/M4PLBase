/*Copyright(2016) Meridian Worldwide Transportation Group
All Rights Reserved Worldwide
==========================================================================================================
Program Title:                                Meridian 4th Party Logistics(M4PL)
Programmer:                                   Akhil
Date Programmed:                              10/10/2017
Program Name:                                 ConditionalOperator
Purpose:                                      Contains objects related to ConditionalOperator
==========================================================================================================*/
namespace M4PL.Entities.Support
{
    public class ConditionalOperator
    {
        public RelationalOperator Operator { get; set; }
        public string SysRefName { get; set; }
        public string LangName { get; set; }
        public bool IsDefault { get; set; }
    }
}