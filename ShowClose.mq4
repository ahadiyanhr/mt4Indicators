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


input int NoOfCandles = 1;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- 
   datetime date1 = iTime(0, PERIOD_D1, NoOfCandles-1);
   double close = iClose(0, PERIOD_D1, NoOfCandles);
   ObjectCreate("close "+TimeToStr(date1), OBJ_TREND, 0, date1, close, TimeCurrent(), close);
   ObjectSet("close "+TimeToStr(date1), OBJPROP_BACK, False);
   ObjectSet("close "+TimeToStr(date1), OBJPROP_READONLY, true);
   ObjectSet("close "+TimeToStr(date1), OBJPROP_SELECTABLE, false);
   ObjectSetText("close "+TimeToStr(date1), DoubleToStr(close), 0, NULL, clrRed);
   ObjectSet("close "+TimeToStr(date1), OBJPROP_COLOR, clrMediumSeaGreen);
   ObjectSet("close "+TimeToStr(date1), OBJPROP_WIDTH, 2);
  }
//+------------------------------------------------------------------+
