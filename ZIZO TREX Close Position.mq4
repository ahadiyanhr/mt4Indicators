//+------------------------------------------------------------------+
//|                                     ZIZO TREX Close Position.mq4 |
//|                           Copyright 2020, ZIZO TREX SinaShaabaz. |
//|                                            sinashaabaz@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, ZIZO TREX , By Sina Shaabaz."
#property link      "sinashaabaz@gmail.com"
#property version   "1.50"
#property strict
#property show_inputs


input int TriggerTime = 15; // Trigger Timeframe
input int myPeriod = 5; // Exit Period
input double TrillTP = 0.7; // SL Trilling Target
input double TrillSL = 0.1; // SL Trilling Factor
int Index = 0; // Order Index
int mainFlag = 0; // Flag for Main Flow of EA 
double oldSL = 0; // Old Stoploss for Iterations
double newSL = 1; // New Stoploss for Iterations
double Target = 0; // TP of Order
double StopLoss = 0; // SL of Order
int closeFlag = 0; // Flag for Declaration of Closing Order
int slFlag = 0; // Flag for Declaration of Modifying Stoploss of Order

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  //--- ORDER TYPE, TICKET AND TARGET CHECKING
   if(OrderSelect(Index,SELECT_BY_POS,MODE_TRADES)==true)
      {
      Target = OrderTakeProfit();
      StopLoss = OrderStopLoss();
      //--- IF StopLoss IS NOT SET!
      if((mainFlag == 0) && (StopLoss == 0))
         {
         Alert("SL has NOT been Set for Order.");
         ObjectDelete("TP-Line");
         ExpertRemove();
         }
      //--- IF TARGET IS NOT SET!
      if((mainFlag == 0) && (Target == 0))
         {
         Alert("TP has NOT been Set for Order.");
         ObjectDelete("TP-Line");
         ExpertRemove();
         }
      bool removeTP = OrderModify(OrderTicket(),OrderOpenPrice(),OrderStopLoss(),0,0,clrRed);
      if((mainFlag==0)&&(Target!=0)&&(StopLoss!=0)&&(OrderType()==0||OrderType()==2||OrderType()==4)&&(Target>OrderOpenPrice()))
         {
         mainFlag = 1;
         ObjectCreate("TP-Line", OBJ_HLINE , 0, Time[0], Target);
              ObjectSet("TP-Line", OBJPROP_STYLE, STYLE_DASH);
              ObjectSet("TP-Line", OBJPROP_COLOR, clrLimeGreen);
              ObjectSet("TP-Line", OBJPROP_WIDTH, 1);
              ObjectSet("TP-Line", OBJPROP_BACK, true);
              ObjectSet("TP-Line", OBJPROP_READONLY, true);
              ObjectSet("TP-Line", OBJPROP_SELECTABLE, false);
         }
      else if((mainFlag==0)&&(Target!=0)&&(StopLoss!=0)&&(OrderType()==1||OrderType()==3||OrderType()==5)&&(Target<OrderOpenPrice()))
         {
         mainFlag = -1;
         ObjectCreate("TP-Line", OBJ_HLINE , 0, Time[0], Target);
              ObjectSet("TP-Line", OBJPROP_STYLE, STYLE_DASH);
              ObjectSet("TP-Line", OBJPROP_COLOR, clrLimeGreen);
              ObjectSet("TP-Line", OBJPROP_WIDTH, 1);
              ObjectSet("TP-Line", OBJPROP_BACK, true);
              ObjectSet("TP-Line", OBJPROP_READONLY, true);
              ObjectSet("TP-Line", OBJPROP_SELECTABLE, false);
         }
//--- IF ORDER TYPE AND TARGET IS NOT THE SAME!
      else if((mainFlag==0)&&(Target!=0)&&(OrderType()==0||OrderType()==2||OrderType()==4)&&Target<OrderOpenPrice())
         {
         Alert("Target is Below the OpenPrice.");
         ObjectDelete("TP-Line");
         ExpertRemove();
         }
//--- IF ORDER TYPE AND TARGET IS NOT THE SAME!
      else if((mainFlag==0)&&(Target!=0)&&(OrderType()==1||OrderType()==3||OrderType()==5)&&Target>OrderOpenPrice())
         {
         Alert("Target is Above the OpenPrice.");
         ObjectDelete("TP-Line");
         ExpertRemove();
         }
      }
   else if(OrderSelect(Index,SELECT_BY_POS,MODE_TRADES)==false)
      {
      Alert("Position Has Been Closed or NOT Exist.");
      ObjectDelete("TP-Line");
      ExpertRemove();
      }
      
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
   if(OrderSelect(Index,SELECT_BY_POS,MODE_TRADES)==true)
      {  
   //--- IF 70% TARGET HAS BEEN TOUCHED IN BUY ORDER!
      if((mainFlag==1)&&(slFlag==0)&&(iClose(NULL,TriggerTime,0)>(OrderOpenPrice()+TrillTP*(Target-OrderOpenPrice()))))
         {
         slFlag = 1;
         bool Modify=OrderModify(OrderTicket(),OrderOpenPrice(),(OrderOpenPrice()+TrillSL*(Target-OrderOpenPrice())),0,0,clrRed);
         }
   //--- IF 70% TARGET HAS BEEN TOUCHED IN SELL ORDER!
      if((mainFlag == -1) && (slFlag == 0) && (iClose(NULL,TriggerTime,0)<(OrderOpenPrice()-TrillTP*(OrderOpenPrice()-Target))))
         {
         slFlag = 1;
         bool Modify=OrderModify(OrderTicket(),OrderOpenPrice(),(OrderOpenPrice()-TrillSL*(OrderOpenPrice()-Target)),0,0,clrRed);
         }
   //--- IF TARGET HAS BEEN TOUCHED IN BUY ORDER!
      if((mainFlag == 1) && (iClose(NULL,TriggerTime,0) > Target))
         {
         mainFlag = 2;
         newSL = (iLow(NULL,TriggerTime,iLowest(NULL,TriggerTime,MODE_LOW,myPeriod+1,0)));
         ObjectDelete("TP-Line");
         }
   //--- IF TARGET HAS BEEN TOUCHED IN SELL ORDER!
      else if((mainFlag == -1) && (iClose(NULL,TriggerTime,0) < Target))
         {
         mainFlag = -2;
         newSL = (iHigh(NULL,TriggerTime,iHighest(NULL,TriggerTime,MODE_HIGH,myPeriod+1,0)));
         ObjectDelete("TP-Line");
         }
   //--- IF STOPLOSS HAS BEEN TOUCHED IN BUY ORDER!
      if(mainFlag == 2)
         {
         if((newSL > (iClose(NULL,TriggerTime,0))))
            {
            bool Ans = OrderClose(OrderTicket(),OrderLots(),Bid,1000,clrDeepPink);
            ObjectDelete("SL-Line");
            closeFlag = 1;
            ExpertRemove();
            }
         newSL = (iLow(NULL,TriggerTime,iLowest(NULL,TriggerTime,MODE_LOW,myPeriod+1,0)));
         if(oldSL != newSL && closeFlag == 0)
            {
            ObjectDelete("SL-Line");
            ObjectCreate("SL-Line", OBJ_HLINE , 0, Time[0], newSL);
                    ObjectSet("SL-Line", OBJPROP_STYLE, STYLE_DASH);
                    ObjectSet("SL-Line", OBJPROP_COLOR, clrCrimson);
                    ObjectSet("SL-Line", OBJPROP_WIDTH, 1);
                    ObjectSet("SL-Line", OBJPROP_BACK, true);
                    ObjectSet("SL-Line", OBJPROP_READONLY, true);
                    ObjectSet("SL-Line", OBJPROP_SELECTABLE, false);
            oldSL = newSL;
            }
         }
      //--- IF STOPLOSS HAS BEEN TOUCHED IN SELL ORDER!
      else if(mainFlag == -2)
         {
         if(newSL < (iClose(NULL,TriggerTime,0)))
            {
            bool Ans = OrderClose(OrderTicket(),OrderLots(),Ask,1000,clrDeepPink);
            ObjectDelete("SL-Line");
            closeFlag = 1;
            ExpertRemove();
            }
         newSL = (iHigh(NULL,TriggerTime,iHighest(NULL,TriggerTime,MODE_HIGH,myPeriod+1,0)));
         if(oldSL != newSL && closeFlag == 0)
            {
            ObjectDelete("SL-Line");
            ObjectCreate("SL-Line", OBJ_HLINE , 0, Time[0], newSL);
                    ObjectSet("SL-Line", OBJPROP_STYLE, STYLE_DASH);
                    ObjectSet("SL-Line", OBJPROP_COLOR, clrCrimson);
                    ObjectSet("SL-Line", OBJPROP_WIDTH, 1);
                    ObjectSet("SL-Line", OBJPROP_BACK, true);
                    ObjectSet("SL-Line", OBJPROP_READONLY, true);
                    ObjectSet("SL-Line", OBJPROP_SELECTABLE, false);
            oldSL = newSL;
            }
         }
      }
   else if(OrderSelect(Index,SELECT_BY_POS,MODE_TRADES)==false)
      {
      Alert("Position Has Been Closed by Others.");
      ObjectDelete("TP-Line");
      ObjectDelete("SL-Line");
      ExpertRemove();
      }      
  }
//---END
