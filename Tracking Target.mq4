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

input int Ticket = 0; // Order Ticket
input double Target = 0; // Target to Start Tracking System
enum TimeFrames
      {
      M1=1,
      M5=5,
      M15=15,
      M30=30,
      H1=60,
      H4=240,
      D1=1440,
      W1=10080,
      MN=43200
      };
input TimeFrames Timeframe; // Tracking TimeFrame
input int myPeriod = 5; // Tracking Period
input int CloseHour = 23; // Hour of Closing Order
input int CloseMin = 42; // Minute of Closing Order

int StepFlag = 0;
string mySymbol;
double SLold = 0;
double SLnew = 1;
int SLFlag = 0;
int SLmodifyFlag = 0;
int NotFlag = 0;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- ORDER TYPE, TICKET AND TARGET CHECKING
   if(OrderSelect(Ticket,SELECT_BY_TICKET)==true)
      {
      if(Target == 0) // TP's NOT set!
         {
         Alert("Please Enter TARGET!");
         ExpertRemove();
         }  
      if(OrderStopLoss() == 0) // SL NOT set!
         {
         Alert("Please Enter STOPLOSS!");
         ExpertRemove();
         }
      else if(OrderStopLoss() != 0)
         {
         mySymbol = Symbol();
         if((OrderType() == 0) || (OrderType() == 1)) // Buy|Sell Order is Open
            {
            ObjectDelete("TARGET-Line");
            ObjectCreate("TARGET-Line", OBJ_HLINE , 0, Time[0], Target);
               ObjectSetString(0,"TARGET-Line", OBJPROP_TEXT, "Target-Line");
               ObjectSet("TARGET-Line", OBJPROP_STYLE, STYLE_DASH);
               ObjectSet("TARGET-Line", OBJPROP_COLOR, clrLimeGreen);
               ObjectSet("TARGET-Line", OBJPROP_WIDTH, 1);
               ObjectSet("TARGET-Line", OBJPROP_BACK, false);
               ObjectSet("TARGET-Line", OBJPROP_READONLY, true);
               ObjectSet("TARGET-Line", OBJPROP_SELECTABLE, false);
            }
      
         if((OrderType() == 0) && (Target < OrderOpenPrice()) ) //--- IF ORDER TYPE AND TARGET IS NOT THE SAME!
            {
            ObjectDelete("TARGET-Line");
            Alert("Target is Below the OpenPrice in BUY ORDER.");
            ExpertRemove();
            }
         
         else if((OrderType() == 1) && (Target > OrderOpenPrice()) ) //--- IF ORDER TYPE AND TARGET IS NOT THE SAME!
            {
            ObjectDelete("TARGET-Line");
            Alert("Target is Above the OpenPrice in SELL ORDER.");
            ExpertRemove();
            }
         
         if(OrderType() == 0)
            {
            StepFlag = 1;
            }
         else if(OrderType() == 1)
            {
            StepFlag = -1;
            }
         }
      }
      
   else if((OrderSelect(Ticket,SELECT_BY_TICKET)==false)) //--- IF TICKET ORDER IS INCORRECT!
      {
      Alert("Ticket Order is INCORRECT.");
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
  
  if(OrderSelect(Ticket,SELECT_BY_TICKET)==true)
      {
      //-- Checking Time:  
        if(TimeHour(TimeCurrent()) >= CloseHour)
         {
         if(TimeMinute(TimeCurrent()) >= CloseMin)
            {
            bool CloseOrder = OrderClose(Ticket,OrderLots(),Bid,1000,clrDarkBlue);
            ObjectDelete("TARGET-Line");
            ObjectDelete("SL-Line");
            ExpertRemove();
            }
         }
      //--- IF TARGET HAS BEEN TOUCHED IN BUY ORDER!
         if((StepFlag == 1) && (Bid > Target))
            {
            ObjectDelete("TARGET-Line");
            StepFlag = 2;
            bool modifySL = OrderModify(Ticket,OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()+0.2*(OrderOpenPrice()-OrderStopLoss()),Digits),OrderTakeProfit(),0,clrNONE);
            SLnew = (iLow(mySymbol,Timeframe,iLowest(mySymbol,Timeframe,MODE_LOW,myPeriod+1,0)))-0.5*iATR(mySymbol,Timeframe,63,0);
            }
      //--- IF TARGET HAS BEEN TOUCHED IN SELL ORDER!
         else if((StepFlag == -1) && (Ask < Target))
            {
            ObjectDelete("TARGET-Line");
            StepFlag = -2;
            bool modifySL = OrderModify(Ticket,OrderOpenPrice(),NormalizeDouble(OrderOpenPrice()-0.2*(OrderStopLoss()-OrderOpenPrice()),Digits),OrderTakeProfit(),0,clrNONE);
            SLnew = (iHigh(mySymbol,Timeframe,iHighest(mySymbol,Timeframe,MODE_HIGH,myPeriod+1,0)))+0.5*iATR(mySymbol,Timeframe,63,0);
            }
      //--- IF STOPLOSS HAS BEEN TOUCHED IN BUY ORDER!
         if(StepFlag == 2)
            {
            if(SLnew > OrderOpenPrice() && (SLnew > OrderStopLoss())) //-- RUN If STOPLOSS MORE THAN OPENPRICE!
               {
               if(SLnew > Bid)
                  {
                  bool CloseOrder = OrderClose(Ticket,OrderLots(),Bid,1000,clrDarkBlue);
                  ObjectDelete("SL-Line");
                  SLFlag = 1;
                  ExpertRemove();
                  }
               SLnew = (iLow(mySymbol,Timeframe,iLowest(mySymbol,Timeframe,MODE_LOW,myPeriod+1,0)))-0.5*iATR(mySymbol,Timeframe,63,0);
               if((SLold != SLnew) && (SLFlag == 0))
                  {
                  ObjectDelete("SL-Line");
                  if(NotFlag == 0)
                     {
                     bool Notif =  SendNotification(Symbol()+": StopLoss has been set.");
                     NotFlag = 1;
                     }
                  ObjectCreate("SL-Line", OBJ_HLINE , 0, Time[0], SLnew);
                          ObjectSet("SL-Line", OBJPROP_STYLE, STYLE_DASH);
                          ObjectSet("SL-Line", OBJPROP_COLOR, clrCrimson);
                          ObjectSet("SL-Line", OBJPROP_WIDTH, 1);
                          ObjectSet("SL-Line", OBJPROP_BACK, false);
                          ObjectSet("SL-Line", OBJPROP_READONLY, true);
                          ObjectSet("SL-Line", OBJPROP_SELECTABLE, false);
                  SLold = SLnew;
                  }
               }
            else if(SLnew < OrderOpenPrice() && (SLnew < OrderStopLoss())) //-- RUN If STOPLOSS LESS THAN OPENPRICE!
               {
               ObjectDelete("SL-Line");
               NotFlag = 0;
               }
            }
         //--- IF STOPLOSS HAS BEEN TOUCHED IN SELL ORDER!
         else if(StepFlag == -2)
            {
            if((SLnew < OrderOpenPrice()) || (SLnew < OrderStopLoss())) //-- RUN If STOPLOSS LESS THAN OPENPRICE!
               {
               if(SLnew < Ask)
                  {
                  bool CloseOrder = OrderClose(Ticket,OrderLots(),Ask,1000,clrDarkBlue);
                  ObjectDelete("SL-Line");
                  SLFlag = 1;
                  ExpertRemove();
                  }
               SLnew = (iHigh(mySymbol,Timeframe,iHighest(mySymbol,Timeframe,MODE_HIGH,myPeriod+1,0)))+0.5*iATR(mySymbol,Timeframe,63,0);
               if(SLold != SLnew && SLFlag == 0)
                  {
                  ObjectDelete("SL-Line");
                  if(NotFlag == 0)
                     {
                     bool Notif =  SendNotification(Symbol()+": StopLoss has been set.");
                     NotFlag = 1;
                     }
                  ObjectCreate("SL-Line", OBJ_HLINE , 0, Time[0], SLnew);
                          ObjectSet("SL-Line", OBJPROP_STYLE, STYLE_DASH);
                          ObjectSet("SL-Line", OBJPROP_COLOR, clrCrimson);
                          ObjectSet("SL-Line", OBJPROP_WIDTH, 1);
                          ObjectSet("SL-Line", OBJPROP_BACK, false);
                          ObjectSet("SL-Line", OBJPROP_READONLY, true);
                          ObjectSet("SL-Line", OBJPROP_SELECTABLE, false);
                  SLold = SLnew;
                  }
               }
            else if(SLnew > OrderOpenPrice() || (SLnew > OrderStopLoss())) //-- DON'T RUN If STOPLOSS MORE THAN OPENPRICE!
               {
               ObjectDelete("SL-Line");
               NotFlag = 0;
               }
            }
      }
   }
//---END
