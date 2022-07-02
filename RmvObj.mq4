//+------------------------------------------------------------------+
//|                                                       RmvObj.mq4 |
//|                                     Copyright 2020, SinaShaabaz. |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SinaShaabaz."
#property link      "sinashaabaz@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs


input string ObjName = "Name123";
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   if(ObjName == "Name123")
      {
      ObjectsDeleteAll();
      }
   else if(ObjName != "Name123")
      {
      ObjectDelete(ObjName);
      }
  }
//+------------------------------------------------------------------+
