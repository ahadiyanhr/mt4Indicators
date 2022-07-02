//+------------------------------------------------------------------+
//|                                                    FiboLevel.mq4 |
//|                                     Copyright 2020, SinaShaabaz. |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, SinaShaabaz."
#property link      "sinashaabaz@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs

input string FiboName = "Fibo";
double HighRange; // High Price of Range
double LowRange; // Low Price of Range
double Price;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   HighRange = ObjectGet(FiboName, OBJPROP_PRICE1); // New High Price of Range
   LowRange = ObjectGet(FiboName, OBJPROP_PRICE2); // New Low Price of Range
   Price = (HighRange - LowRange)/3;
   if(HighRange < LowRange)
      {
      bool  E0 = ObjectSetFiboDescription(FiboName,5,"E0 - "+DoubleToString((HighRange+Price),Digits));
      bool  E1 = ObjectSetFiboDescription(FiboName,4,"E1 - "+DoubleToString(HighRange,Digits));
      bool  E2 = ObjectSetFiboDescription(FiboName,3,"E2 - "+DoubleToString((HighRange-Price),Digits));
      bool  E3 = ObjectSetFiboDescription(FiboName,2,"E3 - "+DoubleToString((HighRange-2*Price),Digits));
      bool  E5 = ObjectSetFiboDescription(FiboName,1,"E5 - "+DoubleToString(LowRange,Digits));
      bool  E6 = ObjectSetFiboDescription(FiboName,0,"E6 - "+DoubleToString((LowRange-Price),Digits));
      }
   if(HighRange > LowRange)
      {
      bool  E0 = ObjectSetFiboDescription(FiboName,0,"E0 - "+DoubleToString((LowRange-Price),Digits));
      bool  E1 = ObjectSetFiboDescription(FiboName,1,"E1 - "+DoubleToString(LowRange,Digits));
      bool  E2 = ObjectSetFiboDescription(FiboName,2,"E2 - "+DoubleToString((LowRange+Price),Digits));
      bool  E3 = ObjectSetFiboDescription(FiboName,3,"E3 - "+DoubleToString((LowRange+2*Price),Digits));
      bool  E5 = ObjectSetFiboDescription(FiboName,4,"E5 - "+DoubleToString((HighRange),Digits));
      bool  E6 = ObjectSetFiboDescription(FiboName,5,"E6 - "+DoubleToString((HighRange+Price),Digits));
      }
   
    
   
   ObjectSet(FiboName, OBJPROP_READONLY, true);
   ObjectSet(FiboName, OBJPROP_SELECTABLE, false);
  }
//+------------------------------------------------------------------+
