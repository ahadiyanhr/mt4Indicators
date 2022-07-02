//+------------------------------------------------------------------+
//|                                               ClosePostionEA.mq4 |
//|                                                   Copyright 2020 |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, Sina Shaabaz"
#property link      "sinashaabaz@gmail.com"
#property version   "1.00"
#property strict
#property show_inputs

input int Ticket = 320225124;
input double Target = 1.0000;
input int TriggerTime = 15;
input int myPeriod = 10;
int startEA = 0;
double SLold = 0;
double SLnew = 1;
int SLFlag = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- ORDER TYPE, TICKET AND TARGET CHECKING
   if(OrderSelect(Ticket,SELECT_BY_TICKET)==true)
      {
      if((startEA==0)&&(OrderType()==0||OrderType()==2||OrderType()==4)&&Target>OrderOpenPrice())
         {
         startEA = 1;
         ObjectCreate("TP-Line", OBJ_HLINE , 0, Time[0], Target);
              ObjectSet("TP-Line", OBJPROP_STYLE, STYLE_DASH);
              ObjectSet("TP-Line", OBJPROP_COLOR, clrLimeGreen);
              ObjectSet("TP-Line", OBJPROP_WIDTH, 0);
              ObjectSet("TP-Line", OBJPROP_BACK, true);
              ObjectSet("TP-Line", OBJPROP_READONLY, true);
              ObjectSet("TP-Line", OBJPROP_SELECTABLE, false);
         }
      else if((startEA==0)&&(OrderType()==1||OrderType()==3||OrderType()==5)&&Target<OrderOpenPrice())
         {
         startEA = -1;
         ObjectCreate("TP-Line", OBJ_HLINE , 0, Time[0], Target);
              ObjectSet("TP-Line", OBJPROP_STYLE, STYLE_DASH);
              ObjectSet("TP-Line", OBJPROP_COLOR, clrLimeGreen);
              ObjectSet("TP-Line", OBJPROP_WIDTH, 0);
              ObjectSet("TP-Line", OBJPROP_BACK, true);
              ObjectSet("TP-Line", OBJPROP_READONLY, true);
              ObjectSet("TP-Line", OBJPROP_SELECTABLE, false);
         }
      else if(OrderSelect(Ticket,SELECT_BY_TICKET)==false)
         {
         Alert("Position Has Been Closed by StopLoss.");
         ExpertRemove();
         }
//--- IF ORDER TYPE AND TARGET IS NOT THE SAME!
      else if((startEA==0)&&(OrderType()==0||OrderType()==2||OrderType()==4)&&Target<OrderOpenPrice())
         {
         Alert("Target is Below the OpenPrice.");
         ExpertRemove();
         }
//--- IF ORDER TYPE AND TARGET IS NOT THE SAME!
      else if((startEA==0)&&(OrderType()==1||OrderType()==3||OrderType()==5)&&Target>OrderOpenPrice())
         {
         Alert("Target is Above the OpenPrice.");
         ExpertRemove();
         }
      }
//--- IF TICKET ORDER IS INCORRECT!
   else if((OrderSelect(Ticket,SELECT_BY_TICKET)==false))
      {
      Alert("Ticket Order is Incorrect.");
      ExpertRemove();
      }
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- IF TARGET HAS BEEN TOUCHED IN BUY ORDER!
   if((startEA == 1) && (iClose(NULL,TriggerTime,0) > Target))
      {
      startEA = 2;
      SLnew = (iLow(NULL,TriggerTime,iLowest(NULL,TriggerTime,MODE_LOW,myPeriod+1,0)));
      ObjectDelete("TP-Line");
      }
//--- IF TARGET HAS BEEN TOUCHED IN SELL ORDER!
   else if((startEA == -1) && (iClose(NULL,TriggerTime,0) < Target))
      {
      startEA = -2;
      SLnew = (iHigh(NULL,TriggerTime,iHighest(NULL,TriggerTime,MODE_HIGH,myPeriod+1,0)));
      ObjectDelete("TP-Line");
      }
//--- IF STOPLOSS HAS BEEN TOUCHED IN BUY ORDER!
   if(startEA == 2)
      {
      if(SLnew > (iClose(NULL,TriggerTime,0)))
         {
         bool Ans = OrderClose(Ticket,OrderLots(),Bid,1000,clrDeepPink);
         ObjectDelete("SL-Line");
         SLFlag = 1;
         ExpertRemove();
         }
      SLnew = (iLow(NULL,TriggerTime,iLowest(NULL,TriggerTime,MODE_LOW,myPeriod+1,0)));
      if(SLold != SLnew && SLFlag == 0)
         {
         ObjectDelete("SL-Line");
         ObjectCreate("SL-Line", OBJ_HLINE , 0, Time[0], SLnew);
                 ObjectSet("SL-Line", OBJPROP_STYLE, STYLE_DASH);
                 ObjectSet("SL-Line", OBJPROP_COLOR, clrCrimson);
                 ObjectSet("SL-Line", OBJPROP_WIDTH, 0);
                 ObjectSet("SL-Line", OBJPROP_BACK, true);
                 ObjectSet("SL-Line", OBJPROP_READONLY, true);
                 ObjectSet("SL-Line", OBJPROP_SELECTABLE, false);
         SLold = SLnew;
         }
      }
   //--- IF STOPLOSS HAS BEEN TOUCHED IN SELL ORDER!
   else if(startEA == -2)
      {
      if(SLnew < (iClose(NULL,TriggerTime,0)))
         {
         bool Ans = OrderClose(Ticket,OrderLots(),Ask,1000,clrDeepPink);
         ObjectDelete("SL-Line");
         SLFlag = 1;
         ExpertRemove();
         }
      SLnew = (iHigh(NULL,TriggerTime,iHighest(NULL,TriggerTime,MODE_HIGH,myPeriod+1,0)));
      if(SLold != SLnew && SLFlag == 0)
         {
         ObjectDelete("SL-Line");
         ObjectCreate("SL-Line", OBJ_HLINE , 0, Time[0], SLnew);
                 ObjectSet("SL-Line", OBJPROP_STYLE, STYLE_DASH);
                 ObjectSet("SL-Line", OBJPROP_COLOR, clrCrimson);
                 ObjectSet("SL-Line", OBJPROP_WIDTH, 0);
                 ObjectSet("SL-Line", OBJPROP_BACK, true);
                 ObjectSet("SL-Line", OBJPROP_READONLY, true);
                 ObjectSet("SL-Line", OBJPROP_SELECTABLE, false);
         SLold = SLnew;
         }
      }
  }
//---END
